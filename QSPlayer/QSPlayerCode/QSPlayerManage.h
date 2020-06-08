//
//  QSPlayerManage.h
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

NS_ASSUME_NONNULL_BEGIN

@interface QSPlayerManage : NSObject

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

@end

NS_ASSUME_NONNULL_END




