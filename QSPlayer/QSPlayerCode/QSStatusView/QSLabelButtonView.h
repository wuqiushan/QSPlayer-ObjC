//
//  QSLabelButtonView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/16.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSLabelButtonView : UIView

/** 请重试事件 */
@property (nonatomic, copy) void(^clickBlock)(void);

/** 初始化 */
- (instancetype)init;

/** 更新title：需要显示的内容 */
- (void)updateTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle;

@end

NS_ASSUME_NONNULL_END
