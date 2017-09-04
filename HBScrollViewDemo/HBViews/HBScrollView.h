//
//  HBScrollView.h
//  HBProject
//
//  Created by Patrick W on 2017/9/1.
//  Copyright © 2017年 original. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HB_VIEW UIView

typedef void(^hb_scrollViewPageChangeBlock)(NSInteger currentBlock);
typedef void(^hb_scrollViewDidScroll)(CGPoint offset);

@interface HBScrollView : UIView

#pragma mark - 配置相关，务必在设置数据前设置
@property (assign, nonatomic) NSTimeInterval timeInterval;  //轮播速度，默认2.5s
@property (assign, nonatomic) BOOL scrollForSinglePage;     //单个页面的时候是否可以滚动，默认不能滚动
@property (assign, nonatomic) BOOL autoScrollForSinglePage;     //单个页面的时候是否可以自动滚动，默认不能滚动
@property (assign, nonatomic) BOOL autoScroll;     //是否可以自动滚动，默认自动滚动
//@property (assign, nonatomic) BOOL infiniteLoop;     //是否无限循环滚动，默认无限循环滚动

#pragma mark - 代理回调
@property (copy, nonatomic) hb_scrollViewPageChangeBlock pageIndexChange;
@property (copy, nonatomic) hb_scrollViewDidScroll scrollViewDidScroll;

#pragma mark - 设置数据源
- (void)setupContentSubviews:(NSArray <__kindof HB_VIEW *> *)contentViews;

#pragma mark - 释放定时器
- (void)releaseTimer;

@end
