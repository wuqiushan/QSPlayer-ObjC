[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![language](https://img.shields.io/badge/language-objective--c-green.svg)](1) 

### 概述
此框架采用AVPlayer开发的视频播放器，具有强大的功能，手势快进、亮度、声音等，
* [X] 完成进度条拖动功能
* [ ] 手势快进、亮度、声音
* [ ] 


### 使用方法
```Objective-C

```

### 许可证
所有源代码均根据MIT许可证进行许可。


### 设计思路(有兴趣可以看)

#### 类说明
* QSPlayerFootView：播放器底部视图，实现滑块、缓冲条、全屏切换等交互，这里要注意滑块(UISlider)在手动拖动时，不要同时去设置UISlider的值，这样会出现在拖动时，时不时会弹会的问题，解决方法：在滑动按下的事件里做个标志位
* QSPlayerHeadView：播放器顶部视图，返回分两种，全屏返回到小屏，小屏返回到上一级控制器，标题、分享等功能
* QSPlayerMiddleView：播放器中部视图，这里主要显示各种播放状态、锁屏、各种手势等，有快进手势、亮度手势、声音手势等
* QSPlayerView：播放器视图，
* QSPlayerManage：播放器管理类，播放器初始化(大小、速率)，各种逻辑(播放/停止，拖动进度，监听播放状态、缓存进度等)

#### 思路
播放器UI设计分顶、中、底三部分视图
