//
//  PIEProceedingScrollView.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingScrollView.h"
#import "CHTCollectionViewWaterfallLayout.h"
@implementation PIEProceedingScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
        [self initSubviews];
    }
    return self;
}

- (void)commonInit {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT);
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    self.pagingEnabled = YES;
    self.scrollsToTop = NO;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.type = PIEProceedingTypeAsk;
}

- (void)initSubviews {
    [self initAskCollectionView];
    [self initToHelpTableView];
    [self initDoneCollectionView];
}
- (void)initAskCollectionView {
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
    layout.minimumColumnSpacing = 8;
    layout.minimumInteritemSpacing = 10;
    _askCollectionView = [[PIERefreshCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT) collectionViewLayout:layout];
    _askCollectionView.toRefreshBottom = YES;
    _askCollectionView.backgroundColor = [UIColor clearColor];
    _askCollectionView.toRefreshTop = YES;
    _askCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self addSubview:_askCollectionView];
}

- (void)initToHelpTableView {
    _toHelpTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    _toHelpTableView.backgroundColor = [UIColor clearColor];

    [self addSubview:_toHelpTableView];
}

- (void)initDoneCollectionView {
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
    layout.minimumColumnSpacing = 8;
    layout.minimumInteritemSpacing = 10;
    _doneCollectionView = [[PIERefreshCollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT) collectionViewLayout:layout];
    _doneCollectionView.toRefreshBottom = YES;
    _doneCollectionView.backgroundColor = [UIColor clearColor];
    _doneCollectionView.toRefreshTop = YES;
    _doneCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self addSubview:_doneCollectionView];
}

- (void)toggleWithType:(PIEProceedingType)type {
    _type = type;
    if (_type == PIEProceedingTypeAsk) {
        _askCollectionView.scrollsToTop = YES;
        _toHelpTableView.scrollsToTop = NO;
        _doneCollectionView.scrollsToTop = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    } else if (_type == PIEProceedingTypeToHelp) {
        _askCollectionView.scrollsToTop = NO;
        _toHelpTableView.scrollsToTop = YES;
        _doneCollectionView.scrollsToTop = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    }  else if (_type == PIEProceedingTypeDone) {
        _askCollectionView.scrollsToTop = NO;
        _toHelpTableView.scrollsToTop = NO;
        _doneCollectionView.scrollsToTop = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH*2, 0);
        }];
    }

}


@end
