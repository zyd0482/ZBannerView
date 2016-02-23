//
//  ViewController.m
//  ZBannerViewDemo
//
//  Created by 张彦东 on 15/12/1.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ViewController.h"
#import "ZBannerView.h"
#import "ZDemo1Controller.h"
#import "ZDemo2Controller.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)demo1:(id)sender {
    
    ZDemo1Controller * demo1 = [[ZDemo1Controller alloc] init];
    [self.navigationController pushViewController:demo1 animated:YES];
}


- (IBAction)demo2:(id)sender {
    
    ZDemo2Controller * demo2 = [[ZDemo2Controller alloc] init];
    [self.navigationController pushViewController:demo2 animated:YES];
}

@end
