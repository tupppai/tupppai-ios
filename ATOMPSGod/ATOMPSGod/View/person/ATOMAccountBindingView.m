//
//  ATOMAccountBindingView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAccountBindingView.h"

@implementation ATOMAccountBindingView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {    
    _accountBindingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    _accountBindingTableView.tableFooterView = [UIView new];
    [self addSubview:_accountBindingTableView];
}

@end
