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

@interface QSPlayerView()
@property (nonatomic, strong) QSRightPopView *rightView;
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
    
    // 速度设置
    __weak typeof(self) weakSelf = self;
    self.footView.speedBlock = ^{
        UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 100)];
        testView.backgroundColor = [UIColor whiteColor];
        [weakSelf.rightView popSubView:testView superView:weakSelf.frame];
    };
    
    // 画质设置
    self.footView.qualityBlock = ^{
        
    };
    
    // 本视图单击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGesture];
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

@end
