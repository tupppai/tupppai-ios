//
//  ATOMMyWorkViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyWorkViewController.h"
#import "ATOMMyWorkCollectionViewCell.h"
#import "ATOMHotDetailViewController.h"

@interface ATOMMyWorkViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *myWorkView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *cellIdentifier;

@end

@implementation ATOMMyWorkViewController

static int padding6 = 6;
static float cellWidth;
static float cellHeight = 150;
static int collumnNumber = 3;

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%d.jpg",i];
        UIImage *img = [UIImage imageNamed:imgName];
        [_dataSource addObject:img];
    }
}

- (void)createUI {
    self.title = @"我的作品";
    _myWorkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) *padding6) / 3;
    self.view = _myWorkView;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = padding6;
    flowLayout.minimumLineSpacing = padding6;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(_myWorkView.frame, padding6, padding6) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_myWorkView addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _cellIdentifier = @"MyWorkCell";
    [_collectionView registerClass:[ATOMMyWorkCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMMyWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.workImage = _dataSource[indexPath.row];
    cell.praiseNumber = 10;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
    hdvc.pushType = ATOMMyWorkType;
    [self pushViewController:hdvc animated:YES];
}




















@end
