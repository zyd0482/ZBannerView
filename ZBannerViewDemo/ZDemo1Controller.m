//
//  ZDemo1Controller.m
//  ZBannerViewDemo
//
//  Created by 张彦东 on 16/2/22.
//  Copyright © 2016年 yd. All rights reserved.
//

#import "ZDemo1Controller.h"
#import "ZBannerView.h"

@interface ZDemo1Controller () <ZBannerViewDelegate>

@property (nonatomic, weak) ZBannerView * bannerView;

@end

@implementation ZDemo1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
     *  如果显示有问题，比如拖动时候图片会向下偏移，请在控制器中加入下面这句代码。
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 本地数据源
     NSArray * images = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg"];
    
    ZBannerView * bannerView = [ZBannerView bannerView];
    [self.view addSubview:bannerView];
    bannerView.imageNames = images;
    bannerView.delegate = self;
    self.bannerView = bannerView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.bannerView.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
}

@end

@implementation ZDemo1Controller (ZBannerView)

- (void)bannerView:(ZBannerView *)bannerView imageDidClickWithIndex:(NSInteger)imageIndex {
    NSLog(@"第%ld张图片被选中了!", imageIndex);
}

@end