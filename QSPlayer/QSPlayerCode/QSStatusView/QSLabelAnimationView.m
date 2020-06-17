//
//  QSLabelAnimationView.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/16.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//  左文右动画显示 用于比如：缓冲中...

#import "QSLabelAnimationView.h"
#import "Masonry.h"
#import "NSString+iOS.h"

@interface QSLabelAnimationView()
@property (nonatomic, strong) UILabel  *titleLabel;

@end

@implementation QSLabelAnimationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

// 更新显示内容
- (void)updateTitle:(NSString *)title {
    
    self.titleLabel.text = title;
//    CGFloat width = [title widthWithFont:[UIFont systemFontOfSize:12]] + 5;
//    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(width);
//    }];
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"缓冲中...";
    }
    return _titleLabel;
}


@end
