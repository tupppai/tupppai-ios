//
//  PIEFriendAskViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendAskViewController.h"
#import "DDOtherUserManager.h"
#import "PIEAskCollectionCell.h"
#import "PIERefreshCollectionView.h"
#import "CHTCollectionViewWaterfallLayout.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface PIEFriendAskViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,PWRefreshBaseCollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) PIERefreshCollectionView *collectionView;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, strong) DDPageVM *selectedVM;

@end
static NSString *CellIdentifier2 = @"PIEAskCollectionCell";

@implementation PIEFriendAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _source = [NSMutableArray array];
    [self getRemoteSource];
    [self commonInit];
}

- (void)commonInit {
    self.view.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.collectionView];
    self.view = self.collectionView;
    _currentIndex = 1;
    
//    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//    [_collectionView addGestureRecognizer:_tapGesture];
}

#pragma mark - GetDataSource
- (void)getRemoteSource {
    [_collectionView.footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(1) forKey:@"page"];
    _currentIndex = 1;
    [DDOtherUserManager getFriendAsk:param withBlock:^(NSMutableArray *returnArray) {
        NSMutableArray* arrayAgent = [NSMutableArray array];
        if (returnArray.count > 0) {
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [arrayAgent addObject:vm];
            }
            [_source removeAllObjects];
            [_source addObjectsFromArray:arrayAgent];
        }
        [_collectionView.header endRefreshing];
        [_collectionView reloadData];
    }];
}
- (void)getMoreRemoteSource {
    _currentIndex ++;
    [_collectionView.header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(_currentIndex) forKey:@"page"];
    [DDOtherUserManager getFriendAsk:param withBlock:^(NSMutableArray *returnArray) {
        NSMutableArray* arrayAgent = [NSMutableArray array];
        if (returnArray.count > 0) {
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [arrayAgent addObject:vm];
            }
            [_source addObjectsFromArray:arrayAgent];
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
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.psDelegate = self;
        UINib* nib = [UINib nibWithNibName:@"PIEAskCollectionCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier2];
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
    PIEAskCollectionCell*cell =
    (PIEAskCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier2
                                                                      forIndexPath:indexPath];
    [cell injectSource:[_source objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDPageVM* vm =   [_source objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width = (SCREEN_WIDTH - 20) / 2.0;
    height = vm.imageHeight + 135;
    if (height > (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3) {
        height = (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3;
    }
    return CGSizeMake(width, height);
}

@end
