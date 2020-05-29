//
//  QSPlayerFootView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSPlayerFootView : UIView

/** 点击全屏按钮回调 */
@property (nonatomic, copy) void(^fullScreenBlock)(void);

/** 点击快进滑块回调 */
@property (nonatomic, copy) void(^playSliderBlock)(float value);

- (instancetype)init;

/** update缓冲条 */
- (void)updateBuffProgress:(float)progress;

/** update播放进度条、当前时间、总时间 */
- (void)updateCurrentSec:(NSTimeInterval)currentSec totalSec:(NSTimeInterval)totalSec;

/** update全屏与半屏切换的UI */
- (void)updateFullSceen:(BOOL)full;

@end

NS_ASSUME_NONNULL_END
