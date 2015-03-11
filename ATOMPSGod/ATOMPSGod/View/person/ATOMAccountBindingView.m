//
//  ATOMAccountBindingView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAccountBindingView.h"

@implementation ATOMAccountBindingView

static int padding10 = 10;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding10, 0, SCREEN_WIDTH - padding10, 22.5)];
    [self addSubview:_topLabel];
    
    _accountBindingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topLabel.frame), SCREEN_WIDTH, CGHeight(self.frame) - CGHeight(_topLabel.frame))];
    _accountBindingTableView.backgroundColor = [UIColor colorWithHex:0xededed];
    _accountBindingTableView.tableFooterView = [UIView new];
    [self addSubview:_accountBindingTableView];
}

@end
