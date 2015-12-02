//
//  ZBannerView.h
//  ZBannerViewDemo
//
//  Created by 张彦东 on 15/12/1.
//  Copyright © 2015年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBannerView;

@protocol ZBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(ZBannerView *)bannerView imageDidClickWithIndex:(NSInteger)imageIndex;

@end

@interface ZBannerView : UIView

@property (nonatomic, strong) NSArray * imageUrls;

@property (nonatomic, strong) NSArray * imageNames;

@property (nonatomic, assign) float imageScale;

@property (nonatomic, assign) float imageScrollTimeInterval;

@property (nonatomic, weak) id<ZBannerViewDelegate> delegate;

+ (instancetype)bannerView;

@end
