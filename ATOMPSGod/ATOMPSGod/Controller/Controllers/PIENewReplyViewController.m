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

@end

/* Delegates */
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
    
    self.view = self.tableViewReply;
    
    [self setupGestures];
    [self setupData];
    [self setupNotifications];
    
    /**
     *  假如model（_source）为空的话，那就重新fetch data
     */
    [self firstGetSourceIfEmpty_Reply];
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
- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_New" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldDoUploadJob) name:@"UploadRightNow" object:nil];
}

- (void)shouldDoUploadJob {
    _progressView = [MRNavigationBarProgressView progressViewForNavigationController:self.navigationController];
    _progressView.progressTintColor = [UIColor pieYellowColor];
    
    BOOL should = [[NSUserDefaults standardUserDefaults]
                   boolForKey:@"shouldDoUploadJob"];
    if (should) {
        [self PleaseDoTheUploadProcess];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"shouldDoUploadJob"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) PleaseDoTheUploadProcess {
    PIEUploadManager* manager = [PIEUploadManager new];
    [manager upload:^(CGFloat percentage,BOOL success) {
        [_progressView setProgress:percentage animated:YES];
        if (success) {
            [_tableViewReply.mj_header beginRefreshing];
        }
    }];
}

- (void)refreshHeader {
    if (!_tableViewReply.mj_header.isRefreshing) {
        [_tableViewReply.mj_header beginRefreshing];
    }
}

/**
 *  remove observers while being deallocated.
 */
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNavigation_New" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadRightNow" object:nil];
    //compiler would call [super dealloc] automatically in ARC.
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

#pragma mark - Reply ???
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
     *  用户点击了updateShareStatus之后（在弹出的窗口完成分享，点赞），刷新本页面的点赞数和分享数
     */
    _selectedVM.shareCount = [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue]+1];
    [self updateStatus];
}


- (void)showShareView {
    [self.shareView show];
    
}
-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}

#pragma mark - Synchronized data with newest action
/**
 *  用户点击了updateShareStatus之后（在弹出的窗口完成分享，点赞），刷新本页面的点赞数和分享数
 */
- (void)updateStatus {
    if (_selectedIndexPath) {
        [_tableViewReply reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - lazy loadings
-(PIERefreshTableView *)tableViewReply {
    if (_tableViewReply == nil) {
        _tableViewReply = [[PIERefreshTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
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


@end
