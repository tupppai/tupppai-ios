//
//  ATOMMyConcernTableFooterView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyConcernTableFooterView.h"

@implementation ATOMMyConcernTableFooterView

static int padding10 = 10;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xededed];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 28.5);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _moreRecommend = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - padding10 - 80, 0, 80, 28.5)];
    _moreRecommend.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_moreRecommend setTitle:@"更多推荐>" forState:UIControlStateNormal];
    [_moreRecommend setTitleColor:[UIColor colorWithHex:0x00aeed] forState:UIControlStateNormal];
    [self addSubview:_moreRecommend];
}

@end
