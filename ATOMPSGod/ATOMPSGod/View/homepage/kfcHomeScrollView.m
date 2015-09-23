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
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.type = PIEHomeTypeAsk;
}

- (void)createSubView {
    [self createHomepageHotView];
    [self createHomepageAskView];
}

- (void)createHomepageHotView {
    _replyTable = [[RefreshTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    _replyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _replyTable.backgroundColor = [UIColor clearColor];
    _replyTable.showsVerticalScrollIndicator = NO;
    [self addSubview:_replyTable];
}

- (void)createHomepageAskView {
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
    layout.minimumColumnSpacing = 8;
    layout.minimumInteritemSpacing = 10;
    _collectionView = [[PIERefreshCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT) collectionViewLayout:layout];
    _collectionView.toRefreshBottom = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.toRefreshTop = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];
}

- (void)toggle {
    if (_type == PIEHomeTypeAsk) {
        _type = PIEHomeTypeHot;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    } else {
        _type = PIEHomeTypeAsk;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    }
}

- (void)toggleWithType:(PIEHomeType)type {
    _type = type;
    if (_type == PIEHomeTypeAsk) {
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
