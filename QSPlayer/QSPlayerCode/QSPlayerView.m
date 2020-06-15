//
//  QSPlayerView.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSPlayerView.h"
#import "Masonry.h"

#import "QSPlayerHeadView.h"
#import "QSPlayerMiddleView.h"
#import "QSPlayerFootView.h"
#import "QSRightPopView.h"
#import "QSItemTableView.h"

@interface QSPlayerView()<UIGestureRecognizerDelegate>

/** 定时器用于点击播放时自动隐藏操作视图(上中下视图) */
@property (nonatomic, strong) NSTimer *timer;
/** 是否显示操作视图的标志位 */
@property (nonatomic, assign) BOOL     isShowOPView;

@end

@implementation QSPlayerView

- (void)setupView {
    self.backgroundColor = [UIColor lightGrayColor];
    self.clipsToBounds = YES;
    [self addSubview:self.headView];
    [self addSubview:self.middleView];
    [self addSubview:self.footView];
    [self addSubview:self.rightView];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(44));
    }];
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@(44));
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.bottom.equalTo(self.footView.mas_top);
        make.left.right.equalTo(self);
    }];
    
    [self initActionHandle];
}

- (void)initActionHandle {
    
    // 显示5s后 -> 不显示
    self.isShowOPView = YES;
    [self openTimer];
    
    // 速度视图弹出
    __weak typeof(self) weakSelf = self;
    self.footView.speedBlock = ^{
        [weakSelf.rightView popSubView:weakSelf.speedView superView:weakSelf.frame];
    };
    
    // 画质视图弹出
    self.footView.qualityBlock = ^{
        [weakSelf.rightView popSubView:weakSelf.qualityView superView:weakSelf.frame];
    };
    
    // 中视图单击、双击、事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tapGesture.delegate = self;
    [self.middleView addGestureRecognizer:tapGesture];
    UITapGestureRecognizer *twoTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTapAction)];
    twoTapGesture.numberOfTapsRequired = 2;
    [self.middleView addGestureRecognizer:twoTapGesture];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction)];
    [self.middleView addGestureRecognizer:panGesture];
}

#pragma 触摸事件的代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 当是rightView区域，把点击事件不处理，让他自己处理
    if ([touch.view isDescendantOfView:self.rightView]) {
        return NO;
    }
    return YES;
}

#pragma mark - 事件处理
- (void)tapAction {
    
    if (self.playVideoBlock) {
        self.playVideoBlock();
    }
    
//    [self.rightView dismissSubView];
}

- (void)twoTapAction {
    
    if (self.screenSwitchBlock) {
        self.screenSwitchBlock();
    }
}

- (void)panAction {
    
    if (self.fastForwardBlock) {
        self.fastForwardBlock();
    }
}

#pragma mark - 动画显示/隐藏操作(即：上下视图) 透明度减小(即：中视图)
- (void)showOperationView {
    
    CABasicAnimation *showHeadAnimation = [self getAnimationWithKeyPath:@"transform.translation.y" duration:0.2 fromValue:@(0 - CGRectGetWidth(self.headView.frame)) toValue: @(0)];
    [self.headView.layer addAnimation:showHeadAnimation forKey:@"showHeadAnimation"];
    
    CABasicAnimation *showFootAnimation = [self getAnimationWithKeyPath:@"transform.translation.y" duration:0.2 fromValue:@(CGRectGetWidth(self.footView.frame)) toValue: @(0)];
    [self.footView.layer addAnimation:showFootAnimation forKey:@"showFootAnimation"];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.middleView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)hiddenOperationView {
    
    CABasicAnimation *showHeadAnimation = [self getAnimationWithKeyPath:@"transform.translation.y" duration:0.2 fromValue:@(0) toValue: @(0 - CGRectGetWidth(self.headView.frame))];
    [self.headView.layer addAnimation:showHeadAnimation forKey:@"showHeadAnimation"];
    
    CABasicAnimation *showFootAnimation = [self getAnimationWithKeyPath:@"transform.translation.y" duration:0.2 fromValue:@(0) toValue:@(CGRectGetWidth(self.footView.frame))];
    [self.footView.layer addAnimation:showFootAnimation forKey:@"showFootAnimation"];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.middleView.alpha = 1.0;
    [UIView commitAnimations];
}

- (CABasicAnimation *)getAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration
                                    fromValue:(id)fromValue toValue:(id)toValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = duration;
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.repeatCount = 1;
    animation.repeatCount = 0.2;
    [animation setRemovedOnCompletion:false];
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

#pragma mark - 定时器处理 *** 这里要处理循环引用的问题
- (void)openTimer {
    if ((_timer == nil) || (!_timer.isValid)) {
        // 这里为了安全加了判断(本框架本来就只支持iOS10.0及以上)
        if (@available(iOS 10.0, *)) {
            __weak typeof(self) weakSelf = self;
            _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:false block:^(NSTimer * _Nonnull timer) {
                if (weakSelf.isShowOPView == YES) {
                    weakSelf.isShowOPView = NO;
                    [weakSelf hiddenOperationView];
                }
            }];
        }
    }
}

- (void)closeTimer {
    if ((_timer != nil) && (_timer.isValid)) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 懒加载
- (QSPlayerHeadView *)headView {
    if (!_headView) {
        _headView = [[QSPlayerHeadView alloc] init];
    }
    return _headView;
}

- (QSPlayerMiddleView *)middleView {
    if (!_middleView) {
        _middleView = [[QSPlayerMiddleView alloc] init];
    }
    return _middleView;
}

- (QSPlayerFootView *)footView {
    if (!_footView) {
        _footView = [[QSPlayerFootView alloc] init];
    }
    return _footView;
}

- (QSRightPopView *)rightView {
    if (!_rightView) {
        _rightView = [[QSRightPopView alloc] initWithSuperViewFrame:self.frame];
    }
    return _rightView;
}

- (QSItemTableView *)speedView {
    if (!_speedView) {
        NSArray *speedArray = @[@"0.5倍速", @"0.75倍速", @"1.0倍速", @"1.5倍速", @"2.0倍速"];
        //NSArray *speedValueArray = @[@0.5, @0.75, @1.0, @1.5, @2.0];
        _speedView = [[QSItemTableView alloc] initTableViewWithArray:speedArray];
        _speedView.frame = CGRectMake(0, 0, 120, 250); // 高度 = 5项 * 50
    }
    return _speedView;
}

- (QSItemTableView *)qualityView {
    if (!_qualityView) {
        NSArray *qualityArray = @[@"流畅 360P", @"标清 480P", @"高清 720P", @"高清 1080P"];
        //NSArray *qualityValueArray = @[@"360P", @"480P", @"720P", @"1080P"];
        _qualityView = [[QSItemTableView alloc] initTableViewWithArray:qualityArray];
        _qualityView.frame = CGRectMake(0, 0, 120, 200); // 高度 = 4项 * 50
    }
    return _qualityView;
}

@end
