//
//  QSPlayerFootView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSPlayerFootView : UIView

@property (nonatomic, copy) void(^fullScreenBlock)(void);
@property (nonatomic, copy) void(^playSliderBlock)(CGFloat value);

@end

NS_ASSUME_NONNULL_END
