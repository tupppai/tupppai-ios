//
//  ATOMMyUploadViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyUploadViewController.h"
#import "ATOMMyUploadCollectionViewCell.h"
#import "ATOMHotDetailViewController.h"

@interface ATOMMyUploadViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *myUploadView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *cellIdentifier;

@end

@implementation ATOMMyUploadViewController

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
    self.title = @"我的求P";
    _myUploadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    cellWidth = (SCREEN_WIDTH - (collumnNumber + 1) *padding6) / 3;
    self.view = _myUploadView;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = padding6;
    flowLayout.minimumLineSpacing = padding6;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(_myUploadView.frame, padding6, padding6) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_myUploadView addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _cellIdentifier = @"MyUploadCell";
    [_collectionView registerClass:[ATOMMyUploadCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMMyUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.workImage = _dataSource[indexPath.row];
    cell.praiseNumber = 10;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
    hdvc.pushType = ATOMMyUploadType;
    [self pushViewController:hdvc animated:YES];
}
















@end
