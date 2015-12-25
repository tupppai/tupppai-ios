//
//  PIENewAskMakeUpViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/7.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENewAskMakeUpViewController.h"
#import "PIERefreshCollectionView.h"
#import "PIEPageManager.h"
#import "PIENewAskCollectionCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEShareView.h"
#import "PIECarouselViewController2.h"
#import "PIECommentViewController.h"
#import "PIEFriendViewController.h"
#import "PIEActionSheet_PS.h"
#import "AppDelegate.h"
#import "MRNavigationBarProgressView.h"
#import "PIEUploadManager.h"
#import "DDCollectManager.h"
#import "DDShareManager.h"
#import "PIEUploadVC.h"
#import "QBImagePickerController.h"
#import "POP.h"
#import "DeviceUtil.h"
#import "PIECellIconStatusChangedNotificationKey.h"
/* Variables */
@interface PIENewAskMakeUpViewController ()

@property (nonatomic, assign) BOOL                        isfirstLoadingAsk;
@property (nonatomic, strong) NSMutableArray              *sourceAsk;
@property (nonatomic, assign) NSInteger                   currentIndex_ask;
@property (nonatomic, assign) long long                   timeStamp_ask;
@property (nonatomic, assign) BOOL                        canRefreshFooter_ask;
@property (nonatomic, strong) PIERefreshCollectionView    *collectionView_ask;
@property (nonatomic, strong) PIEPageVM                   *selectedVM;
@property (nonatomic, strong) PIEShareView                *shareView;
@property (nonatomic, strong) PIEActionSheet_PS           *psActionSheet;
@property (nonatomic, strong) MRNavigationBarProgressView *progressView;
@property (nonatomic, strong) UIButton                    *takePhotoButton;
@property (nonatomic, strong) QBImagePickerController     *QBImagePickerController;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) MASConstraint               *takePhotoButtonBottomConstraint;

@end


/* Protocols */
@interface PIENewAskMakeUpViewController (CollectionView)
<UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>
@end
@interface PIENewAskMakeUpViewController () <QBImagePickerControllerDelegate>
@end
@interface PIENewAskMakeUpViewController (DZNEmptyDataSet)
<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@end

@interface PIENewAskMakeUpViewController (PWRefreshBaseCollectionView)
<PWRefreshBaseCollectionViewDelegate>
@end

@interface PIENewAskMakeUpViewController (ShareView)
<PIEShareViewDelegate>
@end

@implementation PIENewAskMakeUpViewController

static NSString *CellIdentifier2 = @"PIENewAskCollectionCell";

#pragma mark - UI life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.channelVM.title;
    [self.view addSubview: self.collectionView_ask];
//    self.collectionView_ask.backgroundColor = [UIColor whiteColor];
    
    [self setupGestures];
    [self setupData];
    
    [self setupNotificationObserver];
    
    [self firstGetSourceIfEmpty_ask];
    [self configureTakePhotoButton];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.hidesBarsOnSwipe = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
    self.navigationController.navigationBarHidden = NO;
}
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PIESharedIconStatusChangedNotification
                                                  object:nil];
}
#pragma mark - property first initiation
- (void) setupData {
    //set this before firstGetRemoteSource

    _canRefreshFooter_ask = YES;
    
    _isfirstLoadingAsk    = YES;

    _sourceAsk            = [NSMutableArray new];

    _currentIndex_ask     = 1;

}

#pragma mark - Notification Observer setup
- (void)setupNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateShareStatus)
                                                 name:PIESharedIconStatusChangedNotification
                                               object:nil];
}

#pragma mark - UI components setup

- (void)setupCollectionView_ask {
    
}


- (void)configureTakePhotoButton
{
    // --- added as subViews
    [self.view addSubview:self.takePhotoButton];
    
    // --- Autolayout constraints
    __weak typeof(self) weakSelf = self;
    [_takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
        self.takePhotoButtonBottomConstraint =
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-12);
    }];
    
    if (_channelVM) {
        self.takePhotoButton.hidden = YES;
    }
}


#pragma mark - Get DataSource from Server for the first time
- (void)firstGetSourceIfEmpty_ask {
    if (_sourceAsk.count <= 0 || _isfirstLoadingAsk) {
        [self.collectionView_ask.mj_header beginRefreshing];
    }
}

#pragma mark - Fetch data Ask
//获取服务器的最新数据
- (void)getRemoteAskSource:(void (^)(BOOL finished))block{
    
    
    [self.collectionView_ask.mj_footer endRefreshing];
    _currentIndex_ask = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    _timeStamp_ask = [[NSDate date] timeIntervalSince1970];
    
    /**
     *  参数：传递上次更新的时间
     *
     *  @param _timeStamp_ask 上次更新的时间 (NSDate now)
     */
    [param setObject:@(_timeStamp_ask) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    
    if (_channelVM) {
        [param setObject:@(_channelVM.ID) forKey:@"category_id"];
    }
    
    
    PIEPageManager *pageManager = [PIEPageManager new];
    
    __weak typeof(self) weakSelf = self;
    [pageManager pullAskSource:param block:^(NSMutableArray *homepageArray) {
        weakSelf.isfirstLoadingAsk = NO;
        if (homepageArray.count) {
            weakSelf.sourceAsk = homepageArray;
            _canRefreshFooter_ask = YES;
        }
        else {
            _canRefreshFooter_ask = NO;
        }
        
        [weakSelf.collectionView_ask reloadData];
        [weakSelf.collectionView_ask.mj_header endRefreshing];
        
        // ???
        if (block) {
            block(YES);
        }
    }];
}

//拉至底层刷新
- (void)getMoreRemoteAskSource {

    __weak typeof(self) weakSelf = self;
 
    [weakSelf.collectionView_ask.mj_header endRefreshing];
    _currentIndex_ask++;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_timeStamp_ask) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(_currentIndex_ask) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    
    if (_channelVM) {
        [param setObject:@(_channelVM.ID) forKey:@"category_id"];
    }
    
    PIEPageManager *pageManager = [PIEPageManager new];
    
    [pageManager pullAskSource:param block:^(NSMutableArray *homepageArray) {
        if (homepageArray.count) {
            [weakSelf.sourceAsk addObjectsFromArray:homepageArray];
            _canRefreshFooter_ask = YES;
        }
        else {
            _canRefreshFooter_ask = NO;
        }
        [weakSelf.collectionView_ask reloadData];
        [weakSelf.collectionView_ask.mj_footer endRefreshing];
    }];
}

#pragma mark - Refresh methods (Header & Footer)
- (void)loadNewData_ask {
    [self getRemoteAskSource:nil];
}

- (void)loadMoreData_ask {
    if (_canRefreshFooter_ask && !_collectionView_ask.mj_header.isRefreshing) {
        [self getMoreRemoteAskSource];
    } else {
        [_collectionView_ask.mj_footer endRefreshing];
    }
}



#pragma mark - <PWRefreshBaseCollectionViewDelegate>
-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
    [self loadNewData_ask];
}

-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    [self loadMoreData_ask];
}

#pragma mark - <UICollectionViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         [self.takePhotoButtonBottomConstraint setOffset:50.0];
                         [self.view layoutIfNeeded];
                     }];
    
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        [self.takePhotoButtonBottomConstraint setOffset:-12];
        [UIView animateWithDuration:0.6
                              delay:1.0
             usingSpringWithDamping:0.3
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             [self.view layoutIfNeeded];

                         } completion:^(BOOL finished) {
                         }];
        
}



#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceAsk.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PIENewAskCollectionCell *cell =
    (PIENewAskCollectionCell *)
    [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier2
                                              forIndexPath:indexPath];
    
    
    [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - <CHTCollectionViewDelegateWaterfallLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEPageVM* vm = [_sourceAsk objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width         = (SCREEN_WIDTH - 20) / 2.0;
    height        = vm.imageHeight/vm.imageWidth * width + 129 + (29+20);
    height        = MAX(200,height);
    height        = MIN(SCREEN_HEIGHT/1.5, height);
    return CGSizeMake(width, height);
}


#pragma mark - Gesture Event

- (void)setupGestures {
    UITapGestureRecognizer* tapGestureAsk = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnAsk:)];
    UILongPressGestureRecognizer* longPressGestureAsk = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnAsk:)];
    
    [_collectionView_ask addGestureRecognizer:tapGestureAsk];
    [_collectionView_ask addGestureRecognizer:longPressGestureAsk];
}


- (void)longPressOnAsk:(UILongPressGestureRecognizer *)gesture {

    CGPoint location = [gesture locationInView:_collectionView_ask];
    NSIndexPath *indexPath = [_collectionView_ask indexPathForItemAtPoint:location];
    _selectedIndexPath = indexPath;
    if (indexPath) {
        PIENewAskCollectionCell* cell= (PIENewAskCollectionCell *)[_collectionView_ask cellForItemAtIndexPath:indexPath];
        _selectedVM = _sourceAsk[indexPath.row];
        CGPoint p = [gesture locationInView:cell];
        //点击大图
        if (CGRectContainsPoint(cell.leftImageView.frame, p) || CGRectContainsPoint(cell.rightImageView.frame, p)) {
            [self showShareView:_selectedVM];
        }
    }
    
}

- (void)tapOnAsk:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_collectionView_ask];
    NSIndexPath *indexPath = [_collectionView_ask indexPathForItemAtPoint:location];
    _selectedIndexPath = indexPath;
    if (indexPath) {
        PIENewAskCollectionCell*  cell = (PIENewAskCollectionCell *)[_collectionView_ask cellForItemAtIndexPath:indexPath];
        _selectedVM                    = _sourceAsk[indexPath.row];
        CGPoint p                      = [gesture locationInView:cell];
        
        //点击大图
        if (CGRectContainsPoint(cell.leftImageView.frame, p) || CGRectContainsPoint(cell.rightImageView.frame, p)) {
            
            /* 
             （需求补充）点击随意求P后，不论用户的求P是一张还是两张，统一先进入PIECarousel_ItemView（多图详情页，横着滚的），
             然后上拉进入PIECommentViewController（单图详情页，竖着滚的） 
            */
//            
//            if (![_selectedVM.replyCount isEqualToString:@"0"]) {
//                PIECarouselViewController2* vc = [PIECarouselViewController2 new];
//                vc.pageVM                      = _selectedVM;
//                [self presentViewController:vc animated:NO completion:nil];
//            } else {
//                PIECommentViewController* vc = [PIECommentViewController new];
//                vc.vm                        = _selectedVM;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
            
            PIECarouselViewController2 *vc = [PIECarouselViewController2 new];
            vc.pageVM = _selectedVM;
            [self presentViewController:vc animated:NO completion:nil];
        }
        //点击头像
        else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
            PIEFriendViewController * friendVC = [PIEFriendViewController new];
            friendVC.pageVM = _selectedVM;
            [self.navigationController pushViewController:friendVC animated:YES];
        }
        
        //点击用户名
        else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
            PIEFriendViewController * friendVC = [PIEFriendViewController new];
            friendVC.pageVM = _selectedVM;
            [self.navigationController pushViewController:friendVC animated:YES];
        }
        //点击帮p
        else if (CGRectContainsPoint(cell.bangView.frame, p)) {
            self.psActionSheet.vm = _selectedVM;
            [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
        }
    }
}

#pragma mark - Notification methods


- (void)refreshHeader {
    if (_collectionView_ask.mj_header.isRefreshing == false) {
        [_collectionView_ask.mj_header beginRefreshing];
    }
}




#pragma mark - <PIEShareViewDelegate>

- (void)shareViewDidShare:(PIEShareView *)shareView socialShareType:(ATOMShareType)shareType
{
   // refresh ui element on main thread after successful sharing, do nothing otherwise.
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self updateShareStatus];
//    }];
    
}


- (void)shareViewDidCancel:(PIEShareView *)shareView
{
    [shareView dismiss];
}

#pragma mark - 分享页面的收藏按钮操作
- (void)showShareView :(PIEPageVM *)pageVM{
    [self.shareView show:pageVM];
    
}

#pragma mark - Notification Methods
/**
 *  用户点击了updateShareStatus之后（在弹出的窗口完成分享，点赞），刷新本页面ReplyCell的分享数
 */
- (void)updateShareStatus {
    /*
     _vm.shareCount ++ 这个副作用集中发生在PIEShareView之中。
     
     */
    
    //    _selectedVM.shareCount =
    //    [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue] +1];
    //    [self updateStatus];
    if (_selectedIndexPath) {
        [_collectionView_ask reloadItemsAtIndexPaths:@[_selectedIndexPath]];
    }
}


#pragma mark - Target-actions
- (void)takePhoto {
    [self presentViewController:self.QBImagePickerController animated:YES completion:nil];
}
#pragma qb_imagePickerController delegate
-(void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    PIEUploadVC* vc = [PIEUploadVC new];
    vc.assetsArray = assets;
    [imagePickerController.albumsNavigationController pushViewController:vc animated:YES];
}


-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self.QBImagePickerController.selectedAssetURLs removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - Lazy loadings
-(PIERefreshCollectionView *)collectionView_ask {
    if (_collectionView_ask == nil) {
        // instantiate only for once
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
        layout.minimumColumnSpacing = 8;
        layout.minimumInteritemSpacing = 10;
        
        
        _collectionView_ask = [[PIERefreshCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView_ask.psDelegate           = self;

        UINib* nib = [UINib nibWithNibName:CellIdentifier2 bundle:nil];
        [_collectionView_ask registerNib:nib forCellWithReuseIdentifier:CellIdentifier2];

        _collectionView_ask.dataSource           = self;
        _collectionView_ask.delegate             = self;
        _collectionView_ask.emptyDataSetDelegate = self;
        _collectionView_ask.emptyDataSetSource   = self;
        _collectionView_ask.backgroundColor = [UIColor whiteColor];
        _collectionView_ask.toRefreshBottom              = YES;
        _collectionView_ask.toRefreshTop                 = YES;
        _collectionView_ask.autoresizingMask             = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView_ask.showsVerticalScrollIndicator = NO;
        _collectionView_ask.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
    }
    return _collectionView_ask;

}

- (PIEActionSheet_PS *)psActionSheet {
    if (!_psActionSheet) {
        _psActionSheet = [PIEActionSheet_PS new];
    }
    return _psActionSheet;
}
- (UIButton *)takePhotoButton
{
    if (_takePhotoButton == nil) {
        // instantiate only for once
        _takePhotoButton = [[UIButton alloc] init];
        
        /* Configurations */
        
        // --- set background image
        [_takePhotoButton setBackgroundImage:[UIImage imageNamed:@"pie_channelDetailTakePhotoButton"]
                                    forState:UIControlStateNormal];
        
        // --- add drop shadows
        _takePhotoButton.layer.shadowColor  = (__bridge CGColorRef _Nullable)
        ([UIColor colorWithWhite:0.0 alpha:0.5]);
        _takePhotoButton.layer.shadowOffset = CGSizeMake(0, 4);
        _takePhotoButton.layer.shadowRadius = 8.0;
        
        // --- add target-actions
        [_takePhotoButton addTarget:self
                             action:@selector(takePhoto)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoButton;
    
}


- (QBImagePickerController* )QBImagePickerController {
    if (!_QBImagePickerController) {
        _QBImagePickerController = [QBImagePickerController new];
        _QBImagePickerController.delegate = self;
        _QBImagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        _QBImagePickerController.allowsMultipleSelection = YES;
        _QBImagePickerController.showsNumberOfSelectedAssets = YES;
        _QBImagePickerController.minimumNumberOfSelection = 1;
        _QBImagePickerController.maximumNumberOfSelection = 2;
        //        _QBImagePickerController.prompt = @"选择你要上传的图片";
    }
    return _QBImagePickerController;
}


-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}



@end
