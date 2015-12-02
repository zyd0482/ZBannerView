//
//  ViewController.m
//  ZBannerViewDemo
//
//  Created by 张彦东 on 15/12/1.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ViewController.h"
#import "ZBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray * images = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg"];
    
    ZBannerView * bannerView = [ZBannerView bannerView];
    [self.view addSubview:bannerView];
    bannerView.imageNames = images;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
