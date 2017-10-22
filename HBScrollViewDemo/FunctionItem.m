//
//  FunctionItem.m
//  HBScrollViewDemo
//
//  Created by Patrick W on 2017/10/22.
//  Copyright © 2017年 Original. All rights reserved.
//

#import "FunctionItem.h"

@interface FunctionItem ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end;

@implementation FunctionItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadViews];
}

- (void)loadViews {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    [self addSubview:self.contentView];
    
    self.imageView.backgroundColor = [UIColor blueColor];
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame) / 2;
    self.imageView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

@end
