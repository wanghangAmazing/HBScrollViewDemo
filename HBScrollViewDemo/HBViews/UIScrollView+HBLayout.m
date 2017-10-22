//
//  UIScrollView+HBLayout.m
//  HBScrollViewDemo
//
//  Created by Patrick W on 2017/10/19.
//  Copyright © 2017年 Original. All rights reserved.
//

#import "UIScrollView+HBLayout.h"

@implementation UIScrollView (HBLayout)

- (void)hb_distributeSubviews:(NSArray<UIView *> *)subviews withSubviewSize:(CGSize)size contentEdgeInsets:(UIEdgeInsets)insets lineSpace:(CGFloat)lineSpace numberOfRow:(NSInteger)row numberOfColumn:(NSInteger)column {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    //每页的大小
    NSInteger pageSize = row * column;
    //元素的数量
    NSInteger elementCount = subviews.count;
    //需要显示几页
    NSInteger pages = ceilf((elementCount / (CGFloat)pageSize));
    
    /**
     *  创建临时的视图，用于计算相等间距与contentSize.width
     */
    NSMutableArray<UIView *> *spaces = [NSMutableArray array];
    NSInteger spaceNum = pages * (column - 1);
    CGFloat offset = (insets.left + insets.right + column * size.width) / (column - 1) ;
    for (NSInteger i = 0; i < spaceNum; i++) {
        UIView *spaceView = [UIView new];
        spaceView.backgroundColor = [UIColor redColor];
        [spaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:spaceView];
        
        NSMutableArray *constrains = [NSMutableArray array];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:spaceView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
        NSLayoutConstraint *heightConstaint = [NSLayoutConstraint constraintWithItem:spaceView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:10];
        [constrains addObject:topConstraint];
        [constrains addObject:heightConstaint];
        if ([spaces lastObject]) {
            CGFloat leftOffset = (i != 0 && i % (column - 1) == 0) ? (insets.right + insets.left + size.width * 2) : size.width;
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:spaceView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[spaces lastObject] attribute:NSLayoutAttributeRight multiplier:1.f constant:leftOffset];
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:spaceView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[spaces lastObject] attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
            [constrains addObject:leftConstraint];
            [constrains addObject:widthConstraint];
        } else {
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:spaceView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:(insets.left + size.width)];
            CGFloat mult = 1.0 / (column - 1);
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:spaceView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:mult constant:-offset];
            [constrains addObject:leftConstraint];
            [constrains addObject:widthConstraint];
        }
        
        if (i == spaceNum - 1) {
            NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:spaceView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:(-(size.width + insets.right))];
            [constrains addObject:rightConstraint];
        }
        
        [self addConstraints:constrains];
        [spaceView setHidden:YES];
        [spaces addObject:spaceView];
    }
    
    NSInteger idx = 0;
    UIView *lastView = nil;
    for (UIView *subview in subviews) {
        //检查是否有superview
        subview.superview ?: [self addSubview:subview];
        NSAssert(subview.superview == self, @"Super Did Error");
        //该元素在每页的第几个
        NSInteger pageIdx = idx %  pageSize;
        //该元素在每行的第几个
        NSInteger rowIdx = idx % column;
        //该元素在每页的第几行
        NSInteger pageRowIdx = pageIdx / column;
        //该元素在第几页
        NSInteger curPageIdx = idx / pageSize;
        //布局约束
        NSMutableArray *constrains = [NSMutableArray array];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size.width];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size.height];
        [constrains addObjectsFromArray:@[widthConstraint, heightConstraint]];
        if (idx == 0) {
            //第一页的第一个元素
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:insets.top];
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:insets.left];
            [constrains addObjectsFromArray:@[topConstraint, leftConstraint]];
        } else if (pageIdx == 0) {
            //其他页的第一个元素
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:insets.top];
            NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:spaces[rowIdx + curPageIdx * (column - 1)] attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
            [constrains addObjectsFromArray:@[topConstraint, rightConstraint]];
            
        } else if (pageRowIdx != 0 && rowIdx == 0) {
            //不是每页的第一行 && 第一列
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:lineSpace];
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:subviews[curPageIdx * pageSize] attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
            [constrains addObjectsFromArray:@[topConstraint, leftConstraint]];
        } else {
            //其他情况
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:spaces[rowIdx - 1 + curPageIdx * (column - 1)] attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
            [constrains addObjectsFromArray:@[topConstraint, leftConstraint]];
        }
        if (curPageIdx == 0 && pageRowIdx == row - 1 && rowIdx == 0) {
            //用来顶开contentSize.height
            NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-insets.bottom];
            [constrains addObject:bottomConstraint];
        }
        
        [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:constrains];
        
        idx ++;
        lastView = subview;
    }
}

@end
