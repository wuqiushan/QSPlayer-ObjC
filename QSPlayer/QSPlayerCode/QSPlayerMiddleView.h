//
//  QSPlayerMiddleView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPlayerParam.h"
NS_ASSUME_NONNULL_BEGIN

@interface QSPlayerMiddleView : UIView

/** 点击播放/暂停按钮回调 */
@property (nonatomic, copy) void(^playBlock)(void);

/** 点击锁屏/解锁按钮回调 */
@property (nonatomic, copy) void(^lockScreenBlock)(void);


- (instancetype)init;

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
