//
//  QSPlayerMiddleView.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSPlayerMiddleView.h"
#import "Masonry.h"

@interface QSPlayerMiddleView()

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *lockScreenButton;

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
    
    [self addSubview:self.playButton];
    [self addSubview:self.lockScreenButton];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@(40));
    }];
    
    [self.lockScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.width.height.equalTo(@(32));
    }];
}

#pragma mark - 开放方法

//设置播放状态(目前先做两种状态)
- (void)updatePlayUIState:(AVPlayerState)state {
    
    if (state == AVPlayerStatePlaying) {
        [self.playButton setImage:[UIImage imageNamed:@"videoPlay"] forState:UIControlStateNormal];
    }
    else {
        [self.playButton setImage:[UIImage imageNamed:@"videoStop"] forState:UIControlStateNormal];
    }
    /*
    switch (state) {
        case AVPlayerStateReadying:
            // 这里可以显示重新播放
            break;
            
        case AVPlayerStatePlaying:
            // 隐藏该视图
            break;
            
        case AVPlayerStatePause:
            // 显示播放按钮
            break;
            
        case AVPlayerStateBuffing:
            // 缓冲动画
            break;
            
        case AVPlayerStateEnd:
            // 重播放
            break;
            
        case AVPlayerStateFail:
            // 隐藏该视图
            break;
            
        default:
            break;
    } */
}

//设置锁屏状态
- (void)updateLockUIState:(BOOL)state {
    NSString *lockImagePic = @"videoUnLock";
    if (state == true) {
        lockImagePic = @"videoLock";
    }
    [self.lockScreenButton setImage:[UIImage imageNamed:lockImagePic]
                           forState:UIControlStateNormal];
}

#pragma mark - 事件处理
- (void)playAction {
    if (self.playBlock) {
        self.playBlock();
    }
}

- (void)lockScreenAction {
    if (self.lockScreenBlock) {
        self.lockScreenBlock();
    }
}

#pragma mark - 懒加载

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"videoPlay"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)lockScreenButton {
    if (!_lockScreenButton) {
        _lockScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockScreenButton setImage:[UIImage imageNamed:@"videoUnLock"] forState:UIControlStateNormal];
        [_lockScreenButton addTarget:self action:@selector(lockScreenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockScreenButton;
}

@end
