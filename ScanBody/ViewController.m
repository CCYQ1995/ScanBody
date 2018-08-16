//
//  ViewController.m
//  ScanBody
//
//  Created by jkm on 2018/8/16.
//  Copyright © 2018年 jkm. All rights reserved.
//

#import "ViewController.h"
#import "ScanBodyView.h"
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define NAVBAR_HEIGHT ((IS_IPHONE_X?44.0:20.0)+44.0)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
/// 这针对iPhone6为标准适配宽度
#define WIDTH(R) ((R)*(SCREEN_WIDTH/375.0))
/// 这针对iPhone6为标准适配高度
#define HEIGHT(R) (IS_IPHONE_X?R:((R)*(SCREEN_HEIGHT/667.0)))


@interface ViewController ()<ScanBodyViewDelegate>

@property (nonatomic, strong) ScanBodyView *scanBodyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.scanBodyView = [[ScanBodyView alloc] init];
    self.scanBodyView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, IS_IPHONE_X ? SCREEN_HEIGHT - NAVBAR_HEIGHT : SCREEN_HEIGHT);
    self.scanBodyView.delegate = self;
    // 是否需要隐藏 结束按钮
    self.scanBodyView.hiddenEndBtn = NO;
    // 是否为男性身体
    self.scanBodyView.isMan = YES;
    
    [self.view addSubview:self.scanBodyView];
}

- (void)viewDidAppear:(BOOL)animated {
    /*
     在这里调用是因为 ScanBodyView 里的控件
     采用的 Masonry 布局
     */
    [self.scanBodyView startScan];
}

- (void)clickEndTestBtn {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
