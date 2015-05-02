//
//  ATOMOtherPersonView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMOtherPersonView.h"
#import "ATOMOtherPersonCollectionHeaderView.h"

@interface ATOMOtherPersonView ()

@property (nonatomic, assign) ATOMOtherPersonCollectionViewType currentType;

@end

@implementation ATOMOtherPersonView

static float cellWidth;
static float cellHeight = 150;
static int collumnNumber = 3;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        [self createSubView];
    }
    return self;
}

- (UICollectionViewFlowLayout *)customFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = kPadding5;
    flowLayout.minimumLineSpacing = kPadding5;
    return flowLayout;
}

- (void)createSubView {
    _uploadHeaderView = [ATOMOtherPersonCollectionHeaderView new];
    _workHeaderView = [ATOMOtherPersonCollectionHeaderView new];
    
    cellWidth = (SCREEN_WIDTH - (collumnNumber - 1) *kPadding5) / 3;
    
    _otherPersonUploadCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[self customFlowLayout]];
    _otherPersonUploadCollectionView.backgroundColor = [UIColor whiteColor];
    _otherPersonWorkCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[self customFlowLayout]];
    _otherPersonWorkCollectionView.backgroundColor = [UIColor whiteColor];
    _otherPersonUploadCollectionView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0);
    _otherPersonWorkCollectionView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0);
}

- (void)changeToUploadView {
    if (!_uploadHeaderView.otherPersonUploadButton.selected) {
        _uploadHeaderView.blueThinView.frame = CGRectMake(0, CGRectGetMaxY(_uploadHeaderView.otherPersonUploadButton.frame), SCREEN_WIDTH / 2, kPadding5);
        _uploadHeaderView.grayThinView.frame = CGRectMake(SCREEN_WIDTH / 2, CGRectGetMaxY(_uploadHeaderView.otherPersonUploadButton.frame) + 3, SCREEN_WIDTH / 2, kPadding5 / 2);
        _uploadHeaderView.otherPersonUploadButton.selected = YES;
        _uploadHeaderView.otherPersonWorkButton.selected = NO;
        _workHeaderView.otherPersonUploadButton.selected = YES;
        _workHeaderView.otherPersonWorkButton.selected = NO;
        [_otherPersonWorkCollectionView removeFromSuperview];
        [_workHeaderView removeFromSuperview];
        [self addSubview:_otherPersonUploadCollectionView];
        [self addSubview:_uploadHeaderView];
        [self bringSubviewToFront:_uploadHeaderView];
        _currentType = ATOMUploadType;
    }
}

- (void)changeToWorkView {
    if (!_workHeaderView.otherPersonWorkButton.selected) {
        _workHeaderView.blueThinView.frame = CGRectMake(SCREEN_WIDTH / 2, CGRectGetMaxY(_uploadHeaderView.otherPersonWorkButton.frame), SCREEN_WIDTH / 2, kPadding5);
        _workHeaderView.grayThinView.frame = CGRectMake(0, CGRectGetMaxY(_uploadHeaderView.otherPersonWorkButton.frame) + 3, SCREEN_WIDTH / 2, kPadding5 / 2);
        _workHeaderView.otherPersonUploadButton.selected = NO;
        _workHeaderView.otherPersonWorkButton.selected = YES;
        _uploadHeaderView.otherPersonUploadButton.selected = NO;
        _uploadHeaderView.otherPersonWorkButton.selected = YES;
        [_otherPersonUploadCollectionView removeFromSuperview];
        [_uploadHeaderView removeFromSuperview];
        [self addSubview:_otherPersonWorkCollectionView];
        [self addSubview:_workHeaderView];
        [self bringSubviewToFront:_workHeaderView];
        _currentType = ATOMWorkType;
    }
}

- (ATOMOtherPersonCollectionViewType)typeOfCurrentCollectionView {
    return _currentType;
}






















@end
