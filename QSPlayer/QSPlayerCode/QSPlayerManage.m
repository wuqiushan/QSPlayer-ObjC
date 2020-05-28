//
//  QSPlayerManage.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/26.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSPlayerManage.h"
#import <AVFoundation/AVFoundation.h>

@interface QSPlayerManage()

@property (nonatomic, strong) AVPlayer      *avPlayer;
@property (nonatomic, strong) AVPlayerItem  *avPlayerItem;
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;
//@property (nonatomic, strong)

@end

@implementation QSPlayerManage

/** 初始化并设置视频 */
- (void)initVideoWithUrl:(NSString *)url superView:(UIView *)superView {
    
    NSString *urlStr;
    // 先url编码，因为汉字可能不识别
    if (url) {
        urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    else {
        urlStr = @"";
    }
    
    NSURL *playUrl = [NSURL URLWithString:urlStr];
    self.avPlayerItem = [[AVPlayerItem alloc] initWithURL:playUrl];
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:self.avPlayerItem];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.avPlayerLayer.frame = superView.bounds;
    [superView.layer addSublayer:self.avPlayerLayer];
    [self.avPlayer play];
}

/** 切换视频 */
- (void)updateVideoUrl:(NSString *)url {
    
}



@end
