//
//  QSRightPopView.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/8.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//
/**
 本类为容器视图，主是搭载视图，以及实现了容器视图从右侧动画推出（视图的宽度占显示视频视图的 1/6）
 因为可以搭载不同的视图(一次搭载一个视图)
 操作1：无任何视图且未弹出时 -> 弹出视图
 操作2：已弹出并有视图时    -> 更新搭载视图(不同类型视图才换) //这个更新可能用不到，因为pop出后遮住按钮
 操作3：已弹出并有视图时    -> 消失视图
 */

#import "QSRightPopView.h"

@interface QSRightPopView() <CAAnimationDelegate>

@end

@implementation QSRightPopView

- (instancetype)initWithSuperViewFrame:(CGRect)rect
{
    self = [super init];
    if (self) {
        [self setupView:rect];
    }
    return self;
}

- (void)setupView:(CGRect)rect {
    
    // 计算出容器视图大小以及位置
    self.frame = CGRectMake(CGRectGetWidth(rect), 0, CGRectGetWidth(rect) / 5.0, CGRectGetHeight(rect));
    self.backgroundColor = [UIColor redColor];
}


/**
 动画弹出视图从右侧边(要实现操作1，和操作2，现顶部说明)
 
 @param subView 搭载的视图
 @param rect 父视图的frame
 */
- (void)popSubView:(UIView *)subView superView:(CGRect)rect {
    
    self.frame = CGRectMake(CGRectGetWidth(rect), 0, CGRectGetWidth(rect) / 6.0, CGRectGetHeight(rect));
    subView.center = self.center;
    
    if (self.subviews.count == 0) {
        [self addSubview:subView];
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        basicAnimation.fromValue = @(0);
        basicAnimation.toValue = @(0 - CGRectGetWidth(rect) / 6.0);
        basicAnimation.duration = 0.2;
        basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        basicAnimation.removedOnCompletion = false;
        basicAnimation.fillMode = kCAFillModeForwards;
        basicAnimation.delegate = self;
        [basicAnimation setValue:@"pop" forKey:@"animationKey"];
        [self.layer addAnimation:basicAnimation forKey:@"key"];
    }
    else {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self addSubview:subView];
    }
}


/**
 动画消失视图往右侧边
 这里要先动画，再移除
 */
- (void)dismissSubView {
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(CGRectGetWidth(self.frame));
    basicAnimation.duration = 0.2;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    basicAnimation.removedOnCompletion = false;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.delegate = self;
    [basicAnimation setValue:@"dismiss" forKey:@"animationKey"];
    [self.layer addAnimation:basicAnimation forKey:@"key"];
}

#pragma mark - 动画代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    // 动画完成后更新视图的frame
    [self.layer removeAllAnimations];
    if (flag) {
        NSString *animKey = [anim valueForKey:@"animationKey"];
        if ([animKey isEqualToString:@"pop"]) {
            CGFloat X =  CGRectGetWidth([self superview].frame) - CGRectGetWidth(self.frame);
            self.frame = CGRectMake(X, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
        else if ([animKey isEqualToString:@"dismiss"]) {
            if (self.subviews.count > 0) {
                [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                CGFloat X =  CGRectGetWidth([self superview].frame);
                self.frame = CGRectMake(X, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            }
        }
    }
}

@end
