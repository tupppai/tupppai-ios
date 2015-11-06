//
//  PIEFriendAskViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendReplyViewController.h"
#import "DDOtherUserManager.h"
#import "PIEFriendReplyCollectionViewCell.h"
#import "PIERefreshCollectionView.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIECarouselViewController.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
@interface PIEFriendReplyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,PWRefreshBaseCollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) PIERefreshCollectionView *collectionView;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) BOOL isfirstLoading;
@property (nonatomic, assign)  long long timeStamp;

@end
static NSString *CellIdentifier = @"PIEFriendReplyCollectionViewCell";

@implementation PIEFriendReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [self getRemoteSource];
}

- (void)commonInit {
    self.view.backgroundColor = [UIColor clearColor];
    _source = [NSMutableArray array];
    _currentIndex = 1;
    _isfirstLoading = YES;
    
    [self.view addSubview: self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];

}

#pragma mark - GetDataSource
- (void)getRemoteSource {
    [_collectionView.footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(1) forKey:@"page"];
    _currentIndex = 1;
    [DDOtherUserManager getFriendReply:param withBlock:^(NSMutableArray *returnArray) {
        _isfirstLoading = NO;//should set to NO before reloadData
        NSMutableArray* arrayAgent = [NSMutableArray array];
        if (returnArray.count) {
            _canRefreshFooter = YES;
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                NSLog(@"NAME %@",vm.username);
                [arrayAgent addObject:vm];
            }
            [_source removeAllObjects];
            [_source addObjectsFromArray:arrayAgent];
        }
        else {
            _canRefreshFooter = NO;
        }
        [_collectionView.header endRefreshing];
        [_collectionView reloadData];
    }];
}
- (void)getMoreRemoteSource {
    _currentIndex ++;
    [_collectionView.header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:@(_currentIndex) forKey:@"page"];
    [DDOtherUserManager getFriendReply:param withBlock:^(NSMutableArray *returnArray) {
        NSMutableArray* arrayAgent = [NSMutableArray array];
        if (returnArray.count) {
            _canRefreshFooter = YES;
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [arrayAgent addObject:vm];
            }
            [_source addObjectsFromArray:arrayAgent];
        }
        else {
            _canRefreshFooter = NO;
        }
        [_collectionView.footer endRefreshing];
        [_collectionView reloadData];
    }];
}

-(PIERefreshCollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
        layout.minimumColumnSpacing = 8;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[PIERefreshCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.toRefreshBottom = YES;
        _collectionView.toRefreshTop = YES;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.psDelegate = self;
//        [_collectionView registerClass:[PIEFriendReplyCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier2];
        UINib* nib = [UINib nibWithNibName:@"PIEFriendReplyCollectionViewCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    }
    return _collectionView;
}

#pragma mark - Refresh

-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
    [self getRemoteSource];
}
-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    if (_canRefreshFooter && !_collectionView.header.isRefreshing) {
        [self getMoreRemoteSource];
    } else {
        [_collectionView.footer endRefreshing];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _source.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PIEFriendReplyCollectionViewCell*cell =
    (PIEFriendReplyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIEFriendReplyCollectionViewCell"
                                                                      forIndexPath:indexPath];
//    if (!cell) {
//        //need this if instantiate from class instead of xib.
//        cell = [PIEFriendReplyCollectionViewCell new];
//    }
    [cell injectSource:[_source objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDPageVM* vm = [_source objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width = (SCREEN_WIDTH) /2 - 20;
    height = vm.imageHeight/vm.imageWidth * width;
    height = MAX(80, height);
    height = MIN(SCREEN_HEIGHT/2, height);
    return CGSizeMake(width, height);

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat startContentOffsetY = scrollView.contentOffset.y;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (startContentOffsetY > scrollView.contentOffset.y ) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PIEFriendScrollDown" object:nil];
        }
        else if (startContentOffsetY < scrollView.contentOffset.y)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PIEFriendScrollUp" object:nil];
        }
    });
}
#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"他还没有观众所期待的作品";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DDPageVM* vm = [_source objectAtIndex:indexPath.row];
    PIECarouselViewController* vc = [PIECarouselViewController new];
    vc.pageVM = vm;
    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES ];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !_isfirstLoading;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
@end
