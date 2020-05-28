//
//  ViewController.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "ViewController.h"
#import "QSVideoViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *pushButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.pushButton.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:self.pushButton];
}

- (void)pushAction {
    
    QSVideoViewController *qsVideoVC = [[QSVideoViewController alloc] init];
    [self presentViewController:qsVideoVC animated:YES completion:^{
        NSLog(@"模态视图完成");
    }];
}

- (UIButton *)pushButton {
    if (!_pushButton) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushButton.contentMode = UIViewContentModeCenter;
        [_pushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pushButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_pushButton setTitle:@"视频播放器" forState:UIControlStateNormal];
        _pushButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _pushButton.layer.masksToBounds = YES;
        _pushButton.layer.cornerRadius = 3.0f;
        _pushButton.backgroundColor = [UIColor blackColor];
        [_pushButton addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushButton;
}



@end
