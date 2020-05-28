//
//  QSPlayerManage.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSPlayerManage : NSObject


/**
 初始化播放器

 @param url 默认播放的资源文件
 @param superView 把视频视图加载到该视图上
 */
- (void)initVideoWithUrl:(NSString *)url superView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
