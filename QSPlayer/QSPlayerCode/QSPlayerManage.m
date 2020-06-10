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
#import "QSItemTableView.h"

#define IOSScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define IOSScreenHeight         ([UIScreen mainScreen].bounds.size.height)
#define IOSScreenRatioW         IOSScreenWidth / 375.0f

#define isIphone5               (IOSScreenWidth == 320.f && IOSScreenHeight == 568.f ? YES : NO)
#define isIphoneX_XS            (IOSScreenWidth == 375.f && IOSScreenHeight == 812.f ? YES : NO)
#define isIphoneXR_XSMax        (IOSScreenWidth == 414.f && IOSScreenHeight == 896.f ? YES : NO)
#define isIphoneXLater          (isIphoneX_XS || isIphoneXR_XSMax)
#define isHorizontal            (IOSScreenWidth > IOSScreenHeight ? YES : NO)

#define IOSStatusBarHeight      (isIphoneXLater ? 44.f : 20.f)
#define IOSNavgationBarHeight   44.0f
#define IOSNavgationTotalHeight (IOSStatusBarHeight + IOSNavgationBarHeight)

#define IOSBottomSafeHeight     (isIphoneXLater ? 34.0f : 0.0f)
#define IOSTabBarHeight         49.0f
#define IOSTabBarTotalHeight    (IOSBottomSafeHeight + IOSTabBarHeight)

//#define IOSTopSafeHeight        (isIphoneXLater ? 44.f : 0.0f)
//#define IOSBottomSafeHeight     (isIphoneXLater ? 34.0f : 0.0f)

@interface QSPlayerManage()

@property (nonatomic, strong) AVPlayer      *avPlayer;       /** 播放器 */
@property (nonatomic, strong) AVPlayerItem  *avPlayerItem;   /** 播放器项，可以有多个 */
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;  /** 播放器显示层 */
@property (nonatomic, strong) QSPlayerView  *playerView;     /** 播放控制视图 */

@property (nonatomic, assign) AVPlayerState   playerState;    /** 播放状态 */
@property (nonatomic, assign) AVPlayerQuality playerQuality;  /** 播放画质 */
@property (nonatomic, assign) AVPlayerSpeed   playerSpeed;    /** 播放速率 */

@property (nonatomic, strong) id              timeObserverToken;    /** 使用系统这个类似定时器，不用要释放 */
@property (nonatomic, assign) BOOL            screenOrientationH;   /** 当前屏幕的方向 YES:横屏 NO:竖屏 */

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
    self.playerView.frame = CGRectMake(0, IOSStatusBarHeight, CGRectGetWidth(superView.frame), CGRectGetWidth(superView.frame) * 9.0 / 16.0);
    self.screenOrientationH = NO;
    [superView addSubview:self.playerView];
    
    self.avPlayerLayer.frame = self.playerView.bounds;
//    [self.playerView.layer insertSublayer:self.avPlayerLayer atIndex:0];
    [self.playerView.layer addSublayer:self.avPlayerLayer];
    [self.playerView setupView];
    
    // 这里获取mp4文件大小偏小，原因待查
//    NSArray *array = [self.avPlayerItem.asset tracksWithMediaType:AVMediaTypeVideo];
//    for (AVAssetTrack *track in array) {
//        NSLog(@"trackID: %d, size: %lld", track.trackID, track.totalSampleDataLength / 1024 /1024);
//    }
    
    [self initLogic];
    [self addObserve];
}

/**
 当屏幕方向与上次屏幕方向一样的时，没必要变，因为影响性能

 @param superView 父视图，这里一般是控制器的view
 */
- (void)updateSuperView:(UIView *)superView {
    
    if (self.screenOrientationH == isHorizontal) {
        return ;
    }
    
    if (isHorizontal == YES) {
        
        CGFloat topSafeHeight = 0;
        CGFloat bottomSafeHeight = 0;
        if ([self isPhoneX]) {
            // home键在右测
            if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
                topSafeHeight = 44.0f - 10.0f;
                bottomSafeHeight = 34.0f;
            }
            else {
                topSafeHeight = 34.0f;
                bottomSafeHeight = 44.0f - 10.0f;
            }
        }
        self.playerView.frame = CGRectMake(topSafeHeight, 0, CGRectGetWidth(superView.frame) - topSafeHeight - bottomSafeHeight, CGRectGetHeight(superView.frame));
        self.screenOrientationH = YES;
    }
    else {
        self.playerView.frame = CGRectMake(0, IOSStatusBarHeight, CGRectGetWidth(superView.frame),CGRectGetWidth(superView.frame) * 9.0 / 16.0);
        self.screenOrientationH = NO;
    }
    self.avPlayerLayer.frame = self.playerView.bounds;
    [self.playerView.footView updateFullSceen:self.screenOrientationH];
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
    
    // 手动全/半屏切换
    self.playerView.footView.fullScreenBlock = ^{
        
        if (weakSelf.screenOrientationH) {
            NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        }
        else {
            NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
            [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        }
        //[weakSelf.playerView.footView updateFullSceen:weakSelf.screenOrientationH];
    };
    
    // 返回按钮 全屏返回成半屏，半屏返回到上一视图控制器
    self.playerView.headView.backBlock = ^{
        
        if (weakSelf.screenOrientationH) {
            // 切成半屏
            NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
            //[weakSelf.playerView.footView updateFullSceen:weakSelf.screenOrientationH];
        }
        else {
            [weakSelf removeObserve];
            if (weakSelf.backBlock) {
                weakSelf.backBlock();
            }
        }
    };
    
    // 倍速选择事件
    self.playerView.speedView.clickItemBlock = ^(NSInteger item, NSString * _Nonnull itemTitle) {
        NSLog(@"%@", itemTitle);
    };
    
    // 画质选择事件
    self.playerView.qualityView.clickItemBlock = ^(NSInteger item, NSString * _Nonnull itemTitle) {
        NSLog(@"%@", itemTitle);
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
    
    // 移除耳机接入监听 指定观察[AVAudioSession sharedInstance]
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionRouteChangeNotification
                                                  object:[AVAudioSession sharedInstance]];
    
    // 移除来电被打断监听
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionInterruptionNotification
                                                  object:[AVAudioSession sharedInstance]];
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

#pragma mark 播放状态/缓存条
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


//可以使用一下语句判断是否是刘海手机：
- (BOOL)isPhoneX {
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}
@end
