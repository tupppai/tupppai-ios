//
//  ATOMHomepageCustomTitleView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

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
    _hotTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 50, 30)];
    [_hotTitleButton setTitle:@"热门" forState:UIControlStateNormal];
    [_hotTitleButton setTitleColor:[UIColor colorWithHex:0x717171] forState:UIControlStateNormal];
    [_hotTitleButton setTitleColor:[UIColor colorWithHex:0x00adef] forState:UIControlStateSelected];
    [self addSubview:_hotTitleButton];
    _recentTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_hotTitleButton.frame) +60 , 0, 50, 30)];
    [_recentTitleButton setTitle:@"最新" forState:UIControlStateNormal];
    [_recentTitleButton setTitleColor:[UIColor colorWithHex:0x717171] forState:UIControlStateNormal];
    [_recentTitleButton setTitleColor:[UIColor colorWithHex:0x00adef] forState:UIControlStateSelected];
    [self addSubview:_recentTitleButton];
}

































@end
