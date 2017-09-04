//
//  HBBannerView.m
//  HBProject
//
//  Created by Patrick W on 2017/9/4.
//  Copyright © 2017年 original. All rights reserved.
//

#import "HBBannerView.h"
#import "HBScrollView.h"

@interface HBBannerView ()

@property (strong, nonatomic) HBScrollView *contentScrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation HBBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews {
    [self addSubview:self.contentScrollView];
    [self addSubview:self.pageControl];
    
    __weak typeof(self) weakSelf = self;
    [self.contentScrollView setPageIndexChange:^(NSInteger currentPage){
        weakSelf.pageControl.currentPage = currentPage;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        NSMutableArray *imageViews = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            NSString *name = [NSString stringWithFormat:@"image%d", i];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
            [imageViews addObject:imageView];
        }
        
        [self.contentScrollView setupContentSubviews:imageViews];
        self.pageControl.numberOfPages = imageViews.count;
    });
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentScrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 18, CGRectGetWidth(self.frame), 8);
}

- (HBScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[HBScrollView alloc] init];
        _contentScrollView.timeInterval = 3.0;
    }
    return _contentScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor blueColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

@end
