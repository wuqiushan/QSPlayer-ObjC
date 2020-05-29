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
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSString *url = @"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4";
    NSString *url = @"http://yyd-resource.oss-cn-shenzhen.aliyuncs.com/voice/mp3/20190617/20e7986a5d184220b8a52a8ddedef732.mp4";
    self.playerManage = [[QSPlayerManage alloc] init];
    [self.playerManage initVideoWithUrl:url superView:self.view];
}

@end
