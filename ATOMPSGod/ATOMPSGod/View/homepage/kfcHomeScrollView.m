//
//  kfcHomeScrollView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "kfcHomeScrollView.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEAskCollectionCell.h"

#define CELL_IDENTIFIER @"WaterfallCell"

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
    self.scrollsToTop = NO;
}

- (void)createSubView {
    [self createHomepageHotView];
    [self createHomepageAskView];
}

- (void)createHomepageHotView {
    _homepageHotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    [self addSubview:_homepageHotView];
    _hotTable = [[RefreshTableView alloc] initWithFrame:_homepageHotView.bounds];
    _hotTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_homepageHotView addSubview:_hotTable];
}

- (void)createHomepageAskView {
    _homepageAskView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    [self addSubview:_homepageAskView];
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumColumnSpacing = 20;
    layout.minimumInteritemSpacing = 30;
    _collectionView = [[UICollectionView alloc] initWithFrame:_homepageAskView.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    [_collectionView registerClass:[PIEAskCollectionCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [_homepageAskView addSubview:_collectionView];
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
