//
//  ZDemo2Controller.m
//  ZBannerViewDemo
//
//  Created by 张彦东 on 16/2/22.
//  Copyright © 2016年 yd. All rights reserved.
//

#import "ZDemo2Controller.h"
#import "ZBannerView.h"

@interface ZDemo2Controller () <ZBannerViewDelegate>

@property (weak, nonatomic) IBOutlet ZBannerView *bannerView;

@end

@implementation ZDemo2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  如果显示有问题，比如拖动时候图片会向下偏移，请在控制器中加入下面这句代码。
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 数据源 (百度了几张网络图片)
    NSArray * datas = @[@"http://e.hiphotos.baidu.com/zhidao/pic/item/0bd162d9f2d3572cf556972e8f13632763d0c388.jpg",
                        @"http://www.bz55.com/uploads/allimg/130803/1-130P3112Q0.jpg",
                        @"http://b.hiphotos.baidu.com/zhidao/pic/item/d833c895d143ad4b18e853b981025aafa50f0680.jpg",
                        @"http://www.bz55.com/uploads/allimg/120627/1-12062G00Q9.jpg",
                        @"http://f.hiphotos.baidu.com/zhidao/pic/item/b7003af33a87e950f015531914385343fbf2b441.jpg"];
    
    
    self.bannerView.imageUrls = datas;
    self.bannerView.delegate = self;
}

@end


@implementation ZDemo2Controller (ZBannerView)

- (void)bannerView:(ZBannerView *)bannerView imageDidClickWithIndex:(NSInteger)imageIndex {
    NSLog(@"第%ld张图片被选中了!", imageIndex);
}

@end