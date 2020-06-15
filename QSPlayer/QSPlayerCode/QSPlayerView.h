//
//  QSPlayerView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QSPlayerHeadView, QSPlayerMiddleView, QSPlayerFootView, QSItemTableView, QSRightPopView;

NS_ASSUME_NONNULL_BEGIN

@interface QSPlayerView : UIView

// 上中下视图（头、中、尾视图）
@property (nonatomic, strong) QSPlayerHeadView   *headView;
@property (nonatomic, strong) QSPlayerMiddleView *middleView;
@property (nonatomic, strong) QSPlayerFootView   *footView;

// 右边弹出视图(容器视图、倍速、画质)
@property (nonatomic, strong) QSRightPopView     *rightView;
@property (nonatomic, strong) QSItemTableView    *speedView;
@property (nonatomic, strong) QSItemTableView    *qualityView;

- (void)setupView;

/** 单击事件(播放/暂停) */
@property (nonatomic, copy) void(^playVideoBlock)(void);

/** 双击事件(全屏/半屏切换) */
@property (nonatomic, copy) void(^screenSwitchBlock)(void);

/** 快进/后退事件 */
@property (nonatomic, copy) void(^fastForwardBlock)(void);

@end

NS_ASSUME_NONNULL_END
