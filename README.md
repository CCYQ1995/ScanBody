# ScanBody
[TOC]
# 扫描身体动画
##前言
前些日子，收到了一个需求，要求做一个动画，效果是那种类似于身体检查，从头扫描到脚的。本着赶快交付不想麻烦的套路，我在网上找了一堆资源，发现没有比较符合的选择。没办法，只能自己稍微来实现一个了。
##前期准备
这个动画，需要用到的有：底图，扫描的视图，以及扫描到的部位需要展示的图片。还有就是思路。我们的思路是这样子的：扫描视图为底图的上层，然后做着重复上下移动的动作。之后我们将需要显示的图片添加到扫描的视图中，利用 OC 的视图裁剪等功能实现隐藏；并利用视图从上往下，显示视图从下往下做动画，造成的视觉差来实现我们需要的效果。先放张效果图给给为看官看一下。效果图如下：

![扫描动画效果图](https://raw.githubusercontent.com/CCYQ1995/ScanBody/master/ScanBodyGIF.gif)

##进入正题
首先我们需要新建一个 View ，取名为：'ScanBodyView'; 用来承载这个功能。其次将我们需要用到的一些控件一个个排布好，我这里采用了 Masonry 的布局。代码如下
```
// ScanBodyView.m 文件中
@interface ScanBodyView()

// 背景图 底图
@property (nonatomic, weak) UIImageView *bodyBgImageView;

// 被扫描到要显示的图片
@property (nonatomic, weak) UIImageView *bodyImageView;

// 扫描的图片
@property (nonatomic, weak) UIImageView *scanImageView;

// 底部承载的图片
@property (nonatomic, weak) UIImageView *bottomImageView;

// 扫描图层的背景
@property (nonatomic, weak) UIImageView *scanImageViewBg;

// 结束按钮
@property (nonatomic, weak) UIButton *endTestBtn;

@end
```
```
- (void)setupView {
    // 人体背景图
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.image = [UIImage imageNamed: @"scan_female_body"];
    [self addSubview:bodyBgImageView];
    self.bodyBgImageView = bodyBgImageView;
    
    // 扫描图层
    UIImageView *scanImageView = [[UIImageView alloc] init];
    scanImageView.clipsToBounds = YES;
    scanImageView.userInteractionEnabled = YES;
    //    scanImageView.backgroundColor = [UIColor redColor];
    [self addSubview:scanImageView];
    self.scanImageView = scanImageView;
    
    // 带颜色的人体图片
    UIImageView *bodyImageView = [[UIImageView alloc] init];
    bodyImageView.image = [UIImage imageNamed:@"scan_female_muscle"];
    [self.scanImageView addSubview:bodyImageView];
    self.bodyImageView = bodyImageView;
    
    // 扫描图片
    UIImageView *scanImageViewBg = [[UIImageView alloc] init];
    scanImageViewBg.image = [UIImage imageNamed:@"scan_dc_body_scanner"];
    [self.scanImageView addSubview:scanImageViewBg];
    self.scanImageViewBg = scanImageViewBg;
    
    UIImageView *bottomImageView = [[UIImageView alloc] init];
    bottomImageView.image = [UIImage imageNamed:@"scan_bottom_circles"];
    [self addSubview:bottomImageView];
    self.bottomImageView = bottomImageView;
    
    UIButton *endTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [endTestBtn setBackgroundImage:[UIImage imageNamed:@"scan_finish_checking_normal"] forState:0];
    [endTestBtn addTarget:self action:@selector(endTestBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:endTestBtn];
    self.endTestBtn = endTestBtn;
}

// 布局
- (void)setupViewLayout {
    [self.bodyBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(HEIGHT(24));
        make.left.equalTo(self.mas_left).offset(WIDTH(60));
        make.right.equalTo(self.mas_right).offset(-WIDTH(60));
        make.height.mas_equalTo(SCREEN_HEIGHT - NAVBAR_HEIGHT - HEIGHT(183));
    }];
    
    [self.scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT(40));
        make.top.equalTo(self.mas_top).offset(HEIGHT(24));
        make.left.equalTo(self.mas_left).offset(WIDTH(60));
        make.right.equalTo(self.mas_right).offset(-WIDTH(60));
    }];
    
    [self.bodyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.bodyBgImageView);
        make.left.top.equalTo(self.scanImageView);
    }];
    
    [self.scanImageViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scanImageView);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, HEIGHT(120)));
        make.top.equalTo(self.bodyBgImageView.mas_bottom).offset(-HEIGHT(40));
    }];
    
    [self.endTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WIDTH(180), HEIGHT(55)));
        make.bottom.equalTo(self.mas_bottom).offset(-HEIGHT(78));
        make.centerX.equalTo(self.mas_centerX);
    }];
}
```
基本上这样我们就可以搞定了。这个时候呢，我们需要加上点动画效果。代码如下：
```
- (void)startScan {
    
    [UIView animateWithDuration:5 delay:0.35 options: UIViewAnimationOptionRepeat animations:^{
        
        CGPoint scanCenter = self.scanImageView.center;
        scanCenter.y += (SCREEN_HEIGHT - NAVBAR_HEIGHT - HEIGHT(183));
        self.scanImageView.center = scanCenter;
        
        CGPoint bodyCenter = self.bodyImageView.center;
        bodyCenter.y -= (SCREEN_HEIGHT - NAVBAR_HEIGHT - HEIGHT(183));
        self.bodyImageView.center = bodyCenter;
    } completion:^(BOOL finished) {
    }];
}
```

到这里，基本上就实现了我们想要的动画效果了；不过呢，在使用的过程中，我还是发现了一些小问题，如果有其他人想要用的话，记得好好优化一下哦。代码我已经传到GitHub上了，[点击这里可以直达](https://github.com/CCYQ1995/ScanBody)


