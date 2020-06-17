//
//  QSPlayerManageBase.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/17.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSPlayerManageBase.h"
#import "QSItemTableView.h"
#import "QSRightPopView.h"
#import "QSLabelButtonView.h"

@interface QSPlayerManageBase()

@property (nonatomic, assign) BOOL            screenOrientationH;   /** 当前屏幕的方向 YES:横屏 NO:竖屏 */

@end

@implementation QSPlayerManageBase

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
//    self.avPlayerItem.preferredForwardBufferDuration = 10.0;  // 缓存到10s就触发
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
    self.playerState   = AVPlayerStateReadying;
    self.playerQuality = AVPlayerQualitySmooth;
    self.playerSpeed   = AVPlayerSpeed1_0;
    [self.playerView.middleView updatePlayUIState:self.playerState];
    
    /** 播放与停止，UI状态更新
     ** 状态1：更改播放停止、执行暂停、显示操作视图
     ** 状态2：隐藏右侧弹框、更新播放/暂停UI
     */
    QSWeakSelf
    self.playerView.playVideoBlock = ^{
        
        QSStrongSelf
        // 更改播放停止、执行暂停、显示操作视图
        if ( (strongSelf.playerState == AVPlayerStateReadying) ||
            (strongSelf.playerState == AVPlayerStatePlaying) ||
            (strongSelf.playerState == AVPlayerStateBuffing) ) {
            
            strongSelf.playerState = AVPlayerStatePause;
            [strongSelf pauseVideo];
            [strongSelf.playerView showOperationView];
        }
        else if (strongSelf.playerState == AVPlayerStatePause) {
            
            strongSelf.playerState = AVPlayerStatePlaying;
            [strongSelf playVideo];
            [strongSelf.playerView delayHiddenOperationView];
        }
        
        // 隐藏右侧弹框、更新播放/暂停UI
        [strongSelf.playerView.rightView dismissSubView];
        [strongSelf.playerView.middleView updatePlayUIState:strongSelf.playerState];
    };
    
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
    
    // 倍速选择事件 //NSArray *speedArray = @[@"0.5倍速", @"0.75倍速", @"1.0倍速", @"1.5倍速", @"2.0倍速"];
    self.playerView.speedView.clickItemBlock = ^(NSInteger item, NSString * _Nonnull itemTitle) {
        
        NSLog(@"%@", itemTitle);
        [weakSelf.playerView.rightView dismissSubView];
        
        NSArray *speedValueArray = @[@0.5, @0.75, @1.0, @1.5, @2.0];
        if (item < speedValueArray.count) {
            float rate = [speedValueArray[item] floatValue];
            weakSelf.avPlayer.rate = rate;
        }
    };
    
    // 画质选择事件 //NSArray *qualityArray = @[@"流畅 360P", @"标清 480P", @"高清 720P", @"高清 1080P"];
    self.playerView.qualityView.clickItemBlock = ^(NSInteger item, NSString * _Nonnull itemTitle) {
        
        NSLog(@"%@", itemTitle);
        [weakSelf.playerView.rightView dismissSubView];
        
        NSArray *qualityValueArray = @[@"360P", @"480P", @"720P", @"1080P"];
        if (item < qualityValueArray.count) {
            // 这个测试可以把两种url传进来，然后切换另一个链接播放，当然先得跳到指定位置上
            //NSString *qualityValue = qualityValueArray[item];
        }
    };
    
    // 各种异常播放提示后，点击事件 (重新播放，请重试)
    self.playerView.middleView.exceptionLabel.clickBlock = ^{
        if (weakSelf.playerState == AVPlayerStateEnd) {
            CMTime seekTime = CMTimeMake(0, 1);
            [weakSelf.avPlayer seekToTime:seekTime completionHandler:^(BOOL finished) {
                if (finished) {
                    NSLog(@"重新播放拖动完成");
                }
            }];
        }
        else if(weakSelf.playerState == AVPlayerStateFail) {
            
        }
    };
}

/** 切换视频资源 */
- (void)updateVideoUrl:(NSString *)url {
    
}

- (void)addObserve {
    // 由子类重写
}
- (void)removeObserve {
    // 由子类重写
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
