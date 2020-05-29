//
//  QSPlayerHeadView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSPlayerHeadView : UIView

/** 点击返回按钮回调 */
@property (nonatomic, copy) void(^backBlock)(void);

/** 点击分享按钮回调 */
@property (nonatomic, copy) void(^shareBlock)(void);

- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
