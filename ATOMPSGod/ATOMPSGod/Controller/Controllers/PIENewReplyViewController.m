//
//  PIENewReplyViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/7.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENewReplyViewController.h"
#import "PIERefreshTableView.h"
#import "PIENewReplyTableCell.h"
#import "PIEPageManager.h"
#import "MRNavigationBarProgressView.h"
#import "DDService.h"
#import "PIEUploadManager.h"
#import "PIECarouselViewController2.h"
#import "PIEFriendViewController.h"
#import "PIECommentViewController.h"
#import "PIEShareView.h"
#import "PIEReplyCollectionViewController.h"
#import "DDCollectManager.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
#import "PIEToHelpViewController.h"
/* Variables */
@interface PIENewReplyViewController ()

@property (nonatomic, assign) BOOL isfirstLoadingReply;

@property (nonatomic, strong) NSMutableArray *sourceReply;

@property (nonatomic, assign) NSInteger currentIndex_reply;

@property (nonatomic, assign)  long long timeStamp_reply;

@property (nonatomic, assign) BOOL canRefreshFooter_reply;

@property (nonatomic, strong) PIERefreshTableView *tableViewReply;

@property (nonatomic, strong) PIENewReplyTableCell *selectedReplyCell;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong)  MRNavigationBarProgressView* progressView;

@property (nonatomic, weak) PIERefreshTableView *tableViewActivity;

@property (nonatomic, strong) PIEPageVM *selectedVM;

@property (nonatomic, strong) PIEShareView *shareView;

@property (nonatomic, strong) UIButton                      *takePhotoButton;

@property (nonatomic, strong) MASConstraint *takePhotoButtonConstraint;

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

// =================================================================
@implementation PIENewReplyViewController

static NSString *CellIdentifier = @"PIENewReplyTableCell";


#pragma mark - 
#pragma mark UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最新作品";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableViewReply ];
    [self configureTakePhotoButton];
    [self setupGestures];
    [self setupData];
    
    /**
     *  假如model（_source）为空的话，那就重新fetch data
     */
    [self firstGetSourceIfEmpty_Reply];
}

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.hidesBarsOnSwipe = YES;
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - property first initiation
- (void) setupData {
    //set this before firstGetRemoteSource
    _canRefreshFooter_reply = YES;

    _isfirstLoadingReply    = YES;

    _currentIndex_reply     = 1;

    _sourceReply            = [NSMutableArray new];
}

#pragma mark - Notification methods


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
        self.takePhotoButtonConstraint =
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-64);
    }];
}

- (void)refreshHeader {
    if (!_tableViewReply.mj_header.isRefreshing) {
        [_tableViewReply.mj_header beginRefreshing];
    }
}
- (void)takePhoto {
        PIEToHelpViewController* vc = [PIEToHelpViewController new];
        [self.navigationController pushViewController:vc animated:YES];

}

/**
 *  remove observers while being deallocated.
 */
-(void)dealloc {
}

#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         [self.takePhotoButtonConstraint setOffset:50.0];
                         [self.view layoutIfNeeded];
                     }];
    
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        [self.takePhotoButtonConstraint setOffset:-64];
        [UIView animateWithDuration:0.6
                              delay:0.7
             usingSpringWithDamping:0.3
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             [self.view layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                         }];
        
    }
}

// 处理滚动“戛然而止”的情况
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.takePhotoButtonConstraint setOffset:-64];
    [UIView animateWithDuration:0.6
                          delay:0.7
         usingSpringWithDamping:0.3
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         [self.view layoutIfNeeded];
                         
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
    
    PIENewReplyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell injectSauce:_sourceReply[indexPath.row]];
    return cell;
   
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
    //    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];
    
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
    //    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_currentIndex_reply) forKey:@"page"];
    PIEPageManager *pageManager = [PIEPageManager new];
    [pageManager pullReplySource:param block:^(NSMutableArray *array) {
        if (array.count) {
            [ws.sourceReply addObjectsFromArray:array] ;
            _canRefreshFooter_reply = YES;
        }
        else {
            _canRefreshFooter_reply = NO;
        }
        [ws.tableViewReply reloadData];
        [ws.tableViewReply.mj_footer endRefreshing];
    }];
}

#pragma mark - ReplyCell中的“喜欢该P图”和“关注P图主”的点击事件
-(void)likeReply {
    _selectedReplyCell.likeView.selected = !_selectedReplyCell.likeView.selected;
    [DDService toggleLike:_selectedReplyCell.likeView.selected ID:_selectedVM.ID type:_selectedVM.type  withBlock:^(BOOL success) {
        if (success) {
            _selectedVM.liked = _selectedReplyCell.likeView.selected;
            if (_selectedReplyCell.likeView.selected) {
                _selectedVM.likeCount = [NSString stringWithFormat:@"%zd",_selectedVM.likeCount.integerValue + 1];
            } else {
                _selectedVM.likeCount = [NSString stringWithFormat:@"%zd",_selectedVM.likeCount.integerValue - 1];
            }
        } else {
            _selectedReplyCell.likeView.selected = !_selectedReplyCell.likeView.selected;
        }
    }];
}

-(void)followReplier {
    _selectedReplyCell.followView.highlighted = !_selectedReplyCell.followView.highlighted;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_selectedVM.userID) forKey:@"uid"];
    if (_selectedReplyCell.followView.highlighted) {
        [param setObject:@1 forKey:@"status"];
    }
    else {
        [param setObject:@0 forKey:@"status"];
    }
    [DDService follow:param withBlock:^(BOOL success) {
        if (success) {
            _selectedVM.followed = _selectedReplyCell.followView.highlighted;
        } else {
            _selectedReplyCell.followView.highlighted = !_selectedReplyCell.followView.highlighted;
        }
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


#pragma mark - Gesture Event

- (void)setupGestures {
    UITapGestureRecognizer* tapGestureReply = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnReply:)];
    UILongPressGestureRecognizer* longPressGestureReply = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnReply:)];
    [_tableViewReply addGestureRecognizer:longPressGestureReply];
    [_tableViewReply addGestureRecognizer:tapGestureReply];
    
}

- (void)tapOnReply:(UITapGestureRecognizer *)gesture {
        CGPoint location = [gesture locationInView:_tableViewReply];
        _selectedIndexPath = [_tableViewReply indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            _selectedReplyCell = [_tableViewReply cellForRowAtIndexPath:_selectedIndexPath];
            _selectedVM = _sourceReply[_selectedIndexPath.row];
            CGPoint p = [gesture locationInView:_selectedReplyCell];
            
            //点击小图
            if (CGRectContainsPoint(_selectedReplyCell.thumbView.frame, p)) {
                CGPoint pp = [gesture locationInView:_selectedReplyCell.thumbView];
                if (CGRectContainsPoint(_selectedReplyCell.thumbView.leftView.frame,pp)) {
                    [_selectedReplyCell animateThumbScale:PIEAnimateViewTypeLeft];
                }
                else if (CGRectContainsPoint(_selectedReplyCell.thumbView.rightView.frame,pp)) {
                    [_selectedReplyCell animateThumbScale:PIEAnimateViewTypeRight];
                }
            }
            //点击大图
            else  if (CGRectContainsPoint(_selectedReplyCell.theImageView.frame, p)) {
                //进入热门详情
                PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                _selectedVM.image = _selectedReplyCell.theImageView.image;
                vc.pageVM = _selectedVM;
                [self presentViewController:vc animated:YES completion:nil];
                //                [self.navigationController pushViewController:vc animated:YES];
            }
            //点击头像
            else if (CGRectContainsPoint(_selectedReplyCell.avatarView.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self.navigationController pushViewController:friendVC animated:YES];
            }
            //点击用户名
            else if (CGRectContainsPoint(_selectedReplyCell.nameLabel.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self.navigationController pushViewController:friendVC animated:YES];
            }
            //            else if (CGRectContainsPoint(_selectedReplyCell.collectView.frame, p)) {
            //                //should write this logic in viewModel
            ////                [self collect:_selectedReplyCell.collectView shouldShowHud:NO];
            //                [self collect];
            //            }
            else if (CGRectContainsPoint(_selectedReplyCell.likeView.frame, p)) {
                [self likeReply];
            }
            else if (CGRectContainsPoint(_selectedReplyCell.followView.frame, p)) {
                [self followReplier];
            }
            else if (CGRectContainsPoint(_selectedReplyCell.shareView.frame, p)) {
                [self showShareView];
            }
            else if (CGRectContainsPoint(_selectedReplyCell.commentView.frame, p)) {
                PIECommentViewController* vc = [PIECommentViewController new];
                vc.vm = _selectedVM;
                vc.shouldShowHeaderView = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (CGRectContainsPoint(_selectedReplyCell.allWorkView.frame, p)) {
                PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
                vc.pageVM = _selectedVM;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    
}
- (void)longPressOnReply:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint location   = [gesture locationInView:_tableViewReply];
    _selectedIndexPath = [_tableViewReply indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
        _selectedReplyCell = [_tableViewReply cellForRowAtIndexPath:_selectedIndexPath];
        _selectedVM        = _sourceReply[_selectedIndexPath.row];
        CGPoint p          = [gesture locationInView:_selectedReplyCell];
        
        //点击大图
        if (CGRectContainsPoint(_selectedReplyCell.theImageView.frame, p)) {
            [self showShareView];
        }
    }

    
}

#pragma mark - Sharing-related method

#pragma mark - methods on Sharing<ATOMShareViewDelegate>
- (void)updateShareStatus {
    
    /**
     *  用户点击了updateShareStatus之后（在弹出的窗口完成分享，点赞），刷新本页面ReplyCell的点赞数和分享数
     */
    _selectedVM.shareCount = [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue]+1];
    [self updateStatus];
}


- (void)showShareView {
    [self.shareView show];
    
}


#pragma mark - ATOMShareViewDelegate

- (void)shareViewDidShare:(PIEShareView *)shareView socialShareType:(ATOMShareType)shareType
{
    [DDShareManager postSocialShare2:_selectedVM
                 withSocialShareType:shareType
                               block:^(BOOL success) {
                                   [self updateShareStatus];
                               }];
}

- (void)shareViewDidPaste:(PIEShareView *)shareView
{

}

- (void)shareViewDidReportUnusualUsage:(PIEShareView *)shareView
{
}

- (void)shareViewDidCollect:(PIEShareView *)shareView 
{
}

- (void)shareViewDidCancel:(PIEShareView *)shareView
{
    [shareView dismiss];
}

#pragma mark - Synchronized data with newest action
/**
 *  用户点击了updateShareStatus之后（在弹出的窗口完成分享，点赞），刷新本页面中ReplyCell的点赞数和分享数
 */
- (void)updateStatus {
    if (_selectedIndexPath) {
        [_tableViewReply reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
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
        UINib* nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [_tableViewReply registerNib:nib forCellReuseIdentifier:CellIdentifier];
        _tableViewReply.estimatedRowHeight = SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT;
        _tableViewReply.scrollsToTop       = YES;
        
    }
    return _tableViewReply;
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

-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView          = [PIEShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}

@end
