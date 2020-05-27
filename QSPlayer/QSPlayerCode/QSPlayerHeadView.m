//
//  QSPlayerHeadView.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSPlayerHeadView.h"
#import "Masonry.h"

@interface QSPlayerHeadView()

/** 返回箭头图标 */
@property (nonatomic, strong) UIImageView *backImageView;
/** 标题 */
@property (nonatomic, strong) UILabel     *titleLabel;
/** 分享按钮 */
@property (nonatomic, strong) UIButton    *shareButton;

@end

@implementation QSPlayerHeadView


- (void)backAction {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)shareAction {
    if (self.shareBlock) {
        self.shareBlock();
    }
}

#pragma mark - 懒加载
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"videoLeftBack"];
        _backImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backBlock)];
        [_backImageView addGestureRecognizer:tap];
    }
    return _backImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"未知";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRed:0x26/255.0 green:0x12/255.0 blue:0x0B/255.0 alpha:1.0];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backBlock)];
        [_titleLabel addGestureRecognizer:tap];
    }
    return _titleLabel;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"videoShare"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

@end
