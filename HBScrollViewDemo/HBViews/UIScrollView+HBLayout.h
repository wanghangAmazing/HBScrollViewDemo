//
//  UIScrollView+HBLayout.h
//  HBScrollViewDemo
//
//  Created by Patrick W on 2017/10/19.
//  Copyright © 2017年 Original. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HBLayout)

/**
 矩阵式布局与分页
 @param subviews 需要布局的view
 @param size 每个元素的尺寸
 @param insets 偏移量
 @param lineSpace 每行元素的间距
 @param row 行数
 @param column 列数
 */
- (void)hb_distributeSubviews:(NSArray<UIView *> *)subviews withSubviewSize:(CGSize)size contentEdgeInsets:(UIEdgeInsets)insets lineSpace:(CGFloat)lineSpace numberOfRow:(NSInteger)row numberOfColumn:(NSInteger)column;

@end
