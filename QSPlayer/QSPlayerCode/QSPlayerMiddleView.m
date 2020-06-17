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
@property (nonatomic, assign) AVPlayerState recordState; // 记录上一次的状态
@end

@implementation QSPlayerMiddleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
        self.recordState = AVPlayerStateEnd;
    }
    return self;
}

- (void)setupView {
    
    [self addSubview:self.iconImgView];
    [self addSubview:self.exceptionLabel];
    [self addSubview:self.buffAnimationLabel];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(40);
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
    
    self.iconImgView.hidden = YES;
    self.exceptionLabel.hidden = YES;
    self.buffAnimationLabel.hidden = YES;
}

#pragma mark - 开放方法
// 通过状态来展示UI状态，因为UI状态显示结构有多种，所以选择性的隐藏
- (void)updatePlayUIState:(AVPlayerState)state {
    
    if (state == self.recordState) {
        return ;
    }
    self.recordState = state;
    
    self.iconImgView.hidden = YES;
    self.exceptionLabel.hidden = YES;
    self.buffAnimationLabel.hidden = YES;
    
    if (state == AVPlayerStatePlaying) {
        [self.iconImgView setImage:[UIImage imageNamed:@"videoPlay"]];
        self.iconImgView.hidden = NO;
        
        // 在点了播放后，这个logo马上动画消失，然后0.3后复原
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.iconImgView.alpha = 0.0;
        [UIView commitAnimations];
        [self performSelector:@selector(delayShowIconImageView) withObject:self afterDelay:0.3];
    }
    else if (state == AVPlayerStatePause) {
        [self.iconImgView setImage:[UIImage imageNamed:@"videoStop"]];
        self.iconImgView.hidden = NO;
    }
    else if (state == AVPlayerStateReadying) {
        [self.buffAnimationLabel updateTitle:@"准备中..."];
        self.buffAnimationLabel.hidden = NO;
    }
    else if (state == AVPlayerStateBuffing) {
        [self.buffAnimationLabel updateTitle:@"缓冲中..."];
        self.buffAnimationLabel.hidden = NO;
    }
    else if (state == AVPlayerStateEnd) {
        [self.exceptionLabel updateTitle:@"播放结束，" buttonTitle:@"重新播放"];
        self.exceptionLabel.hidden = NO;
    }
    else {
        [self.exceptionLabel updateTitle:@"播放失败，" buttonTitle:@"请重试"];
        self.exceptionLabel.hidden = NO;
    }
}

// 复原iconImgView的显示，只是把它隐藏掉了
- (void)delayShowIconImageView {
    if (self.iconImgView) {
        self.iconImgView.hidden = YES;
        self.iconImgView.alpha = 1.0;
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
