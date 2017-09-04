//
//  ViewController.m
//  HBScrollViewDemo
//
//  Created by Patrick W on 2017/9/4.
//  Copyright © 2017年 Original. All rights reserved.
//

#import "ViewController.h"
#import "HBBannerView.h"

@interface ViewController ()

@property (strong, nonatomic) HBBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView = [[HBBannerView alloc] init];
    [self.view addSubview:self.bannerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.bannerView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 150);
}


@end
