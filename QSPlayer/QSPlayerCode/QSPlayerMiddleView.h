//
//  QSPlayerMiddleView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AVPlayerState) {
    AVPlayerStateReadying,     /** 准备中 */
    AVPlayerStatePlaying,      /** 播放中 */
    AVPlayerStatePause,        /** 暂停 */
    AVPlayerStateBuffing,      /** 缓冲中 */
    AVPlayerStateEnd,          /** 播放结束 */
    AVPlayerStateFail          /** 播放失败 */
};

typedef NS_ENUM(NSInteger, AVPlayerQuality) {
    AVPlayerQualitySmooth,     /** 流畅 */
    AVPlayerQualitySD,         /** 标清 */
    AVPlayerQualityHD,         /** 高清 */
    AVPlayerQuality1080P       /** 1080P */
};

typedef NS_ENUM(NSInteger, AVPlayerSpeed) {
    AVPlayerSpeed0_5,         /** 0.5倍速度 */
    AVPlayerSpeed1_0,         /** 1.0倍速度 */
    AVPlayerSpeed1_5,         /** 1.5倍速度 */
    AVPlayerSpeed2_0          /** 2.0倍速度 */
};

@interface QSPlayerMiddleView : UIView

@property (nonatomic, copy) void(^playBlock)(void);
@property (nonatomic, copy) void(^lockScreenBlock)(void);

/**
 更新播放UI状态(目前先做两种状态)

 @param state 有很多状态，不同状态显示不同UI
 */
- (void)updatePlayUIState:(AVPlayerState)state;

/**
 更新锁屏UI状态

 @param state YES：锁屏状态(即锁定屏幕各种按钮) NO：不锁屏
 */
- (void)updateLockUIState:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
