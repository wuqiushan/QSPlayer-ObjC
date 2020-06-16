//
//  QSPlayerMiddleView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPlayerParam.h"
NS_ASSUME_NONNULL_BEGIN

@interface QSPlayerMiddleView : UIView

- (instancetype)init;

/**
 更新播放UI状态(目前先做两种状态)

 @param state 有很多状态，不同状态显示不同UI
 */
- (void)updatePlayUIState:(AVPlayerState)state;


@end

NS_ASSUME_NONNULL_END
