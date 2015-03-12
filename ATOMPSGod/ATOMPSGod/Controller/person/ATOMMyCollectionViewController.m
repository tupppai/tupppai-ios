//
//  ATOMMyCollectionViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyCollectionViewController.h"
#import "ATOMMyCollectionCollectionViewCell.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMOtherPersonViewController.h"

@interface ATOMMyCollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *myWorkView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *cellIdentifier;

@property (nonatomic, strong) UITapGestureRecognizer *tapMyCollectionGesture;

@end

@implementation ATOMMyCollectionViewController

static int padding6 = 6;
static float cellHeight;
static int collumnNumber = 2;
static float cellWidth;

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
    self.title = @"我的收藏";
    _myWorkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    cellWidth = (SCREEN_WIDTH - (collumnNumber - 1) *padding6) / collumnNumber;
    cellHeight = cellWidth + 50;
    self.view = _myWorkView;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =CGSizeMake(cellWidth, cellHeight);
    flowLayout.minimumInteritemSpacing = padding6;
    flowLayout.minimumLineSpacing = padding6;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(_myWorkView.frame, 0, 0) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor colorWithHex:0xededed];
    [_myWorkView addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _cellIdentifier = @"MyCollectionCell";
    [_collectionView registerClass:[ATOMMyCollectionCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
    _tapMyCollectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyCollectionGesture:)];
    [_collectionView addGestureRecognizer:_tapMyCollectionGesture];
}

#pragma mark - Gesture Event

- (void)tapMyCollectionGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:location];
    if (indexPath) {
        ATOMMyCollectionCollectionViewCell *cell = (ATOMMyCollectionCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.collectionImageView.frame, p)) {
            ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
            hdvc.pushType = ATOMMyCollectionType;
            [self pushViewController:hdvc animated:YES];
        } else if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        }
        
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATOMMyCollectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.collectionImage = _dataSource[indexPath.row];
    cell.userName = @"atom";
    return cell;
}

#pragma mark - UICollectionViewDelegate

@end
