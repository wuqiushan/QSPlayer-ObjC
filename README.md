[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![language](https://img.shields.io/badge/language-objective--c-green.svg)](1) 

### 概述
此框架采用AVPlayer开发的视频播放器，具有强大的功能，手势快进、亮度、声音等，
* [X] 完成缓冲条显示、进度条拖动功能
* [X] 增加耳机接入监听处理
* [X] 增声音被打断监听（如：来电）
* [X] 新增播放速率功能
* [ ] 支持多种画质播放
* [ ] 手势快进、亮度、声音
* [X] 支持iOS10.0(含)以上


### 使用方法
```Objective-C
NSString *url = @"http://yyd-resource.oss-cn-shenzhen.aliyuncs.com/voice/mp3/20190617/20e7986a5d184220b8a52a8ddedef732.mp4";
    self.playerManage = [[QSPlayerManage alloc] init];
    [self.playerManage initVideoWithUrl:url superView:self.view];
    
    __weak typeof(self) weakSelf = self;
    self.playerManage.backBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            NSLog(@"dismiss 完成");
        }];
    };
```
在视图控制类下增加这行，用于竖橫屏触发
```Objective-C
- (void)viewWillLayoutSubviews {
    [self.playerManage updateSuperView:self.view];
}
```
### 许可证
所有源代码均根据MIT许可证进行许可。


### 设计思路(有兴趣可以看)

#### 类说明
##### 主文件下类
* QSPlayerFootView：播放器底部视图，实现滑块、缓冲条、全屏切换等交互，这里要注意滑块(UISlider)在手动拖动时，不要同时去设置UISlider的值，这样会出现在拖动时，时不时会弹会的问题，解决方法：在滑动按下的事件里做个标志位
* QSPlayerHeadView：播放器顶部视图，返回分两种，全屏返回到小屏，小屏返回到上一级控制器，标题、分享等功能
* QSPlayerMiddleView：播放器中部视图，这里主要显示各种播放状态、锁屏、各种手势等，有快进手势、亮度手势、声音手势等
* QSPlayerView：播放器视图，
* QSPlayerManageBase：播放器管理类，播放器初始化(大小、速率)，各种逻辑(播放/停止，拖动进度，监听播放状态)
* QSPlayerManage：监听播放状态、缓存进度等
* QSPlayerParam：播放器的一些参数类型枚举
* QSSlider：重写track布局(解决滑动条不能完全挡住进度条)

##### QSOperationView 参数操作选项视图
* QSRightPopView：用于在横屏时右侧弹出容器视图
* QSItemTableView：用于操作选项显示的TableView视图，选项数量和title可以自定义化，目前把播放速率和画质视图搭载在上面

##### QSStatusView 播放状态视图
* QSLabelButtonView：播放状态视图的一种，用于显示左文右按钮的结构布局，比如：“播放失败，请重试”
* QSLabelAnimationView：播放状态视图的一种，用于显示左文右动画的结构而已，比如：“缓冲中...”

#### 状态视图场景
| 状态\事件 | 响应播放|响应暂停|自动隐藏状态|middleView响应事件|
|   ---   |   --- |   --- |  ---    |  ---  |
|准备中...  |  否   |  是   | 否      | 否    |
|播放      |  否   |  是   | 是      | 否    |
|暂停      |  是   |  否   | 否      | 否    |
|缓冲中...  |  否   |  是   | 否      | 否    |
|播放结束   |  否   |  否   | 否      | 是    |
|播放失败   |  否   |  否   | 否      | 是    |

#### 存在的Bug
* [ ] 点击速率时会状态视图状态不更新
* [ ] middleView响应事件这个还没做
* [ ] 右侧动画弹框，在竖屏初始化后，再横屏时显示的位置有问题

#### 思路
播放器UI设计分顶、中、底三部分视图
