//
//  QSItemTableView.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/10.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSItemTableView : UIView


/**
 tableView点击回调，item：数组第几个被点击；itemTitle：被点击的内容
 */
@property (nonatomic, copy) void(^clickItemBlock)(NSInteger item, NSString *itemTitle);

/**
 初始化tableView，通过设置其显示title数组

 @param titleArray 要显示的title数组(元素类型只接收NSString)
 */
- (instancetype)initTableViewWithArray:(NSArray <NSString *> *)titleArray;

@end

NS_ASSUME_NONNULL_END
