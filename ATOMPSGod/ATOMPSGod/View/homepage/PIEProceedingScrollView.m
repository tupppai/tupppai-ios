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
    UINib* nib = [UINib nibWithNibName:@"PIEMyAskCollectionCell" bundle:nil];
    [_askCollectionView registerNib:nib forCellWithReuseIdentifier:@"PIEMyAskCollectionCell"];
    [self addSubview:_askCollectionView];
}

- (void)initToHelpTableView {
    _toHelpTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    _toHelpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _toHelpTableView.backgroundColor = [UIColor clearColor];
    UINib* nib = [UINib nibWithNibName:@"PIEToHelpTableViewCell" bundle:nil];
    [_toHelpTableView registerNib:nib forCellReuseIdentifier:@"PIEToHelpTableViewCell"];
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
    UINib* nib = [UINib nibWithNibName:@"PIEDoneCollectionViewCell" bundle:nil];
    [_doneCollectionView registerNib:nib forCellWithReuseIdentifier:@"PIEDoneCollectionViewCell"];
    [self addSubview:_doneCollectionView];
}

- (void)toggleWithType:(PIEProceedingType)type {
    _type = type;
    if (_type == PIEProceedingTypeAsk) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    } else if (_type == PIEProceedingTypeToHelp) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
    }  else if (_type == PIEProceedingTypeDone) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(SCREEN_WIDTH*2, 0);
        }];
    }

}


@end
