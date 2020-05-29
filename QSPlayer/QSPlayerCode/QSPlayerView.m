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

@interface QSPlayerView()

@end

@implementation QSPlayerView


//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self setupView];
//    }
//    return self;
//}

- (void)setupView {
    
    [self addSubview:self.headView];
    [self addSubview:self.middleView];
    [self addSubview:self.footView];
    
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

@end
