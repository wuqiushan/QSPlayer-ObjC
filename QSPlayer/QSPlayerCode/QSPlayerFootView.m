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
#import "QSSlider.h"

@interface QSPlayerFootView()

@property (nonatomic, readwrite, strong) UILabel        *timeLabel;          /** 播放时间 当前时长/总时长 （都有）*/
@property (nonatomic, readwrite, strong) UIProgressView *buffProgressView;   /** 缓冲进度 （都有） */
@property (nonatomic, readwrite, strong) QSSlider       *playProgressSlider; /** 快进滑动 （都有） */
@property (nonatomic, readwrite, strong) UIButton       *fullScreenButton;   /** 全屏 半屏时才有 */
@property (nonatomic, readwrite, strong) UIButton       *speedButton;        /** 速率 横屏时才有 */
@property (nonatomic, readwrite, strong) UIButton       *qualityButton;      /** 清晰度 横屏时才有 */

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
    
    [self addSubview: self.timeLabel];
    [self addSubview: self.buffProgressView];
    [self addSubview: self.playProgressSlider];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.height.equalTo(@(40));
        make.width.equalTo(@(80));
    }];
    
    [self.playProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.buffProgressView);
    }];
    
    [self setScreenH: NO];
}

- (void)setScreenH:(BOOL)screenH {
    
    if (screenH) {
        [self addSubview: self.speedButton];
        [self addSubview: self.qualityButton];
        [self.fullScreenButton removeFromSuperview];
        
        [self.qualityButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-5);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(45);
        }];
        
        [self.speedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.qualityButton.mas_left).offset(-2);
            make.height.width.mas_equalTo(38);
        }];
        
        [self.buffProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.timeLabel.mas_right).offset(2);
            make.right.equalTo(self.speedButton.mas_left).offset(-5);
            make.height.equalTo(@(3));
        }];
    }
    else {
        [self.speedButton removeFromSuperview];
        [self.qualityButton removeFromSuperview];
        [self addSubview: self.fullScreenButton];
        
        [self.fullScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-5);
            make.height.width.equalTo(@(32));
        }];
        
        [self.buffProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.timeLabel.mas_right).offset(2);
            make.right.equalTo(self.fullScreenButton.mas_left).offset(-5);
            make.height.equalTo(@(3));
        }];
    }
}

#pragma mark - 事件处理

- (void)qualityAction {
    if (self.qualityBlock) {
        self.qualityBlock();
    }
}

- (void)speedAction {
    if (self.speedBlock) {
        self.speedBlock();
    }
}

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
    
    if (totalSec < currentSec) {
        self.timeLabel.text = @"0:00 / 0:00";
    }
    else {
        NSString *currentSecStr = [self formatPlayTime:currentSec];
        NSString *totalSecStr = [self formatPlayTime:totalSec];
        self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@", currentSecStr, totalSecStr];
    }
    
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
    [self setScreenH:full];
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

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"0:00 / 0:00";
    }
    return _timeLabel;
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
        _playProgressSlider = [[QSSlider alloc] init];
        _playProgressSlider.continuous = false;
        _playProgressSlider.minimumValue = 0.0;
        _playProgressSlider.maximumValue = 1.0;
        UIColor *minTrackColor = [UIColor colorWithRed:33.0/255.0 green:151.0/255.0 blue:216.0/255.0 alpha:1.0];
        _playProgressSlider.minimumTrackTintColor = minTrackColor;
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

- (UIButton *)speedButton {
    if (!_speedButton) {
        _speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _speedButton.contentMode = UIViewContentModeCenter;
        [_speedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_speedButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_speedButton setTitle:@"倍速" forState:UIControlStateNormal];
        _speedButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_speedButton addTarget:self action:@selector(speedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedButton;
}

- (UIButton *)qualityButton {
    if (!_qualityButton) {
        _qualityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _qualityButton.contentMode = UIViewContentModeCenter;
        [_qualityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_qualityButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_qualityButton setTitle:@"1080P" forState:UIControlStateNormal];
        _qualityButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_qualityButton addTarget:self action:@selector(qualityAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qualityButton;
}

@end
