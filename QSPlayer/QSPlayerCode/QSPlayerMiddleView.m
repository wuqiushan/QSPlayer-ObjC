//
//  QSPlayerMiddleView.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//  这里全部是中部视图的状态显示，有下面三种视图的展示，通过隐藏来使用，三个是互斥事件

#import "QSPlayerMiddleView.h"
#import "Masonry.h"
#import "QSLabelButtonView.h"
#import "QSLabelAnimationView.h"

@interface QSPlayerMiddleView()

//@property (nonatomic, strong) UIButton *playButton;
//@property (nonatomic, strong) UIButton *lockScreenButton; // 这种锁不要了，只要暂停就锁住屏幕
@property (nonatomic, strong) UIImageView          *iconImgView;        // 显示播放/暂停的图片
@property (nonatomic, strong) QSLabelButtonView    *exceptionLabel;     // "播放失败，请重试" "播放超时，请重试"
@property (nonatomic, strong) QSLabelAnimationView *buffAnimationLabel; // "缓冲中..." 动画


@end

@implementation QSPlayerMiddleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    [self addSubview:self.iconImgView];
    [self addSubview:self.exceptionLabel];
    [self addSubview:self.buffAnimationLabel];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(60);
        make.height.mas_equalTo(40);
    }];
    
    [self.exceptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(60);
        make.height.mas_equalTo(40);
    }];
    
    [self.buffAnimationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(60);
        make.height.mas_equalTo(40);
    }];
    
    // 播放提示点击后事件
    self.exceptionLabel.clickBlock = ^{
//        if (state == AVPlayerStateEnd) {
//
//        }
//        else if (<#expression#>) {
//
//        }
    };
}

#pragma mark - 开放方法

//设置播放状态(目前先做两种状态)
- (void)updatePlayUIState:(AVPlayerState)state {
    
    if (state == AVPlayerStatePlaying) {
        [self.iconImgView setImage:[UIImage imageNamed:@"videoPlay"]];
    }
    else if (state == AVPlayerStatePause) {
        [self.iconImgView setImage:[UIImage imageNamed:@"videoStop"]];
    }
    else if ((state == AVPlayerStateReadying) || (state == AVPlayerStateBuffing)) {
        NSLog(@"显示缓冲中");
    }
    else if (state == AVPlayerStateEnd) {
        [self.exceptionLabel updateTitle:@"播放结束，" buttonTitle:@"重新播放"];
    }
    else {
        [self.exceptionLabel updateTitle:@"播放失败，" buttonTitle:@"请重试"];
    }
}


#pragma mark - 事件处理


#pragma mark - 懒加载
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"videoPlay"];
    }
    return _iconImgView;
}

- (QSLabelButtonView *)exceptionLabel {
    if (!_exceptionLabel) {
        _exceptionLabel = [[QSLabelButtonView alloc] init];
    }
    return _exceptionLabel;
}

- (QSLabelAnimationView *)buffAnimationLabel {
    if (!_buffAnimationLabel) {
        _buffAnimationLabel = [[QSLabelAnimationView alloc] init];
    }
    return _buffAnimationLabel;
}

@end
