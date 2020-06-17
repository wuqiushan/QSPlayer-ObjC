//
//  QSPlayerMiddleView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPlayerParam.h"
@class QSLabelButtonView, QSLabelAnimationView;

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSInteger, OnlyShowViewType) {
//    OnlyShowViewTypeNull,          /** 都不显示 */
//    OnlyShowViewTypeIcon,          /** 只显示icon */
//    OnlyShowViewTypeLabelButton,   /** 只显示左文右按键 */
//    OnlyShowViewTypeLabelAnimation /** 只显示左文右动画 */
//};


@interface QSPlayerMiddleView : UIView

@property (nonatomic, strong) UIImageView          *iconImgView;        // 显示播放/暂停的图片
@property (nonatomic, strong) QSLabelButtonView    *exceptionLabel;     // "播放失败，请重试" "播放超时，请重试"
@property (nonatomic, strong) QSLabelAnimationView *buffAnimationLabel; // "缓冲中..." 动画

- (instancetype)init;

/**
 更新播放UI状态(目前先做两种状态)

 @param state 有很多状态，不同状态显示不同UI
 */
- (void)updatePlayUIState:(AVPlayerState)state;


@end

NS_ASSUME_NONNULL_END
