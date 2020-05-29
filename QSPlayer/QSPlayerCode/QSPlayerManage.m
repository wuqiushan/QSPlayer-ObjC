//
//  QSPlayerManage.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSPlayerManage.h"
#import <AVFoundation/AVFoundation.h>
#import "QSPlayerParam.h"
#import "QSPlayerView.h"

#import "QSPlayerHeadView.h"
#import "QSPlayerMiddleView.h"
#import "QSPlayerFootView.h"

@interface QSPlayerManage()

@property (nonatomic, strong) AVPlayer      *avPlayer;       /** 播放器 */
@property (nonatomic, strong) AVPlayerItem  *avPlayerItem;   /** 播放器项，可以有多个 */
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;  /** 播放器显示层 */
@property (nonatomic, strong) QSPlayerView  *playerView;     /** 播放控制视图 */

@property (nonatomic, assign) AVPlayerState   playerState;    /** 播放状态 */
@property (nonatomic, assign) AVPlayerQuality playerQuality;  /** 播放画质 */
@property (nonatomic, assign) AVPlayerSpeed   playerSpeed;    /** 播放速率 */

@property (nonatomic, strong) id              timeObserverToken; /** 使用系统这个类似定时器，不用要释放 */

@end

@implementation QSPlayerManage

/** 初始化并设置视频 */
- (void)initVideoWithUrl:(NSString *)url superView:(UIView *)superView {
    
    NSString *urlStr;
    // 先url编码，因为汉字可能不识别
    if (url) {
        urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    else {
        urlStr = @"";
    }
    
    NSURL *playUrl = [NSURL URLWithString:urlStr];
    self.avPlayerItem = [[AVPlayerItem alloc] initWithURL:playUrl];
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:self.avPlayerItem];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    
    NSLog(@"屏幕大小 %f", superView.frame.size.width);
    self.playerView.frame = CGRectMake(0, 88, CGRectGetWidth(superView.frame), 233.0);
    [superView addSubview:self.playerView];
    
    self.avPlayerLayer.frame = self.playerView.bounds;
//    [self.playerView.layer insertSublayer:self.avPlayerLayer atIndex:0];
    [self.playerView.layer addSublayer:self.avPlayerLayer];
    [self.playerView setupView];
    
    [self initLogic];
    [self addObserve];
}

/** 初始化逻辑 */
- (void)initLogic {
    
    // 初始化参数以及UI
    self.playerState   = AVPlayerStatePlaying;
    self.playerQuality = AVPlayerQualitySmooth;
    self.playerSpeed   = AVPlayerSpeed1_0;
    
    [self playVideo];
    [self.playerView.middleView updatePlayUIState:self.playerState];
    
    // 播放与停止，UI状态更新
    QSWeakSelf
    [self.playerView.middleView setPlayBlock:^{
        QSStrongSelf
        if (strongSelf.playerState == AVPlayerStatePlaying) {
            strongSelf.playerState = AVPlayerStatePause;
            [strongSelf pauseVideo];
        }
        else {
            strongSelf.playerState = AVPlayerStatePlaying;
            [strongSelf playVideo];
        }
        [strongSelf.playerView.middleView updatePlayUIState:strongSelf.playerState];
    }];
    
    // 拖动进度条, 滑动位置的时间 = 滑块值(0.0 - 1.0) * 总时间
    self.playerView.footView.playSliderBlock = ^(float value) {
        if (weakSelf.avPlayer.status == AVPlayerStatusReadyToPlay) {
            
            NSTimeInterval seekDuration = value * CMTimeGetSeconds(weakSelf.avPlayer.currentItem.duration);
            CMTime seekTime = CMTimeMake(seekDuration, 1);
            [weakSelf.avPlayer seekToTime:seekTime completionHandler:^(BOOL finished) {
                if (finished) {
                    NSLog(@"拖动完成");
                }
            }];
        }
    };
}

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
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    // 状态
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"status -> 未知");
                break;
                
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"status -> 准备播放");
                break;
                
            case AVPlayerItemStatusFailed:
                NSLog(@"status -> 播放失败");
                break;
                
            default:
                break;
        }
    }
    // 缓冲区
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        CMTimeRange timeRange = [[((NSArray *)(change[NSKeyValueChangeNewKey])) firstObject] CMTimeRangeValue];
        NSTimeInterval startSec = CMTimeGetSeconds(timeRange.start);
        NSTimeInterval durationSec = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval buffSec = startSec + durationSec;
        NSTimeInterval totalSec = CMTimeGetSeconds(((AVPlayerItem *)object).duration);
        [self.playerView.footView updateBuffProgress:(float)(buffSec / totalSec)];
    }
}


/** 切换视频资源 */
- (void)updateVideoUrl:(NSString *)url {
    
}

#pragma mark - 控制方法

/** 开始播放 */
- (void)playVideo {
    if (self.avPlayer) {
        [self.avPlayer play];
    }
}

/** 暂停播放 */
- (void)pauseVideo {
    if (self.avPlayer) {
        [self.avPlayer pause];
    }
}

#pragma mark - 懒加载
- (QSPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[QSPlayerView alloc] init];
    }
    return _playerView;
}

@end
