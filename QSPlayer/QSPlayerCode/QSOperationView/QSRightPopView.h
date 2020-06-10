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
 动画弹出视图从右侧边(要实现操作1，和操作2，现顶部说明)
 自身容器高度占满，宽度占 1/6
 搭载的视图，居中显示
 
 @param subView 容器视图需要搭载的子视图
 @param rect 容器视图的父视图frame
 */
- (void)popSubView:(UIView *)subView superView:(CGRect)rect;

/**
 动画消失视图往右侧边
 这里要先动画，再移除
 */
- (void)dismissSubView;

@end

NS_ASSUME_NONNULL_END
