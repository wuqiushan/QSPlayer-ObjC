//
//  QSVideoViewController.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/27.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSVideoViewController.h"
#import "QSPlayerManage.h"

@interface QSVideoViewController ()
@property (nonatomic, strong) QSPlayerManage *playerManage;
@end

@implementation QSVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = @"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4";
    self.playerManage = [[QSPlayerManage alloc] init];
    [self.playerManage initVideoWithUrl:url superView:self.view];
}

@end
