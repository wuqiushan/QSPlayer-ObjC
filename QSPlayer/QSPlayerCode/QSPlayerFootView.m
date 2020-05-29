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

@property (nonatomic, readwrite, strong) UILabel        *currentTimeLabel;
@property (nonatomic, readwrite, strong) UILabel        *totalTimeLabel;
@property (nonatomic, readwrite, strong) UIProgressView *buffProgressView;
@property (nonatomic, readwrite, strong) UISlider       *playProgressSlider;
@property (nonatomic, readwrite, strong) UIButton       *fullScreenButton;

/** 滑块状态 YES:手动滑动中 NO:松开滑动或未滑动 */
@property (nonatomic, readwrite, assign) BOOL isSliding;

@end

@implementation QSPlayerFootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
        self.isSliding = NO;
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
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.fullScreenButton.mas_left).offset(-5);
        make.height.equalTo(@(40));
        make.width.equalTo(@(50));
    }];
    
    [self.buffProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(5);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-5);
        make.height.equalTo(@(3));
    }];
    
    [self.playProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(5);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-5);
        make.height.equalTo(@(3));
    }];
}

#pragma mark - 事件处理

- (void)fullScreenAction {
    if (self.fullScreenBlock) {
        self.fullScreenBlock();
    }
}

// 这里有两个功能，第一个是值拖动值出去，
// 第二个就是监听是否在拖动，在拖动时，就不再自动设置Slider的值了，因为会有手动和自动两种在操作滑块
- (void)playSliderAction:(UISlider *)slider {
    
    self.isSliding = NO; // 如果有事件产生说明已经松手了
    
    if (self.playSliderBlock) {
        self.playSliderBlock(slider.value);
    }
}

- (void)playSlidrTouchDown {
    self.isSliding = YES; // 当滑块有按下时，就标志位，直到松开手
}

#pragma mark - 开放方法
/** update缓冲条 */
- (void)updateBuffProgress:(float)progress {
    [self.buffProgressView setProgress:progress animated:YES];
}

/** update播放进度条、当前时间、总时间 */
- (void)updateCurrentSec:(NSTimeInterval)currentSec totalSec:(NSTimeInterval)totalSec {
    self.currentTimeLabel.text = [self formatPlayTime:currentSec];
    self.totalTimeLabel.text   = [self formatPlayTime:totalSec];
    
    // 不在拖动滑块时才设置滑块值
    if (self.isSliding == NO) {
        [self.playProgressSlider setValue:(float)(currentSec/totalSec) animated:YES];
    }
}

/** update全屏与半屏切换的UI */
- (void)updateFullSceen:(BOOL)full {
    NSString *imagStr = @"fullScreen";
    if (full) {
        imagStr = @"halfScreen";
    }
    [self.fullScreenButton setImage:[UIImage imageNamed:imagStr] forState:UIControlStateNormal];
}

#pragma mark - 时间格式化
- (NSString *)formatPlayTime:(NSTimeInterval)duration {
    NSInteger totalSecend = round(duration);
    NSInteger hour = totalSecend / 3600;
    NSInteger minute = (totalSecend % 3600) / 60;
    NSInteger secend = totalSecend % 60;
    if (hour < 1) {
        return [NSString stringWithFormat:@"%ld:%02ld", (long)minute, (long)secend];
    }
    return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)hour, (long)minute, (long)secend];
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
        _playProgressSlider.minimumValue = 0.0;
        _playProgressSlider.maximumValue = 1.0;
        _playProgressSlider.minimumTrackTintColor = [UIColor greenColor];
        _playProgressSlider.maximumTrackTintColor = [UIColor clearColor];
        
        UIImage *thumbImage = [UIImage imageNamed:@"videoPoint"];
        [_playProgressSlider setThumbImage:thumbImage forState:UIControlStateNormal];
        [_playProgressSlider addTarget:self action:@selector(playSliderAction:) forControlEvents:UIControlEventValueChanged];
        [_playProgressSlider addTarget:self action:@selector(playSlidrTouchDown) forControlEvents:UIControlEventTouchDown];
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
