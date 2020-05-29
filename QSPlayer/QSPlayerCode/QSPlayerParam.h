//
//  QSPlayerParam.h
//  QSPlayer
//
//  Created by wuqiushan on 2020/5/28.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#ifndef QSPlayerParam_h
#define QSPlayerParam_h

#define QSWeakSelf __weak __typeof(self) weakSelf = self;
#define QSStrongSelf __strong __typeof(weakSelf) strongSelf = weakSelf;

typedef NS_ENUM(NSInteger, AVPlayerState) {
    AVPlayerStateReadying,     /** 准备中 */
    AVPlayerStatePlaying,      /** 播放中 */
    AVPlayerStatePause,        /** 暂停 */
    AVPlayerStateBuffing,      /** 缓冲中 */
    AVPlayerStateEnd,          /** 播放结束 */
    AVPlayerStateFail          /** 播放失败 */
};

typedef NS_ENUM(NSInteger, AVPlayerQuality) {
    AVPlayerQualitySmooth,     /** 流畅 */
    AVPlayerQualitySD,         /** 标清 */
    AVPlayerQualityHD,         /** 高清 */
    AVPlayerQuality1080P       /** 1080P */
};

typedef NS_ENUM(NSInteger, AVPlayerSpeed) {
    AVPlayerSpeed0_5,         /** 0.5倍速度 */
    AVPlayerSpeed1_0,         /** 1.0倍速度 */
    AVPlayerSpeed1_5,         /** 1.5倍速度 */
    AVPlayerSpeed2_0          /** 2.0倍速度 */
};

#endif /* QSPlayerParam_h */
