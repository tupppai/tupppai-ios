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

@interface ATOMOtherPersonViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ATOMOtherPersonView *otherPersonView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *UploadCellIdentifier;
@property (nonatomic, strong) NSString *WorkCellIdentifier;

@property (nonatomic, strong) UITapGestureRecognizer *tapFansGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapConcernGesture;

@end

@implementation ATOMOtherPersonViewController

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
    _UploadCellIdentifier = @"OtherPersonUploadCell";
    _WorkCellIdentifier = @"OtherPersonWorkCell";
    [_otherPersonView.otherPersonUploadCollectionView registerClass:[ATOMMyUploadCollectionViewCell class] forCellWithReuseIdentifier:_UploadCellIdentifier];
    [_otherPersonView.otherPersonWorkCollectionView registerClass:[ATOMMyWorkCollectionViewCell class] forCellWithReuseIdentifier:_WorkCellIdentifier];
    [_otherPersonView.otherPersonUploadButton addTarget:self action:@selector(clickOtherPersonUploadButton:) forControlEvents:UIControlEventTouchUpInside];
    [_otherPersonView.otherPersonWorkButton addTarget:self action:@selector(clickOtherPersonWorkButton:) forControlEvents:UIControlEventTouchUpInside];
    [_otherPersonView changeBottomViewToUploadView];
    
    _tapConcernGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConcernGesture:)];
    [_otherPersonView.attentionLabel addGestureRecognizer:_tapConcernGesture];
    
    _tapFansGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFansGesture:)];
    [_otherPersonView.fansLabel addGestureRecognizer:_tapFansGesture];
}

#pragma mark - Click Event

- (void)clickOtherPersonUploadButton:(UIButton *)sender {
    [_otherPersonView changeBottomViewToUploadView];
}

- (void)clickOtherPersonWorkButton:(UIButton *)sender {
    [_otherPersonView changeBottomViewToWorkView];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _otherPersonView.otherPersonUploadCollectionView) {
        ATOMMyUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_UploadCellIdentifier forIndexPath:indexPath];
        cell.workImage = _dataSource[indexPath.row];
        cell.praiseNumber = 10;
        return cell;
    } else {
        ATOMMyWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_WorkCellIdentifier forIndexPath:indexPath];
        cell.workImage = _dataSource[indexPath.row];
        cell.praiseNumber = 10;
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
