//
//  PIEFollowScrollView.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/20/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteScrollView.h"

@implementation PIEEliteScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configSelf];
        [self createSubView];
    }
    return self;
}

- (void)configSelf {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT);
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.pagingEnabled = YES;
    self.scrollsToTop = NO;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.type = PIEFollowScrollTypeFollow;
}

- (void)createSubView {
    [self initTable1];
    [self initTable2];
}


- (void)initTable1 {
    _tableFollow = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    _tableFollow.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableFollow.backgroundColor = [UIColor clearColor];
    _tableFollow.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableFollow];
}
- (void)initTable2 {
    _tableHot = [[RefreshTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    _tableHot.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableHot.backgroundColor = [UIColor clearColor];
    _tableHot.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableHot];
}


- (void)toggle {
    if (_type == PIEFollowScrollTypeFollow) {
        _type = PIEFollowScrollTypeHot;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    } else {
        _type = PIEFollowScrollTypeFollow;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    }
}

- (void)toggleWithType:(PIEFollowScrollType)type {
    _type = type;
    if (_type == PIEFollowScrollTypeFollow) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    }
}

@end
