//
//  QSPlayerManageBase.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//
/**
 说明：单击屏幕：暂停/播放
 双击屏幕：全屏/半屏
 有各种异常提示功能
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "QSPlayerParam.h"
#import "QSPlayerView.h"

#import "QSPlayerHeadView.h"
#import "QSPlayerMiddleView.h"
#import "QSPlayerFootView.h"

#define IOSScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define IOSScreenHeight         ([UIScreen mainScreen].bounds.size.height)
#define IOSScreenRatioW         IOSScreenWidth / 375.0f

#define isIphone5               (IOSScreenWidth == 320.f && IOSScreenHeight == 568.f ? YES : NO)
#define isIphoneX_XS            (IOSScreenWidth == 375.f && IOSScreenHeight == 812.f ? YES : NO)
#define isIphoneXR_XSMax        (IOSScreenWidth == 414.f && IOSScreenHeight == 896.f ? YES : NO)
#define isIphoneXLater          (isIphoneX_XS || isIphoneXR_XSMax)
#define isHorizontal            (IOSScreenWidth > IOSScreenHeight ? YES : NO)

#define IOSStatusBarHeight      (isIphoneXLater ? 44.f : 20.f)
#define IOSNavgationBarHeight   44.0f
#define IOSNavgationTotalHeight (IOSStatusBarHeight + IOSNavgationBarHeight)

#define IOSBottomSafeHeight     (isIphoneXLater ? 34.0f : 0.0f)
#define IOSTabBarHeight         49.0f
#define IOSTabBarTotalHeight    (IOSBottomSafeHeight + IOSTabBarHeight)

NS_ASSUME_NONNULL_BEGIN

@interface QSPlayerManageBase : NSObject

@property (nonatomic, strong) AVPlayer       *avPlayer;       /** 播放器 */
@property (nonatomic, strong) AVPlayerItem   *avPlayerItem;   /** 播放器项，可以有多个 */
@property (nonatomic, strong) AVPlayerLayer  *avPlayerLayer;  /** 播放器显示层 */
@property (nonatomic, strong) QSPlayerView   *playerView;     /** 播放控制视图 */

@property (nonatomic, assign) AVPlayerState   playerState;    /** 播放状态 */
@property (nonatomic, assign) AVPlayerQuality playerQuality;  /** 播放画质 */
@property (nonatomic, assign) AVPlayerSpeed   playerSpeed;    /** 播放速率 */

/** 点击返回按钮回调 */
@property (nonatomic, copy) void(^backBlock)(void);

/**
 初始化播放器
 
 @param url 默认播放的资源文件
 @param superView 把视频视图加载到该视图上
 */
- (void)initVideoWithUrl:(NSString *)url superView:(UIView *)superView;

/** 更新布局 */
- (void)updateSuperView:(UIView *)superView;

#pragma mark - 控制方法

/** 开始播放 */
- (void)playVideo;

/** 暂停播放 */
- (void)pauseVideo;

// 这两方法由子类重写
- (void)addObserve;
- (void)removeObserve;

@end

NS_ASSUME_NONNULL_END




