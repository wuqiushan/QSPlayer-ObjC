//
//  QSPlayerManage.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/17.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSPlayerManage.h"
#import <AVFoundation/AVFoundation.h>

@interface QSPlayerManage()
@property (nonatomic, strong) id              timeObserverToken;    /** 使用系统这个类似定时器，不用要释放 */
@end

@implementation QSPlayerManage

#pragma mark - 监听各种变化
- (void)addObserve {
    
    // 周期间隔观察, 这里是间隔1秒在主线程执行一次block
    CMTime observeTime = CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC);
    QSWeakSelf
    self.timeObserverToken = [self.avPlayer addPeriodicTimeObserverForInterval:observeTime queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSTimeInterval currentSec = CMTimeGetSeconds(weakSelf.avPlayer.currentItem.currentTime);
        NSTimeInterval totalSec   = CMTimeGetSeconds(weakSelf.avPlayer.currentItem.duration);
        [weakSelf.playerView.footView updateCurrentSec:currentSec totalSec:totalSec];
    }];
    
    // 增加播放状态监听KVO *** 这里要注意是item
    [self.avPlayerItem addObserver:self forKeyPath:@"status"
                           options:NSKeyValueObservingOptionNew context:nil];
    
    // 增加缓存进度监听KVO
    [self.avPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges"
                           options:NSKeyValueObservingOptionNew context:nil];
    
    // 增加缓冲不足以播放监听
//    [self.avPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
//
//    // 增加缓冲足够播放监听
//    [self.avPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    // 增加播放结束监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];
    
    // 增加耳机接入监听 指定观察[AVAudioSession sharedInstance],这些目前是多余的，主要是用到监听状态改变播放UI
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioRouteInOrOutAction:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:[AVAudioSession sharedInstance]];
    
    // 增加来电被打断监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(interruptionAction:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
}

- (void)removeObserve {
    
    // 移除周期间隔观察
    if (self.timeObserverToken) {
        [self.avPlayer removeTimeObserver:_timeObserverToken];
        _timeObserverToken = nil;
    }
    
    // 移除播放状态监听
    [self.avPlayerItem removeObserver:self forKeyPath:@"status"];
    
    // 移除缓存进度监听
    [self.avPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    // 增加缓冲不足以播放监听
//    [self.avPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
//
//    // 增加缓冲足够播放监听
//    [self.avPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    
    // 移除播放结束监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];
    
    // 移除耳机接入监听 指定观察[AVAudioSession sharedInstance]
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionRouteChangeNotification
                                                  object:[AVAudioSession sharedInstance]];
    
    // 移除来电被打断监听
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionInterruptionNotification
                                                  object:[AVAudioSession sharedInstance]];
}

#pragma mark 播放状态/缓存条
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    // 播放状态改变
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"status -> 未知");
                self.playerState = AVPlayerStateFail;
                break;
                
            case AVPlayerItemStatusReadyToPlay:
                // 当前状态是 “加载中...”或“缓冲中...” 这个时候直接播放
//                if ((self.playerState == AVPlayerStateReadying) || (self.playerState == AVPlayerStateBuffing)) {
//                    [self playVideo];
//                    self.playerState = AVPlayerStatePlaying;
//                }
                break;
                
            case AVPlayerItemStatusFailed:
                NSLog(@"status -> 播放失败");
                self.playerState = AVPlayerStateFail;
                break;
                
            default:
                break;
        }
    }
    // 缓冲进度计算
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        CMTimeRange timeRange = [[((NSArray *)(change[NSKeyValueChangeNewKey])) firstObject] CMTimeRangeValue];
        NSTimeInterval startSec = CMTimeGetSeconds(timeRange.start);
        NSTimeInterval durationSec = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval buffSec = startSec + durationSec;
        NSTimeInterval totalSec = CMTimeGetSeconds(((AVPlayerItem *)object).duration);
        [self.playerView.footView updateBuffProgress:(float)(buffSec / totalSec)];
        
        if ( ((self.playerState == AVPlayerStateReadying) && (buffSec > 2.0)) ||
            ((self.playerState == AVPlayerStateBuffing) && (buffSec > 10.0)) ) {
            [self playVideo];
            self.playerState = AVPlayerStatePlaying;
        }
    }
    // 缓冲不足以播放
//    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
//
//        if (![change[NSKeyValueChangeNewKey] boolValue]) {
//            NSLog(@"缓冲中");
////            [self pauseVideo];
//            self.playerState = AVPlayerStateBuffing;
//        }
//    }
    // 缓冲足够播放时
//    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
//        if ([change[NSKeyValueChangeNewKey] boolValue]) {
//            NSLog(@"可以放");
//            [self playVideo];
//            self.playerState = AVPlayerStatePlaying;
//        }
//    }
    
    [self.playerView.middleView updatePlayUIState:self.playerState];
}

#pragma mark 播放完成
- (void)playEnd {
    self.playerState = AVPlayerStateEnd;
    [self.playerView.middleView updatePlayUIState:self.playerState];
}

#pragma mark 耳机接入处理
- (void)audioRouteInOrOutAction:(NSNotification *)notif {
    NSDictionary *dic = notif.userInfo;
    AVAudioSession *session = notif.object;
    NSInteger routeChangeReason = [[dic valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    if (routeChangeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        // 拔出了耳机时，要打开扬声器(拔开耳机自动停止了)
        self.playerState = AVPlayerStatePause;
        QSWeakSelf
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.playerView.middleView updatePlayUIState:weakSelf.playerState];
        });
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
    else if (routeChangeReason == AVAudioSessionRouteChangeReasonNewDeviceAvailable) {
        // 插入了耳机时，要关闭扬声器
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }
}

#pragma mark 来电打断
/**
 如果不能打断尝试用这个方法：进入后台设置为NO, 进入前台设置为YES
 NSError *error = nil; [[AVAudioSession sharedInstance] setActive:NO error:&error];
 */
- (void)interruptionAction:(NSNotification *)notif {
    
    NSDictionary *dic = notif.userInfo;
    //AVAudioSession *session = notif.object;
    NSInteger interruptionType = [[dic valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
        self.playerState = AVPlayerStatePause;
        [self pauseVideo];
    }
    else {
        self.playerState = AVPlayerStatePlaying;
        [self playVideo];
    }
    [self.playerView.middleView updatePlayUIState:self.playerState];
}

@end
