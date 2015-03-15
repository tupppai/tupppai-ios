//
//  ATOMInviteTableHeaderView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteTableHeaderView.h"

@interface ATOMInviteTableHeaderView ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation ATOMInviteTableHeaderView

static int padding10 = 10;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 28.5);
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    _topLine.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    [self addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 0.5, SCREEN_WIDTH, 0.5)];
    _bottomLine.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    [self addSubview:_bottomLine];
    
    _littleVerticalView = [[UIView alloc] initWithFrame:CGRectMake(padding10, 4.25, 2, padding10 * 2)];
    [self addSubview:_littleVerticalView];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_littleVerticalView.frame) + padding10, 4.25, 120, padding10 * 2)];
    _titleLabel.textColor = [UIColor colorWithHex:0x6e6f73];
    [self addSubview:_titleLabel];
}

@end
