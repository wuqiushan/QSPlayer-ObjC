//
//  QSSlider.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/8.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSSlider.h"

@implementation QSSlider

// 重写这个为了解决minTrack遮挡不住progressView
- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0.0, 0.0, self.bounds.size.width, 3.0);
}

@end
