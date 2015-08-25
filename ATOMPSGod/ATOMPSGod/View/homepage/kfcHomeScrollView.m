//
//  kfcHomeScrollView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "kfcHomeScrollView.h"

@interface kfcHomeScrollView ()

@end

@implementation kfcHomeScrollView

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
}

- (void)createSubView {
    [self createHomepageHotView];
    [self createHomepageRecentView];
}

- (void)createHomepageHotView {
    _homepageHotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    [self addSubview:_homepageHotView];
    _hotTable = [[RefreshTableView alloc] initWithFrame:_homepageHotView.bounds];
    _hotTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _hotTable.scrollsToTop = YES;
    [_homepageHotView addSubview:_hotTable];
}

- (void)createHomepageRecentView {
    _homepageRecentView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    [self addSubview:_homepageRecentView];
    _askTable = [[RefreshTableView alloc] initWithFrame:_homepageRecentView.bounds];
    _askTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _askTable.scrollsToTop = YES;
    [_homepageRecentView addSubview:_askTable];
}

- (void)changeUIAccording:(NSString *)buttonTitle {
    if ([buttonTitle isEqualToString:@"热门"]) {
        _type = ATOMHomepageViewTypeHot;
        [UIView animateWithDuration:0.5 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    } else if ([buttonTitle isEqualToString:@"最新"]) {
        _type = ATOMHomepageViewTypeAsk;
        [UIView animateWithDuration:0.5 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    }
}








@end
