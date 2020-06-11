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
    
    // 速度视图弹出
    __weak typeof(self) weakSelf = self;
    self.footView.speedBlock = ^{
        [weakSelf.rightView popSubView:weakSelf.speedView superView:weakSelf.frame];
    };
    
    // 画质视图弹出
    self.footView.qualityBlock = ^{
        [weakSelf.rightView popSubView:weakSelf.qualityView superView:weakSelf.frame];
    };
    
    // 本视图单击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
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
    [self.rightView dismissSubView];
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
