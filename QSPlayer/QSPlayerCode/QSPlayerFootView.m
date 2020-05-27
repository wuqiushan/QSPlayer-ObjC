//
//  QSPlayerFootView.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSPlayerFootView.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>

@interface QSPlayerFootView()

@property (nonatomic, strong) UILabel        *currentTimeLabel;
@property (nonatomic, strong) UILabel        *totalTimeLabel;
@property (nonatomic, strong) UIProgressView *buffProgressView;
@property (nonatomic, strong) UISlider       *playProgressSlider;
@property (nonatomic, strong) UIButton       *fullScreenButton;

@end

@implementation QSPlayerFootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    [self addSubview: self.currentTimeLabel];
    [self addSubview: self.totalTimeLabel];
    [self addSubview: self.buffProgressView];
    [self addSubview: self.playProgressSlider];
    [self addSubview: self.fullScreenButton];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.height.equalTo(@(40));
        make.width.equalTo(@(50));
    }];
    
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5);
        make.height.width.equalTo(@(32));
    }];
}

#pragma mark - 事件处理
- (void)fullScreenAction {
    if (self.fullScreenBlock) {
        self.fullScreenBlock();
    }
}

- (void)playSliderAction:(CGFloat) value {
    if (self.playProgressSlider) {
        self.playSliderBlock(value);
    }
}

#pragma mark - 懒加载
- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.backgroundColor = [UIColor clearColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:12];
        _currentTimeLabel.textColor = [UIColor blackColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.backgroundColor = [UIColor clearColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12];
        _totalTimeLabel.textColor = [UIColor blackColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (UIProgressView *)buffProgressView {
    if (!_buffProgressView) {
        _buffProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _buffProgressView.progress = 0.0;
        _buffProgressView.progressTintColor = [UIColor whiteColor];
        _buffProgressView.trackTintColor = [UIColor grayColor];
    }
    return _buffProgressView;
}

- (UISlider *)playProgressSlider {
    if (!_playProgressSlider) {
        _playProgressSlider = [[UISlider alloc] init];
        _playProgressSlider.continuous = false;
        _playProgressSlider.minimumValue = 0;
        _playProgressSlider.maximumValue = 1;
        _playProgressSlider.minimumTrackTintColor = [UIColor greenColor];
        _playProgressSlider.maximumTrackTintColor = [UIColor clearColor];
        
        UIImage *thumbImage = [UIImage imageNamed:@"videoPoint"];
        [_playProgressSlider setThumbImage:thumbImage forState:UIControlStateNormal];
        [_playProgressSlider addTarget:self action:@selector(playSliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _playProgressSlider;
}

- (UIButton *)fullScreenButton {
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenButton.backgroundColor = [UIColor clearColor];
        [_fullScreenButton setImage:[UIImage imageNamed:@"fullScreen"] forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(fullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

@end
