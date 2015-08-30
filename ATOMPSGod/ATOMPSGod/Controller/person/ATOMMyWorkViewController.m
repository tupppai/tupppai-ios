//
//  ATOMMyWorkViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyWorkViewController.h"
#import "ATOMMyWorkCollectionViewCell.h"
#import "DDHotDetailVC.h"
//#import "ATOMShowReply.h"
#import "ATOMHomeImage.h"
#import "DDAskPageVM.h"
#import "ATOMReplyViewModel.h"
#import "PWRefreshFooterCollectionView.h"
#import "DDAccountModel.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMMyWorkViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UIView *myWorkView;
@property (nonatomic, strong) PWRefreshFooterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ATOMMyWorkViewController

static int padding6 = 6;
static float cellWidth;
static float cellHeight = 150;
static int collumnNumber = 3;

#pragma mark - Refresh
-(void)didPullUpCollectionViewBottom:(PWRefreshFooterCollectionView *)collectionView {
    [self loadMoreData];
}
- (void)loadMoreData {
    if (_canRefreshFooter) {
        [self getMoreDataSource];
    } else {
        [_collectionView.footer endRefreshing];
    }
    
}

#pragma mark - GetDataSource

- (void)getDataSource {
    WS(ws);
    [[KShareManager mascotAnimator]show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    _dataSource = nil;
    _dataSource = [NSMutableArray array];
    _homeImageDataSource = nil;
    _homeImageDataSource = [NSMutableArray array];
    _currentPage = 1;
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@"hot" forKey:@"type"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    [DDAccountModel ShowMyReply:param withBlock:^(NSMutableArray *resultArray) {
        for (ATOMHomeImage *homeImage in resultArray) {
            DDAskPageVM *homepageViewModel = [DDAskPageVM new];
            homepageViewModel.ID = homeImage.askID;
            [ws.homeImageDataSource addObject:homepageViewModel];
            ATOMReplyViewModel *replyViewModel = [ATOMReplyViewModel new];
            replyViewModel.imageURL = homeImage.imageURL;
            [ws.dataSource addObject:replyViewModel];
        }
        [[KShareManager mascotAnimator]dismiss];
        ws.collectionView.dataSource = self;
        [ws.collectionView reloadData];
    }];
}

- (void)getMoreDataSource {
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timestamp = [[NSDate date] timeIntervalSince1970];
    ws.currentPage++;
    [param setObject:@(ws.currentPage) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@"hot" forKey:@"type"];
    [param setObject:@(timestamp) forKey:@"last_updated"];
    [param setObject:@"time" forKey:@"sort"];
    [param setObject:@"desc" forKey:@"order"];
    [param setObject:@(15) forKey:@"size"];
    
    [DDAccountModel ShowMyReply:param withBlock:^(NSMutableArray *resultArray) {
        for (ATOMHomeImage *homeImage in resultArray) {
            DDAskPageVM *homepageViewModel = [DDAskPageVM new];
            [homepageViewModel setViewModelData:homeImage];
            ATOMReplyViewModel *replyViewModel = [ATOMReplyViewModel new];
            [replyViewModel setViewModelData:homeImage];
            [ws.dataSource addObject:replyViewModel];
            [ws.homeImageDataSource addObject:homepageViewModel];
        }
        if (resultArray.count == 0) {
            ws.canRefreshFooter = NO;
        } else {
            ws.canRefreshFooter = YES;
        }
        [ws.collectionView.footer endRefreshing];
        [ws.collectionView reloadData];
    }];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"我的作品";
    _myWorkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    _myWorkView.backgroundColor = [UIColor colorWithHex:0xededed];
    cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) *padding6) / 3;
    self.view = _myWorkView;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = padding6;
    flowLayout.minimumLineSpacing = padding6;
    _collectionView = [[PWRefreshFooterCollectionView alloc] initWithFrame:CGRectInset(_myWorkView.frame, padding6, padding6) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_myWorkView addSubview:_collectionView];
    _collectionView.dataSource = nil;
    _collectionView.delegate = self;
    _collectionView.psDelegate = self;
    _cellIdentifier = @"MyWorkCell";
    [_collectionView registerClass:[ATOMMyWorkCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
    _canRefreshFooter = YES;
    _collectionView.emptyDataSetSource = self;
    [self getDataSource];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMMyWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    ATOMReplyViewModel *model = _dataSource[indexPath.row];
    [cell.workImageView setImageWithURL:[NSURL URLWithString:model.imageURL]placeholderImage:[UIImage imageNamed:@"placeholderImage_1"]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DDHotDetailVC *hdvc = [DDHotDetailVC new];
    hdvc.askVM = _homeImageDataSource[indexPath.row];
    hdvc.fold = 1;
    [self pushViewController:hdvc animated:YES];
}



#pragma mark - DZNEmptyDataSetSource & delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_cry"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"快去帮助众生PS,成为PS大神吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}




@end
