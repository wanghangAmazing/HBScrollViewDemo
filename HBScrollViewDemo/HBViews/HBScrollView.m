//
//  HBScrollView.m
//  HBProject
//
//  Created by Patrick W on 2017/9/1.
//  Copyright © 2017年 original. All rights reserved.
//

#import "HBScrollView.h"

@interface HBScrollView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSTimer *scrollTimer;

@property (strong, nonatomic) NSMutableArray<__kindof HB_VIEW *> *contentSubviews;

@end

@implementation HBScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

- (void)setupConfig {
    self.autoScrollForSinglePage = NO;
    self.scrollForSinglePage = NO;
    self.autoScroll = YES;
    self.timeInterval = 2.5;
}

- (void)setupSubviews {
    
    [self addSubview:self.scrollView];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraints:@[topConstraint, bottomConstraint, leftConstraint, rightConstraint]];
}

- (void)updateContentSubviews {
    
    for (HB_VIEW *subview in self.contentSubviews) {
        [self.scrollView addSubview:subview];
        [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self.scrollView addConstraint:topConstraint];
        
        BOOL isFirstObject = [subview isEqual:[self.contentSubviews firstObject]];
        BOOL isLastObject = [subview isEqual:[self.contentSubviews lastObject]];
        //第一个也可能是最后一个
        if (isFirstObject) {
            //first
            NSLayoutConstraint *leftConstaint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
            [self.scrollView addConstraint:leftConstaint];
            
        } else {
            //other
            NSInteger currentIndex = [self.contentSubviews indexOfObject:subview];
            HB_VIEW *lastView = [self.contentSubviews objectAtIndex:currentIndex - 1];
            
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
            [self.scrollView addConstraint:leftConstraint];
        }
        
        if (isLastObject) {
            //last
            NSLayoutConstraint *rightConstaint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
            [self.scrollView addConstraint:rightConstaint];
        }
        
        [self.scrollView addConstraints:@[widthConstraint, heightConstraint]];
    }
    
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0)];
    [self startTimer];
}

#pragma mark - 一些私有方法

- (void)removeAllContentSubviews {
    if (self.contentSubviews.count == 0) return;
    
    for (HB_VIEW *subview in self.contentSubviews) {
        [subview removeFromSuperview];
    }
    [self.contentSubviews removeAllObjects];
}

- (HB_VIEW *)duplicateView:(__kindof HB_VIEW *)originalView {
    NSData  *archiveData = [NSKeyedArchiver archivedDataWithRootObject:originalView];
    HB_VIEW *newView = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    return newView;
}

- (void)setupPageIndex:(CGPoint)point {
    NSInteger page = point.x / CGRectGetWidth(self.scrollView.bounds) - 1;
    !self.pageIndexChange ?: self.pageIndexChange(page);
}

#pragma mark - 定时器

- (void)startTimer {
    //定时器已存在或者不需要自动滚动
    if (self.scrollTimer || !self.autoScroll) return;
    if (self.contentSubviews.count == 3 && !self.autoScrollForSinglePage) return;
    if (self.contentSubviews.count == 3 && !self.scrollForSinglePage) return;
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval
                                                        target:self
                                                      selector:@selector(autoScrollAction)
                                                      userInfo:nil repeats:YES];
}

- (void)releaseTimer {
    if (!self.scrollTimer)  return;
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)autoScrollAction {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, 0) animated:YES];
}

- (void)setupContentSubviews:(NSArray<__kindof HB_VIEW *> *)contentViews {
    [self removeAllContentSubviews];
    if (contentViews == nil) return;
    
    [self.contentSubviews addObject:[self duplicateView:[contentViews lastObject]]];
    [self.contentSubviews addObjectsFromArray:contentViews];
    [self.contentSubviews addObject:[self duplicateView:[contentViews firstObject]]];
    
    [self updateContentSubviews];
    
    self.scrollView.scrollEnabled = !(self.contentSubviews.count == 3 && !self.scrollForSinglePage);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    if (scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake((self.contentSubviews.count - 2) * width, 0)];
    } else if (scrollView.contentOffset.x >= (self.contentSubviews.count - 1) * width ) {
        [scrollView setContentOffset:CGPointMake(width, 0)];
    }
    
    NSInteger page = (self.scrollView.contentOffset.x - CGRectGetWidth(self.scrollView.bounds) / 2.0 - 1.0) / CGRectGetWidth(self.scrollView.bounds);
    !self.pageIndexChange ?: self.pageIndexChange(page);
    
    !self.scrollViewDidScroll ?: self.scrollViewDidScroll(scrollView.contentOffset);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self releaseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //界面转场可能出现banner偏移
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    NSInteger offset = ceil(scrollView.contentOffset.x / width);
    [scrollView setContentOffset:CGPointMake(offset * width, 0) animated:YES];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (NSMutableArray<UIView *> *)contentSubviews {
    if (!_contentSubviews) {
        _contentSubviews = [NSMutableArray array];
    }
    return _contentSubviews;
}


@end
