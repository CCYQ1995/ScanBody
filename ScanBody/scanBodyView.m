//
//  scanBodyView.m
//  ScanBody
//
//  Created by jkm on 2018/8/16.
//  Copyright © 2018年 jkm. All rights reserved.
//

#import "ScanBodyView.h"
#import <Masonry/Masonry.h>

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

@interface ScanBodyView()

@property (nonatomic, weak) UIImageView *bodyBgImageView;

@property (nonatomic, weak) UIImageView *bodyImageView;

@property (nonatomic, weak) UIImageView *scanImageView;

@property (nonatomic, weak) UIImageView *bottomImageView;

@property (nonatomic, weak) UIImageView *scanImageViewBg;

@property (nonatomic, weak) UIButton *endTestBtn;

@end

@implementation ScanBodyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
        [self setupViewLayout];
        [self startScan];
    }
    return self;
}

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

#pragma mark - animate
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


#pragma mark - Button Action
- (void)endTestBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEndTestBtn)]) {
        [self.delegate clickEndTestBtn];
    }
}

#pragma mark - getter & setter
- (void)setIsMan:(BOOL)isMan {
    _isMan = isMan;
    if (isMan) {
        self.bodyBgImageView.image = [UIImage imageNamed: @"scan_male_body"];
        self.bodyImageView.image = [UIImage imageNamed:@"scan_male_muscle"];
    } else {
        self.bodyBgImageView.image = [UIImage imageNamed: @"scan_female_body"];
        self.bodyImageView.image = [UIImage imageNamed:@"scan_female_muscle"];
    }
}

- (void)setHiddenEndBtn:(BOOL)hiddenEndBtn {
    _hiddenEndBtn = hiddenEndBtn;
    self.endTestBtn.hidden = _hiddenEndBtn;
}

@end
