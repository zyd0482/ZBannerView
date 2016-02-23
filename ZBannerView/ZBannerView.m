//
//  ZBannerView.m
//  ZBannerViewDemo
//
//  Created by 张彦东 on 15/12/1.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ZBannerView.h"
#import "UIImageView+WebCache.h"

// 图片滚动时间间隔
#define kImageScrollTimeInterval 2.0


typedef NS_ENUM(NSUInteger, ZBannerScrollType) {
    ZBannerScrollTypeStatic, // 非滑动状态
    ZBannerScrollTypeLeft,
    ZBannerScrollTypeRight
};

@interface ZBannerView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl * pageControl;

@property (nonatomic, weak) UIScrollView * scrollView;

// 当前显示图片的Index
@property (nonatomic, assign) NSInteger currentImageIndex;

// 数据处理用Array
@property (nonatomic, strong) NSArray * imageArray;

// 滚动时显示的Image
@property (nonatomic, weak) UIImageView * reuseImageView;
// 静止时候显示的Image
@property (nonatomic, weak) UIImageView * displayImageView;
// 滚动状态
@property (nonatomic, assign) ZBannerScrollType scrollType;

@end

@implementation ZBannerView
{
    NSTimer * _timer;
}

#pragma mark - 生命周期函数
- (void)dealloc {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

+ (instancetype)bannerView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.pageControl.center = CGPointMake(self.center.x, CGRectGetMaxY(self.scrollView.frame) - 20);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    CGFloat vWidth = self.scrollView.frame.size.width;
    CGFloat vHeight = self.scrollView.frame.size.height;
    self.displayImageView.frame = CGRectMake(vWidth, 0, vWidth, vHeight);
    self.reuseImageView.frame = CGRectMake(0, 0, vWidth, vHeight);
    [self loadDisplayImage];
}

// 一些View的初始化设置
- (void)setupViews {
    
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    UIImageView * displayImageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:displayImageView];
    self.displayImageView = displayImageView;
    displayImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
    [displayImageView addGestureRecognizer:tgr];
    
    UIImageView * reuseImageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:reuseImageView];
    self.reuseImageView = reuseImageView;
}

// 判断View是否在屏幕中
- (BOOL)isInScreen:(CGRect)frame {
    return (CGRectGetMaxX(frame) > self.scrollView.contentOffset.x) &&
    (CGRectGetMinX(frame) < self.scrollView.contentOffset.x + self.scrollView.bounds.size.width);
}


#pragma mark - Setter 设置数据源
- (void)setImageUrls:(NSArray *)imageUrls {
    
    _imageUrls = imageUrls;
    
    self.imageArray = imageUrls;
    
    self.pageControl.numberOfPages = imageUrls.count;
    
    [self loadDisplayImage];
    [self startTimer];
}

- (void)setImageNames:(NSArray *)imageNames {
    
    _imageNames = imageNames;
    
    self.imageArray = imageNames;
    
    self.pageControl.numberOfPages = imageNames.count;
    
    [self loadDisplayImage];
    [self startTimer];
}

#pragma mark - 加载图片
- (void)loadDisplayImage {
    if (self.imageNames) {
        self.displayImageView.image = [UIImage imageNamed:self.imageArray[self.currentImageIndex]];
    } else {
        UIImage * placeholderImage = self.placeholderImageName ? [UIImage imageNamed:self.placeholderImageName] : nil;
       [self.displayImageView sd_setImageWithURL:self.imageArray[self.currentImageIndex] placeholderImage:placeholderImage];
    }
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    
    self.pageControl.currentPage = self.currentImageIndex;
}

- (void)loadReuseImage {
    CGRect frame = self.reuseImageView.frame;
    NSInteger reuseIndex = self.currentImageIndex;
    if (self.scrollType == ZBannerScrollTypeLeft) {
        frame.origin.x = 0;
        reuseIndex = [self formatIndexWithIndex:reuseIndex - 1];
    } else {
        frame.origin.x = self.scrollView.frame.size.width * 2;
        reuseIndex = [self formatIndexWithIndex:reuseIndex + 1];
    }
    
    if (self.imageNames) {
        self.reuseImageView.image = [UIImage imageNamed:self.imageArray[reuseIndex]];
    } else {
        UIImage * placeholderImage = self.placeholderImageName ? [UIImage imageNamed:self.placeholderImageName] : nil;
        [self.reuseImageView sd_setImageWithURL:self.imageUrls[reuseIndex] placeholderImage:placeholderImage];
    }
    
    self.reuseImageView.frame = frame;
}

- (NSInteger)formatIndexWithIndex:(NSInteger)idx {
    NSInteger resultIdx = idx;
    if (resultIdx < 0) {
        resultIdx = self.imageArray.count - 1;
    } else if (resultIdx == self.imageArray.count) {
        resultIdx = 0;
    }
    return resultIdx;
}

// 更新当前image的index
- (void)updateCurrentIndex {
    if (self.scrollType == ZBannerScrollTypeLeft) {
        self.currentImageIndex = [self formatIndexWithIndex:self.currentImageIndex - 1];
    } else {
        self.currentImageIndex = [self formatIndexWithIndex:self.currentImageIndex + 1];
    }
}

#pragma mark - 自动滚动计时器
- (void)startTimer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:kImageScrollTimeInterval target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollImage {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat cosX = scrollView.contentOffset.x;
    // 当显示页面消失在屏幕时立刻更新Display Image
    if (![self isInScreen:self.displayImageView.frame]) {
        // 更新Current Index
        [self updateCurrentIndex];
        // 还原滚动方向
        self.scrollType = ZBannerScrollTypeStatic;
        // 更新Display Image
        [self loadDisplayImage];
        
        // 判断滚动方向
    } else if (cosX > self.frame.size.width) {
        // 右
        if (self.scrollType != ZBannerScrollTypeRight) {
            self.scrollType = ZBannerScrollTypeRight;
            [self loadReuseImage];
        }
    } else {
        // 左
        if (self.scrollType != ZBannerScrollTypeLeft) {
            self.scrollType = ZBannerScrollTypeLeft;
            [self loadReuseImage];
        }
    }
}

#pragma mark - 点击图片回调代理
- (void)imageClick {
    if ([self.delegate respondsToSelector:@selector(bannerView:imageDidClickWithIndex:)]) {
        [self.delegate bannerView:self imageDidClickWithIndex:self.currentImageIndex];
    }
}

@end
