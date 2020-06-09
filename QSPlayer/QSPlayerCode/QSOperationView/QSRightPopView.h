//
//  QSRightPopView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/8.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSRightPopView : UIView

- (instancetype)initWithSuperViewFrame:(CGRect)rect;

/**
 动画弹出视图从右侧边
 
 @param subView 搭载的视图
 @param rect 父视图的frame
 */
- (void)popSubView:(UIView *)subView superView:(CGRect)rect;

/**
 动画消失视图往右侧边
 */
- (void)dismissSubView;

@end

NS_ASSUME_NONNULL_END
