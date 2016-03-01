//
//  PIENewReplyViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/7.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENewReplyViewController.h"
#import "PIERefreshTableView.h"
#import "PIEPageManager.h"
#import "MRNavigationBarProgressView.h"
#import "DDService.h"
#import "PIEUploadManager.h"
//#import "PIECarouselViewController2.h"

#import "PIEFriendViewController.h"
#import "PIECommentViewController.h"
#import "PIEShareView.h"
#import "PIEReplyCollectionViewController.h"
#import "DDCollectManager.h"
#import "DDNavigationController.h"
#import "PIEToHelpViewController.h"
#import "LeesinViewController.h"
#import "PIEEliteReplyTableViewCell.h"
#import "PIEPageDetailViewController.h"

/* Variables */
@interface PIENewReplyViewController ()<LeesinViewControllerDelegate>

@property (nonatomic, assign) BOOL isfirstLoadingReply;

@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *sourceReply;

@property (nonatomic, assign) NSInteger currentIndex_reply;

@property (nonatomic, assign)  long long timeStamp_reply;

@property (nonatomic, assign) BOOL canRefreshFooter_reply;

@property (nonatomic, strong) PIERefreshTableView *tableViewReply;

@property (nonatomic, strong)  MRNavigationBarProgressView* progressView;

@property (nonatomic, weak) PIERefreshTableView *tableViewActivity;

@property (nonatomic, strong) PIEShareView *shareView;

@property (nonatomic, strong) UIButton                      *takePhotoButton;

@property (nonatomic, strong) MASConstraint *takePhotoButtonBottomMarginConstraint;

@end

/* Protocols */
@interface PIENewReplyViewController (SharingDelegate)
<PIEShareViewDelegate>
@end

@interface PIENewReplyViewController (TableView)
<UITableViewDelegate, UITableViewDataSource>
@end

@interface PIENewReplyViewController (PWRefreshBaseTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIENewReplyViewController (DZNEmptyDataSet)
<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@end

@implementation PIENewReplyViewController

static  NSString *PIEEliteReplyCellIdentifier = @"PIEEliteReplyTableViewCell";

#pragma mark -
#pragma mark UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最新作品";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableViewReply ];
    [self configureTakePhotoButton];
    [self setupData];
    [self firstGetSourceIfEmpty_Reply];
}

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupProgressView];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.hidesBarsOnSwipe = NO;
//    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leesinViewController:(LeesinViewController *)leesinViewController uploadPercentage:(CGFloat)percentage uploadSucceed:(BOOL)success {
    [self.progressView setProgress:percentage animated:YES];
    if  (success) {
        [self getRemoteReplySource];
        [self.tableViewReply scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

#pragma mark - property first initiation
- (void) setupData {
    //set this before firstGetRemoteSource
    _canRefreshFooter_reply = YES;

    _isfirstLoadingReply    = YES;

    _currentIndex_reply     = 1;

    _sourceReply            = [NSMutableArray<PIEPageVM *> new];
}


- (void)configureTakePhotoButton
{
    [self.view addSubview:self.takePhotoButton];
    __weak typeof(self) weakSelf = self;
    
    [_takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.leading.and.trailing.equalTo(self.view);
        self.takePhotoButtonBottomMarginConstraint =
        make.bottom.equalTo(weakSelf.view);
    }];
}
- (void)setupProgressView {
    _progressView = [MRNavigationBarProgressView progressViewForNavigationController:self.navigationController];
    _progressView.progressTintColor = [UIColor colorWithHex:0x4a4a4a andAlpha:0.93];
}

- (void)refreshHeader {
    if (!_tableViewReply.mj_header.isRefreshing) {
        [_tableViewReply.mj_header beginRefreshing];
    }
}
- (void)takePhoto {
    
    if ([DDUserManager currentUser].uid == kPIETouristUID) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PIENetworkCallForFurtherRegistrationNotification object:nil];
        
    }else{
        LeesinViewController* vc = [LeesinViewController new];
        vc.type = LeesinViewControllerTypeReply;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    
}

#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         [self.takePhotoButtonBottomMarginConstraint setOffset:50.0];
                         [self.takePhotoButton layoutIfNeeded];
                     }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.takePhotoButtonBottomMarginConstraint setOffset:0];
    [UIView animateWithDuration:0.2
                          delay:2.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.takePhotoButton layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                     }];
    
    
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableViewReply == tableView) {
        return _sourceReply.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PIEEliteReplyTableViewCell *replyCell =
    [tableView dequeueReusableCellWithIdentifier:PIEEliteReplyCellIdentifier];
    
    PIEPageVM *viewModel = _sourceReply[indexPath.row];
    
    [replyCell bindVM:viewModel];
    
    if (viewModel.askID == 0) {
        // 类型三： 动态（像朋友圈那样，只是发一张图片而已）
        [replyCell setAllWorkButtonHidden:YES];
    }else{
        // 类型二：帮P
        [replyCell setAllWorkButtonHidden:NO];
    }
    
    // begin RAC binding
    @weakify(self);
    
    [replyCell.tapOnUserSignal
     subscribeNext:^(id x) {
         @strongify(self);
         [self tapOnAvatarOrUsernameAtIndexPath:indexPath];
     }];
    
    [replyCell.tapOnFollowButtonSignal
     subscribeNext:^(UITapGestureRecognizer *tap) {
         @strongify(self);
         [self tapOnFollowViewAtIndexPath:indexPath];
         
         tap.view.hidden = YES;
     }];
    
    [replyCell.tapOnImageSignal
     subscribeNext:^(id x) {
         @strongify(self);
         [self tapOnImageViewAtIndexPath:indexPath];
     }];
    
    [replyCell.longPressOnImageSignal
     subscribeNext:^(id x) {
         @strongify(self);
         [self longPressOnImageViewAtIndexPath:indexPath];
     }];
    
    [replyCell.tapOnCommentSignal
     subscribeNext:^(id x) {
         @strongify(self);
         [self tapOnCommentViewAtIndexPath:indexPath];
     }];
    
    [replyCell.tapOnShareSignal
     subscribeNext:^(id x) {
         @strongify(self);
         [self tapOnShareViewAtIndexPath:indexPath];
     }];
    
    [replyCell.tapOnLoveSignal
     subscribeNext:^(id x) {
         @strongify(self);
         [self tapOnLikeViewAtIndexPath:indexPath];
     }];
    
    [replyCell.longPressOnLoveSignal
     subscribeNext:^(id x) {
         @strongify(self);
         [self longPressOnLikeViewAtIndexPath:indexPath];
     }];
    
    [replyCell.tapOnRelatedWorkSignal
     subscribeNext:^(id x) {
         @strongify(self);
         [self tapOnAllWorkAtIndexPath:indexPath];
     }];
    
    // --- end of RAC binding
    
    return replyCell;
}

#pragma mark - Fetch Data from Server

/**
 *  假如model（_source）为空的话，那就重新fetch data
 */
- (void)firstGetSourceIfEmpty_Reply {
    if (_sourceReply.count <= 0 || _isfirstLoadingReply) {
        [self.tableViewReply.mj_header beginRefreshing];
    }
}
- (void)getRemoteReplySource {
    WS(ws);
    _currentIndex_reply = 1;
    [_tableViewReply.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary new];
    _timeStamp_reply = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_timeStamp_reply) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];

    
    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullReplySource:param block:^(NSMutableArray *array) {
        ws.isfirstLoadingReply = NO;
        if (array.count) {
            ws.sourceReply = array;
            _canRefreshFooter_reply = YES;
        }
        else {
            _canRefreshFooter_reply = NO;
        }
        [ws.tableViewReply reloadData];
        [ws.tableViewReply.mj_header endRefreshing];
    }];
}


- (void)getMoreRemoteReplySource {
    WS(ws);
    _currentIndex_reply ++;
    [_tableViewReply.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_timeStamp_reply) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    [param setObject:@(_currentIndex_reply) forKey:@"page"];
    
    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullReplySource:param block:^(NSMutableArray *array) {
        if (array.count < 15) {
            _canRefreshFooter_reply = NO;
        }
        else {
            _canRefreshFooter_reply = YES;
        }
        [ws.sourceReply addObjectsFromArray:array] ;
        [ws.tableViewReply reloadData];
        [ws.tableViewReply.mj_footer endRefreshing];
    }];
}


#pragma mark - Refresh

- (void)loadNewData_reply {
    [self getRemoteReplySource];
}

- (void)loadMoreData_reply {
    if (_canRefreshFooter_reply && !_tableViewReply.mj_header.isRefreshing) {
        [self getMoreRemoteReplySource];
    } else {
        [Hud text:@"已经拉到底啦"];
        [_tableViewReply.mj_footer endRefreshing];
    }
}

#pragma mark - <PWRefreshBaseTableViewDelegate>

-(void)didPullRefreshDown:(UITableView *)tableView{
    [self loadNewData_reply];
}

-(void)didPullRefreshUp:(UITableView *)tableView {
    [self loadMoreData_reply];
}

#pragma mark - RAC response actions
- (void)tapOnAvatarOrUsernameAtIndexPath:(NSIndexPath *)indexPath
{
    PIEFriendViewController *friendVC = [PIEFriendViewController new];
    friendVC.pageVM = _sourceReply[indexPath.row];
    [self.navigationController pushViewController:friendVC animated:YES];
}

- (void)tapOnFollowViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceReply[indexPath.row];
    [selectedVM follow];
}

- (void)tapOnImageViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceReply[indexPath.row];
//    PIECarouselViewController2 *carouselVC = [PIECarouselViewController2 new];
//    carouselVC.pageVM = selectedVM;
    
    PIEPageDetailViewController *pageDetailVC =
    [PIEPageDetailViewController new];
    pageDetailVC.pageViewModel = selectedVM;
    
    DDNavigationController *navigationController =
    [[DDNavigationController alloc] initWithRootViewController:pageDetailVC];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)longPressOnImageViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEShareView *shareView = [PIEShareView new];
    PIEPageVM *selectedVM = _sourceReply[indexPath.row];
    [shareView show:selectedVM];
}

- (void)tapOnAllWorkAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceReply[indexPath.row];
    PIEReplyCollectionViewController *replyCollectionVC =
    [PIEReplyCollectionViewController new];
    replyCollectionVC.pageVM = selectedVM;
    [self.navigationController pushViewController:replyCollectionVC animated:YES];
}

- (void)tapOnShareViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceReply[indexPath.row];
    [self.shareView show:selectedVM];
    
}

- (void)tapOnCommentViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIECommentViewController *commentVC = [PIECommentViewController new];
    commentVC.vm = _sourceReply[indexPath.row];
    commentVC.shouldShowHeaderView = NO;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)tapOnLikeViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceReply[indexPath.row];
    [selectedVM love:NO];
}

- (void)longPressOnLikeViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceReply[indexPath.row];
    [selectedVM love:YES];
}

#pragma mark - lazy loadings
-(PIERefreshTableView *)tableViewReply {
    if (_tableViewReply == nil) {
        _tableViewReply = [[PIERefreshTableView alloc] initWithFrame:self.view.bounds];
        _tableViewReply.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableViewReply.backgroundColor = [UIColor whiteColor];
        _tableViewReply.showsVerticalScrollIndicator = NO;
        
        _tableViewReply.delegate             = self;
        _tableViewReply.dataSource           = self;
        _tableViewReply.psDelegate           = self;
        _tableViewReply.emptyDataSetSource   = self;
        _tableViewReply.emptyDataSetDelegate = self;
        _tableViewReply.estimatedRowHeight = SCREEN_WIDTH+145;
        _tableViewReply.rowHeight          = UITableViewAutomaticDimension;
        
        UINib *replyCellNib =
        [UINib nibWithNibName:@"PIEEliteReplyTableViewCell" bundle:nil];
        [_tableViewReply registerNib:replyCellNib forCellReuseIdentifier:PIEEliteReplyCellIdentifier];
        
        _tableViewReply.estimatedRowHeight = SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT;
        _tableViewReply.scrollsToTop       = YES;
        
    }
    return _tableViewReply;
}

- (UIButton *)takePhotoButton
{
    if (_takePhotoButton == nil) {
        _takePhotoButton = [[UIButton alloc] init];
        [_takePhotoButton setTitle:@"上传作品" forState:UIControlStateNormal];
        [_takePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_takePhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _takePhotoButton.titleLabel.font = [UIFont mediumTupaiFontOfSize:14];
        _takePhotoButton.backgroundColor = [UIColor colorWithHex:0xffef00 andAlpha:0.93];
        // --- add drop shadows
        _takePhotoButton.layer.shadowColor  = (__bridge CGColorRef _Nullable)
        ([UIColor colorWithWhite:0.0 alpha:0.5]);
        _takePhotoButton.layer.shadowOffset = CGSizeMake(0, 4);
        _takePhotoButton.layer.shadowRadius = 8.0;
        [_takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoButton;
    
}


-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView          = [PIEShareView new];
//        _shareView.delegate = self;
    }
    return _shareView;
}

@end
