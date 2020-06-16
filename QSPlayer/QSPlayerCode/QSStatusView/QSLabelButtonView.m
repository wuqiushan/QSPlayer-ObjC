//
//  QSLabelButtonView.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/16.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//  左文右按钮的显示 用于比如：加载异常，请重试

#import "QSLabelButtonView.h"
#import "Masonry.h"
#import "NSString+iOS.h"

@interface QSLabelButtonView()

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton *textButton;

@end

@implementation QSLabelButtonView

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
    [self addSubview:self.textButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.right.equalTo(self.textButton.mas_left);
    }];
    
    [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(52);
    }];
}

// 这里要更新布局的
- (void)updateTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle {
    
    self.titleLabel.text = title;
    [self.textButton setTitle:buttonTitle forState:UIControlStateNormal];
    CGFloat width = [title widthWithFont:[UIFont systemFontOfSize:12]] + 5;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

#pragma mark 事件处理
- (void)clickAction {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.text = @"无法播放，";
    }
    return _titleLabel;
}

- (UIButton *)textButton {
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton.contentMode = UIViewContentModeCenter;
        [_textButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_textButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_textButton setTitle:@"请重试" forState:UIControlStateNormal];
        _textButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_textButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textButton;
}

@end
