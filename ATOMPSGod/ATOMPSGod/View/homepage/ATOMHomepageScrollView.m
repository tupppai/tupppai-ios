//
//  ATOMHomepageScrollView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomepageScrollView.h"

@interface ATOMHomepageScrollView ()



@end

@implementation ATOMHomepageScrollView

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
    self.backgroundColor = [UIColor colorWithHex:0xededed];
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
    _homepageHotTableView = [[PSUITableView alloc] initWithFrame:_homepageHotView.bounds];
    _homepageHotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_homepageHotView addSubview:_homepageHotTableView];
}

- (void)createHomepageRecentView {
    _homepageRecentView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    [self addSubview:_homepageRecentView];
    _homepageSeekHelpTableView = [[PSUITableView alloc] initWithFrame:_homepageRecentView.bounds];
    _homepageSeekHelpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_homepageRecentView addSubview:_homepageSeekHelpTableView];
}

- (void)changeUIAccording:(NSString *)buttonTitle {
    if ([buttonTitle isEqualToString:@"热门"]) {
        _currentHomepageType = ATOMHomepageHotType;
        self.contentOffset = CGPointMake(0, 0);
        [_homepageHotTableView reloadData];
    } else if ([buttonTitle isEqualToString:@"最新"]) {
        _currentHomepageType = ATOMHomepageRecentType;
        self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [_homepageSeekHelpTableView reloadData];
    }
}

- (NSInteger)typeOfCurrentHomepageView {
    return _currentHomepageType;
}





















@end
