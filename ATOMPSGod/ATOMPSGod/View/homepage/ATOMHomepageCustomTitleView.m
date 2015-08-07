//
//  ATOMHomepageCustomTitleView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//




//to be deleted
#import "ATOMHomepageCustomTitleView.h"

@implementation ATOMHomepageCustomTitleView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 200, 30);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _hotTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 30)];
    [_hotTitleButton setTitle:@"热门" forState:UIControlStateNormal];
    [_hotTitleButton setImage:[UIImage imageNamed:@"btn_home_hot"] forState:UIControlStateNormal];
    [_hotTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _hotTitleButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_hotTitleButton setTitleEdgeInsets:UIEdgeInsetsMake(8, 11, 8, 0)];
    [self addSubview:_hotTitleButton];
    _recentTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_hotTitleButton.frame) +60 , 0, 60, 30)];
    [_recentTitleButton setTitle:@"求P" forState:UIControlStateNormal];
    [_recentTitleButton setImage:[UIImage imageNamed:@"btn_home_new"] forState:UIControlStateNormal];
    [_recentTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _recentTitleButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_recentTitleButton setTitleEdgeInsets:UIEdgeInsetsMake(8, 11, 8, 0)];
    [self addSubview:_recentTitleButton];
    
}

































@end
