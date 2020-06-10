//
//  QSPlayerView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QSPlayerHeadView, QSPlayerMiddleView, QSPlayerFootView, QSItemTableView;

NS_ASSUME_NONNULL_BEGIN

@interface QSPlayerView : UIView

// 上中下视图
@property (nonatomic, strong) QSPlayerHeadView   *headView;
@property (nonatomic, strong) QSPlayerMiddleView *middleView;
@property (nonatomic, strong) QSPlayerFootView   *footView;

// 右边弹出视图
@property (nonatomic, strong) QSItemTableView    *speedView;
@property (nonatomic, strong) QSItemTableView    *qualityView;

- (void)setupView;

@end

NS_ASSUME_NONNULL_END
