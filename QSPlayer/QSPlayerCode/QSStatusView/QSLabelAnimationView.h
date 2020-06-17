//
//  QSLabelAnimationView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/16.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSLabelAnimationView : UIView

- (instancetype)init;

// 更新显示内容
- (void)updateTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
