//
//  ATOMMyConcernTableFooterView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyConcernTableFooterView.h"

@implementation ATOMMyConcernTableFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _moreRecommend = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 0, 100, 50)];
    _moreRecommend.titleLabel.font = [UIFont systemFontOfSize:kFont14];
    [_moreRecommend setTitle:@"更多推荐" forState:UIControlStateNormal];
    [_moreRecommend setTitleColor:[UIColor colorWithHex:0x74c3ff] forState:UIControlStateNormal];
    [self addSubview:_moreRecommend];
}

@end
