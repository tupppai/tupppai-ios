//
//  ATOMMyConcernTableHeaderView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyConcernTableHeaderView.h"

@interface ATOMMyConcernTableHeaderView ()


@end

@implementation ATOMMyConcernTableHeaderView

static int padding10 = 10;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 28.5);
        self.backgroundColor = [UIColor colorWithHex:0xededed];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _littleVerticalView = [[UIView alloc] initWithFrame:CGRectMake(padding10, 4.25, 2, padding10 * 2)];
    [self addSubview:_littleVerticalView];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_littleVerticalView.frame) + padding10, 4.25, 80, padding10 * 2)];
    _titleLabel.textColor = [UIColor colorWithHex:0x6e6f73];
    [self addSubview:_titleLabel];
}






























@end
