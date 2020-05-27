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

@property (nonatomic, copy) void(^backBlock)(void);
@property (nonatomic, copy) void(^shareBlock)(void);

@end

NS_ASSUME_NONNULL_END
