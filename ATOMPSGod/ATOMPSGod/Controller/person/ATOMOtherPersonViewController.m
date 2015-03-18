//
//  ATOMOtherPersonViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMOtherPersonViewController.h"
#import "ATOMOtherPersonView.h"
#import "ATOMMyWorkCollectionViewCell.h"
#import "ATOMMyUploadCollectionViewCell.h"
#import "ATOMMyFansViewController.h"
#import "ATOMMyConcernViewController.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMOtherPersonCollectionHeaderView.h"

@interface ATOMOtherPersonViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ATOMOtherPersonView *otherPersonView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ATOMOtherPersonViewController

static NSString *UploadCellIdentifier = @"OtherPersonUploadCell";
static NSString *WorkCellIdentifier = @"OtherPersonWorkCell";

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 11; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%d.jpg",i];
        UIImage *img = [UIImage imageNamed:imgName];
        [_dataSource addObject:img];
    }
}

- (void)createUI {
    self.title = @"atom";
    _otherPersonView = [ATOMOtherPersonView new];
    self.view = _otherPersonView;
    _otherPersonView.otherPersonUploadCollectionView.delegate = self;
    _otherPersonView.otherPersonUploadCollectionView.dataSource = self;
    _otherPersonView.otherPersonWorkCollectionView.delegate = self;
    _otherPersonView.otherPersonWorkCollectionView.dataSource = self;
    [self registerCollection];
    [self addTargetToOtherPersonView:_otherPersonView.uploadHeaderView];
    [self addTargetToOtherPersonView:_otherPersonView.workHeaderView];

    [_otherPersonView changeToUploadView];


}

- (void)addTargetToOtherPersonView:(ATOMOtherPersonCollectionHeaderView *)headerView {
    [headerView.otherPersonUploadButton addTarget:self action:@selector(clickOtherPersonUploadButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.otherPersonWorkButton addTarget:self action:@selector(clickOtherPersonWorkButton:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapConcernGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcernGesture:)];
    [headerView.attentionLabel addGestureRecognizer:tapConcernGesture];
    
    UITapGestureRecognizer *tapFansGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFansGesture:)];
    [headerView.fansLabel addGestureRecognizer:tapFansGesture];
}

- (void)registerCollection {
    [_otherPersonView.otherPersonUploadCollectionView registerClass:[ATOMMyUploadCollectionViewCell class] forCellWithReuseIdentifier:UploadCellIdentifier];
    [_otherPersonView.otherPersonWorkCollectionView registerClass:[ATOMMyWorkCollectionViewCell class] forCellWithReuseIdentifier:WorkCellIdentifier];
}

#pragma mark - Click Event

- (void)clickOtherPersonUploadButton:(UIButton *)sender {
    [_otherPersonView changeToUploadView];
}

- (void)clickOtherPersonWorkButton:(UIButton *)sender {
    [_otherPersonView changeToWorkView];
}

#pragma mark - Gesture Event

- (void)tapConcernGesture:(UITapGestureRecognizer *)gesture {
    ATOMMyConcernViewController *mfvc = [ATOMMyConcernViewController new];
    [self pushViewController:mfvc animated:YES];
}

- (void)tapFansGesture:(UITapGestureRecognizer *)gesture {
    ATOMMyFansViewController *mfvc = [ATOMMyFansViewController new];
    [self pushViewController:mfvc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = -44;
    CGFloat originHeight = -200;
    if (scrollView == _otherPersonView.otherPersonUploadCollectionView) {
        CGRect frame = _otherPersonView.uploadHeaderView.frame;
        if (scrollView.contentOffset.y >= originHeight && scrollView.contentOffset.y <= sectionHeaderHeight) {
            frame.origin.y = originHeight - scrollView.contentOffset.y;
            _otherPersonView.uploadHeaderView.frame = frame;
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            frame.origin.y = originHeight - sectionHeaderHeight;
            _otherPersonView.uploadHeaderView.frame = frame;
        }
    } else if (scrollView == _otherPersonView.otherPersonWorkCollectionView) {
        CGRect frame = _otherPersonView.workHeaderView.frame;
        if (scrollView.contentOffset.y >= originHeight && scrollView.contentOffset.y <= sectionHeaderHeight) {
            frame.origin.y = originHeight - scrollView.contentOffset.y;
            _otherPersonView.workHeaderView.frame = frame;
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            frame.origin.y = originHeight - sectionHeaderHeight;
            _otherPersonView.workHeaderView.frame = frame;
        }
    }

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _otherPersonView.otherPersonUploadCollectionView) {
        ATOMMyUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UploadCellIdentifier forIndexPath:indexPath];
        cell.workImage = _dataSource[indexPath.row];
        cell.praiseNumber = 10;
        return cell;
    } else {
        ATOMMyWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WorkCellIdentifier forIndexPath:indexPath];
        cell.workImage = _dataSource[indexPath.row];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
    hdvc.pushType = ATOMMyUploadType;
    [self pushViewController:hdvc animated:YES];
}


























@end
