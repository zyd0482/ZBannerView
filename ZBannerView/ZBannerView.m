//
//  ZBannerView.m
//  ZBannerViewDemo
//
//  Created by 张彦东 on 15/12/1.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ZBannerView.h"

@interface ZBannerView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl * pageControl;

@property (nonatomic, weak) UIScrollView * scrollView;

@property (nonatomic, weak) UIButton * preImageButton;
@property (nonatomic, weak) UIButton * currentImageButton;
@property (nonatomic, weak) UIButton * nextImageButton;

@property (nonatomic, assign) NSInteger currentImageIndex;

@property (nonatomic, strong) NSArray * imageArray;

@end

@implementation ZBannerView

{
    NSTimer * _timer;
}

#pragma mark - Constructor
+ (instancetype)bannerView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.imageScale = 0.55;
        self.imageScrollTimeInterval = 2;
    }
    return self;
}

#pragma mark - 加载函数
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    
    self.frame = CGRectMake(0, 0, newSuperview.bounds.size.width, newSuperview.bounds.size.width * self.imageScale);
    self.scrollView.frame = self.bounds;
    self.pageControl.center = CGPointMake(self.center.x, CGRectGetMaxY(self.scrollView.frame) - 20);
}

- (void)layoutSubviews {
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    CGFloat vWidth = self.scrollView.frame.size.width;
    CGFloat vHeight = self.scrollView.frame.size.height;
    self.preImageButton.frame = CGRectMake(0, 0, vWidth, vHeight);
    self.currentImageButton.frame = CGRectMake(vWidth, 0, vWidth, vHeight);
    self.nextImageButton.frame = CGRectMake(vWidth * 2, 0, vWidth, vHeight);
}

#pragma mark - setter
- (void)setImageUrls:(NSArray *)imageUrls {
    
    _imageUrls = imageUrls;
    
    self.imageArray = imageUrls;
    
    self.pageControl.numberOfPages = imageUrls.count;
    
    [self loadImageButtons];
    [self startTimer];
}

- (void)setImageNames:(NSArray *)imageNames {
    
    _imageNames = imageNames;
    
    self.imageArray = imageNames;
    
    self.pageControl.numberOfPages = imageNames.count;
    
    [self loadImageButtons];
    [self startTimer];
}


- (void)setImageScrollTimeInterval:(float)imageScrollTimeInterval {
    
    [self stopTimer];
    
    _imageScrollTimeInterval = imageScrollTimeInterval;
    [self startTimer];
    
}

#pragma mark - NSTimer
- (void)startTimer {
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.imageScrollTimeInterval target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
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
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
}

- (void)loadImageButtons {
    
    NSInteger preIndex = self.currentImageIndex == 0 ? self.imageArray.count - 1 : self.currentImageIndex - 1;
    NSInteger nextIndex = self.currentImageIndex == self.imageArray.count - 1 ? 0 : self.currentImageIndex + 1;
    
    if (self.imageNames) {
        
        [self.preImageButton setBackgroundImage:[UIImage imageNamed:self.imageArray[preIndex]] forState:UIControlStateNormal];
        [self.currentImageButton setBackgroundImage:[UIImage imageNamed:self.imageArray[self.currentImageIndex]] forState:UIControlStateNormal];
        [self.nextImageButton setBackgroundImage:[UIImage imageNamed:self.imageArray[nextIndex]] forState:UIControlStateNormal];
        
    } else {
        /** 使用SDWebImage时候使用如下代码 导入UIButton * WebCache **/
//        [self.preImageButton sd_setBackgroundImageWithURL:self.imageArray[preIndex] forState:UIControlStateNormal];
//        [self.currentImageButton sd_setBackgroundImageWithURL:self.imageArray[self.currentImageIndex] forState:UIControlStateNormal];
//        [self.nextImageButton sd_setBackgroundImageWithURL:self.imageArray[nextIndex] forState:UIControlStateNormal];
    }
    
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self startTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    int cosIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if (cosIndex == 1) return;
    
    if (cosIndex > 1) {
        self.currentImageIndex = self.currentImageIndex + 1 == self.imageArray.count ? 0 : self.currentImageIndex + 1;
        self.pageControl.currentPage = self.pageControl.currentPage == self.pageControl.numberOfPages - 1 ? 0 : self.pageControl.currentPage + 1;
        
    } else {
        self.currentImageIndex = self.currentImageIndex - 1 < 0 ? self.imageArray.count - 1 : self.currentImageIndex - 1;
        self.pageControl.currentPage = self.pageControl.currentPage == 0 ? self.pageControl.numberOfPages - 1 : self.pageControl.currentPage - 1;
    }
    
    [self loadImageButtons];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        _scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    
    if (_pageControl == nil) {
        
        UIPageControl * pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        _pageControl = pageControl;
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
    
}

- (UIButton *)preImageButton {
    
    if (_preImageButton == nil) {
         _preImageButton = [self setupImageButton];
    }
    return _preImageButton;
}

- (UIButton *)currentImageButton {
    if (_currentImageButton == nil) {
        _currentImageButton = [self setupImageButton];
    }
    return _currentImageButton;
}

- (UIButton *)nextImageButton {
    if (_nextImageButton == nil) {
        _nextImageButton = [self setupImageButton];
    }
    return _nextImageButton;
}

- (UIButton *)setupImageButton  {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollView addSubview:button];
    [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    return button;
}


#pragma mark - 图片点击
- (void)buttonDidClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(bannerView:imageDidClickWithIndex:)]) {
        [self.delegate bannerView:self imageDidClickWithIndex:self.currentImageIndex];
    }
}

- (void)dealloc {
    
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

@end
