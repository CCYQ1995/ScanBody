//
//  ScanBodyView.h
//  ScanBody
//
//  Created by jkm on 2018/8/16.
//  Copyright © 2018年 jkm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanBodyViewDelegate<NSObject>;

- (void)clickEndTestBtn;

@end

@interface ScanBodyView : UIView

@property (nonatomic, assign) BOOL isMan;

@property (nonatomic, assign) BOOL hiddenEndBtn;

@property (nonatomic,weak) id<ScanBodyViewDelegate> delegate;

- (void)startScan;

@end
