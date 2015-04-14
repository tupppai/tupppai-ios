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
#import "ATOMShowAskOrReply.h"
#import "ATOMHomeImage.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMAskViewModel.h"
#import "ATOMReplyViewModel.h"
#import "ATOMRecentDetailViewController.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMOtherPersonViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ATOMOtherPersonView *otherPersonView;
@property (nonatomic, strong) NSMutableArray *uploadDataSource;
@property (nonatomic, strong) NSMutableArray *workDataSource;
@property (nonatomic, strong) NSMutableArray *uploadHomeImageDataSource;
@property (nonatomic, strong) NSMutableArray *workHomeImageDataSource;
@property (nonatomic, assign) NSInteger currentUploadPage;
@property (nonatomic, assign) NSInteger currentWorkPage;
@property (nonatomic, assign) BOOL canRefreshUploadFooter;
@property (nonatomic, assign) BOOL canRefreshWorkFooter;
@property (nonatomic, assign) BOOL isFirstEnterWorkCollectionView;

@end

@implementation ATOMOtherPersonViewController

static NSString *UploadCellIdentifier = @"OtherPersonUploadCell";
static NSString *WorkCellIdentifier = @"OtherPersonWorkCell";

#pragma mark - Refresh

- (void)configCollectionViewRefresh {
    [_otherPersonView.otherPersonUploadCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreUploadData)];
    [_otherPersonView.otherPersonWorkCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreWorkData)];
    
}

- (void)loadMoreUploadData {
    if (_canRefreshUploadFooter) {
        [self getMoreDataSourceWithType:@"upload"];
    } else {
        [_otherPersonView.otherPersonUploadCollectionView.footer endRefreshing];
    }
}

- (void)loadMoreWorkData {
    if (_canRefreshWorkFooter) {
        [self getMoreDataSourceWithType:@"work"];
    } else {
        [_otherPersonView.otherPersonWorkCollectionView.footer endRefreshing];
    }
    
}

#pragma mark - GetDataSource

- (void)getDataSourceWithType:(NSString *)type {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    if ([type isEqualToString:@"upload"]) {
        _uploadDataSource = nil;
        _uploadDataSource = [NSMutableArray array];
        _uploadHomeImageDataSource = nil;
        _uploadHomeImageDataSource = [NSMutableArray array];
        _currentUploadPage = 1;
        [param setObject:@(_currentUploadPage) forKey:@"page"];
        [param setObject:@"new" forKey:@"type"];
        
    } else if ([type isEqualToString:@"work"]) {
        _workDataSource = nil;
        _workDataSource = [NSMutableArray array];
        _workHomeImageDataSource = nil;
        _workHomeImageDataSource = [NSMutableArray array];
        _currentWorkPage = 1;
        [param setObject:@(_currentWorkPage) forKey:@"page"];
        [param setObject:@"hot" forKey:@"type"];
    }
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    ATOMShowAskOrReply *showAskOrReply = [ATOMShowAskOrReply new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showAskOrReply ShowAskOrReply:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMHomeImage *homeImage in resultArray) {
            ATOMHomePageViewModel *homepageViewModel = [ATOMHomePageViewModel new];
            [homepageViewModel setViewModelData:homeImage];
            if ([ws.otherPersonView typeOfCurrentCollectionView] == ATOMUploadType) {
                ATOMAskViewModel *askViewModel = [ATOMAskViewModel new];
                [askViewModel setViewModelData:homeImage];
                [ws.uploadDataSource addObject:askViewModel];
                [ws.uploadHomeImageDataSource addObject:homepageViewModel];
            } else if ([ws.otherPersonView typeOfCurrentCollectionView] == ATOMWorkType) {
                ATOMReplyViewModel *replyViewModel = [ATOMReplyViewModel new];
                [replyViewModel setViewModelData:homeImage];
                [ws.workDataSource addObject:replyViewModel];
                [ws.workHomeImageDataSource addObject:homepageViewModel];
            }
        }
        NSLog(@"%d", (int)ws.uploadDataSource.count);
        if ([ws.otherPersonView typeOfCurrentCollectionView] == ATOMUploadType) {
            [ws.otherPersonView.otherPersonUploadCollectionView reloadData];
        } else if ([ws.otherPersonView typeOfCurrentCollectionView] == ATOMWorkType) {
            [ws.otherPersonView.otherPersonWorkCollectionView reloadData];
        }
    }];
}

- (void)getMoreDataSourceWithType:(NSString *)type {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    if ([type isEqualToString:@"upload"]) {
        _currentUploadPage++;
        [param setObject:@(_currentUploadPage) forKey:@"page"];
        
    } else if ([type isEqualToString:@"work"]) {
        _currentWorkPage++;
        [param setObject:@(_currentWorkPage) forKey:@"page"];
    }
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:type forKey:@"type"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    ATOMShowAskOrReply *showAskOrReply = [ATOMShowAskOrReply new];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [showAskOrReply ShowAskOrReply:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        [SVProgressHUD dismiss];
        for (ATOMHomeImage *homeImage in resultArray) {
            ATOMHomePageViewModel *homepageViewModel = [ATOMHomePageViewModel new];
            [homepageViewModel setViewModelData:homeImage];
            if ([ws.otherPersonView typeOfCurrentCollectionView] == ATOMUploadType) {
                ATOMAskViewModel *askViewModel = [ATOMAskViewModel new];
                [askViewModel setViewModelData:homeImage];
                [ws.uploadDataSource addObject:askViewModel];
                [ws.uploadHomeImageDataSource addObject:homepageViewModel];
            } else if ([ws.otherPersonView typeOfCurrentCollectionView] == ATOMWorkType) {
                ATOMReplyViewModel *replyViewModel = [ATOMReplyViewModel new];
                [replyViewModel setViewModelData:homeImage];
                [ws.workDataSource addObject:replyViewModel];
                [ws.workHomeImageDataSource addObject:homepageViewModel];
            }
        }
        if ([ws.otherPersonView typeOfCurrentCollectionView] == ATOMUploadType) {
            [ws.otherPersonView.otherPersonUploadCollectionView reloadData];
            [ws.otherPersonView.otherPersonUploadCollectionView.footer endRefreshing];
            if (resultArray.count == 0) {
                ws.canRefreshUploadFooter = NO;
            } else {
                ws.canRefreshUploadFooter = YES;
            }
        } else if ([ws.otherPersonView typeOfCurrentCollectionView] == ATOMWorkType) {
            [ws.otherPersonView.otherPersonWorkCollectionView reloadData];
            [ws.otherPersonView.otherPersonWorkCollectionView.footer endRefreshing];
            if (resultArray.count == 0) {
                ws.canRefreshWorkFooter = NO;
            } else {
                ws.canRefreshWorkFooter = YES;
            }
        }
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
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
    [self configCollectionViewRefresh];
    _canRefreshUploadFooter = YES;
    _canRefreshWorkFooter = YES;
    _isFirstEnterWorkCollectionView = YES;
    [self getDataSourceWithType:@"upload"];
    
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
    if (_isFirstEnterWorkCollectionView) {
        _isFirstEnterWorkCollectionView = NO;
        [self getDataSourceWithType:@"work"];
    }
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
        if (scrollView.contentOffset.y >= originHeight && scrollView.contentOffset.y < sectionHeaderHeight) {
            frame.origin.y = originHeight - scrollView.contentOffset.y;
            [UIView animateWithDuration:0.25 animations:^{
                _otherPersonView.uploadHeaderView.frame = frame;
               scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            }];
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            frame.origin.y = originHeight - sectionHeaderHeight;
            [UIView animateWithDuration:0.25 animations:^{
                _otherPersonView.uploadHeaderView.frame = frame;
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }];
        }
    } else if (scrollView == _otherPersonView.otherPersonWorkCollectionView) {
        CGRect frame = _otherPersonView.workHeaderView.frame;
        if (scrollView.contentOffset.y >= originHeight && scrollView.contentOffset.y < sectionHeaderHeight) {
            frame.origin.y = originHeight - scrollView.contentOffset.y;
            [UIView animateWithDuration:0.25 animations:^{
                _otherPersonView.workHeaderView.frame = frame;
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            }];
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            frame.origin.y = originHeight - sectionHeaderHeight;
            [UIView animateWithDuration:0.25 animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
                _otherPersonView.workHeaderView.frame = frame;
            }];
        }
    }

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_otherPersonView typeOfCurrentCollectionView] == ATOMUploadType) {
        return _uploadDataSource.count;
    } else if ([_otherPersonView typeOfCurrentCollectionView] == ATOMWorkType) {
        return _workDataSource.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _otherPersonView.otherPersonUploadCollectionView) {
        ATOMMyUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UploadCellIdentifier forIndexPath:indexPath];
        ATOMAskViewModel *model = _uploadDataSource[indexPath.row];
        [cell.workImageView setImageWithURL:[NSURL URLWithString:model.imageURL]];
        cell.totalPSNumber = model.totalPSNumber;
        return cell;
    } else {
        ATOMMyWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WorkCellIdentifier forIndexPath:indexPath];
        ATOMReplyViewModel *model = _workDataSource[indexPath.row];
        [cell.workImageView setImageWithURL:[NSURL URLWithString:model.imageURL]];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _otherPersonView.otherPersonUploadCollectionView) {
        ATOMAskViewModel *askViewModel = _uploadDataSource[indexPath.row];
        ATOMHomePageViewModel *homepageViewModel = _uploadHomeImageDataSource[indexPath.row];
        if ([askViewModel.totalPSNumber integerValue] == 0) {
            ATOMRecentDetailViewController *rdvc = [ATOMRecentDetailViewController new];
            rdvc.homePageViewModel = homepageViewModel;
            [self pushViewController:rdvc animated:YES];
        } else {
            ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
            hdvc.homePageViewModel = homepageViewModel;
            [self pushViewController:hdvc animated:YES];
        }
    } else {
        ATOMHomePageViewModel *homepageViewModel = _workHomeImageDataSource[indexPath.row];
        ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
        hdvc.homePageViewModel = homepageViewModel;
        [self pushViewController:hdvc animated:YES];
    }

}


























@end
