//
//  ATOMPersonPageScrollView.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/8/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMPersonPageScrollView.h"

@implementation ATOMPersonPageScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configSelf];
        [self createSubView];
    }
    return self;
}
static float cellWidth;
static float cellHeight = 150;
static int collumnNumber = 3;

- (void)configSelf {
    self.frame = CGRectMake(0, 300, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 300);
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.pagingEnabled = YES;
}
- (void)createSubView {
    cellWidth = (SCREEN_WIDTH - (collumnNumber - 1) *kPadding5) / 3;
    [self createHomepageHotView];
    [self createHomepageRecentView];
}
- (UICollectionViewFlowLayout *)customFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = kPadding5;
    flowLayout.minimumLineSpacing = kPadding5;
    return flowLayout;
}
- (void)createHomepageHotView {
    _otherPersonUploadCollectionView = [[PWRefreshFooterCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:[self customFlowLayout]];
    _otherPersonUploadCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_otherPersonUploadCollectionView];
}

- (void)createHomepageRecentView {
    _otherPersonWorkCollectionView = [[PWRefreshFooterCollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:[self customFlowLayout]];
    _otherPersonWorkCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_otherPersonWorkCollectionView];
}

- (void)toggleCollectionView:(ATOMOtherPersonCollectionViewType)type {
        if (type == ATOMOtherPersonCollectionViewTypeAsk) {
            self.currentType = ATOMOtherPersonCollectionViewTypeAsk;
            self.contentOffset = CGPointMake(0, 0);
            [_otherPersonUploadCollectionView reloadData];
        } else if (type == ATOMOtherPersonCollectionViewTypeReply) {
            self.currentType = ATOMOtherPersonCollectionViewTypeReply;
            self.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            [_otherPersonWorkCollectionView reloadData];
        }
}
@end
