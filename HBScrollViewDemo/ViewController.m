//
//  ViewController.m
//  HBScrollViewDemo
//
//  Created by Patrick W on 2017/9/4.
//  Copyright © 2017年 Original. All rights reserved.
//

#import "ViewController.h"
#import "HBBannerView.h"
#import "UIScrollView+HBLayout.h"
#import "FunctionItem.h"

@interface ViewController ()

@property (strong, nonatomic) HBBannerView *bannerView;

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView = [[HBBannerView alloc] init];
    [self.view addSubview:self.bannerView];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
//    self.scrollView.frame = CGRectMake(0, 215, CGRectGetWidth(self.view.frame), 210);
    
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i=0; i<13; i++) {
        FunctionItem *view = [FunctionItem new];
        [views addObject:view];
    }
    
    [self.scrollView hb_distributeSubviews:views withSubviewSize:CGSizeMake(60, 80) contentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10) lineSpace:5 numberOfRow:2 numberOfColumn:4];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.f constant:215];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.f constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.f constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:210];
    
    [self.view addConstraints:@[top, left, right, height]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.bannerView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 150);
}


@end
