//
//  PIEChannelActivityViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/11.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelActivityViewController.h"
#import "PIERefreshTableView.h"
#import "PIENewReplyTableCell.h"
#import "PIEPageVM.h"
#import "PIEChannelViewModel.h"
#import "PIEChannelManager.h"
#import "PIECarouselViewController2.h"
#import "PIEFriendViewController.h"
#import "PIECommentViewController.h"
#import "PIEReplyCollectionViewController.h"
#import "PIEShareView.h"
#import "DDCollectManager.h"


/* Variables */
@interface PIEChannelActivityViewController ()

/*Views*/
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, strong) UIButton            *goPsButton;

/** image from currentChannelVM */
@property (nonatomic, strong) UIButton            *headerBannerView;

/*ViewModels*/
@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *source_reply;
@property (nonatomic, strong) PIEPageVM                   *selectedVM;
@property (nonatomic, strong) PIEChannelViewModel         *currentChannelVM;

/* HTTP Request parameter */
@property (nonatomic, assign) long long timeStamp;

/* ======= */

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) PIENewReplyTableCell *selectedReplyCell;

/** 点击弹出的分享页面 */
@property (nonatomic, strong) PIEShareView *shareView;

@end

/* Protocols */
@interface PIEChannelActivityViewController (TableView)
<UITableViewDelegate, UITableViewDataSource>
@end

@interface PIEChannelActivityViewController (RefreshTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEChannelActivityViewController (SharingDelegate)
<PIEShareViewDelegate>

@end

@implementation PIEChannelActivityViewController

static NSString *
PIEChannelActivityReplyCellIdentifier = @"PIENewReplyTableCell";

static NSString *
PIEChannelActivityNormalCellIdentifier = @"PIEChannelActivityNormalCellIdentifier";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"#表情有灵气";
    
    // setup data
    [self setupData];
    
    // configure subviews
    [self configureTableView];
    [self configureGoPsButton];
    
    /* 设置可以区分reply cell中不同UI元素（头像，关注按钮，分享, etc.）的点击事件回调 */
    [self setupGestures];
    
    // load data for the first time.
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI components setup
- (void)configureTableView
{
    // add to subView
    [self.view addSubview:self.tableView];
    
    
    
    // set constraints
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
}


- (void)configureGoPsButton
{
    // add to subView
    [self.view addSubview:self.goPsButton];
    
    // set constraints
    [self.goPsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-64);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - data setup
- (void)setupData
{
    _source_reply = [[NSMutableArray<PIEPageVM *> alloc] init];
}

#pragma mark - <UITableViewDelegate>


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return  self.source_reply.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PIENewReplyTableCell *replyCell =
    [tableView dequeueReusableCellWithIdentifier:PIEChannelActivityReplyCellIdentifier];
    [replyCell hideThumbnailImage];
    [replyCell injectSauce:_source_reply[indexPath.row]];
    
    return replyCell;
}
#pragma mark - <PWRefreshBaseTableViewDelegate>
- (void)didPullRefreshUp:(UITableView *)tableView
{
    [self loadMoreReplies];
}

- (void)didPullRefreshDown:(UITableView *)tableView
{
    [self loadNewReplies];
}

#pragma mark - refreshing methods
- (void)loadNewReplies
{
    NSLog(@"%s", __func__);
    
    /*
     <h3 id="get_activity_threads">获取活动相关作品</h3>
     
     /thread/get_activity_threads
     URL_ChannelActivity
     接受参数
     get:
     activity_id:活动id (test: 1003)
     page:页面，默认为1
     size:页面数目，默认为10
     last_updated:最后下拉更新的时间戳（10位）
     */
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"activity_id"]      = @(1003);
    params[@"page"]             = @(1);
    params[@"size"]             = @(10);
    _timeStamp                  = [[NSDate date] timeIntervalSince1970];
    params[@"last_updated"]     = @(_timeStamp);
    
    __weak typeof(self) weakSelf = self;
    [PIEChannelManager
     getSource_pageViewModels:params
     repliesResult:^(NSMutableArray<PIEPageVM *> *repliesResultArray) {
         [_source_reply removeAllObjects];
         [_source_reply addObjectsFromArray:repliesResultArray];
         
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [weakSelf.tableView.mj_header endRefreshing];
             [weakSelf.tableView reloadData];
         }];
     }];
}

- (void)loadMoreReplies
{
    NSLog(@"%s", __func__);
    
    /*
     <h3 id="get_activity_threads">获取活动相关作品</h3>
     
     /thread/get_activity_threads
     URL_ChannelActivity
     接受参数
     get:
     activity_id:活动id (test: 1003)
     page:页面，默认为1
     size:页面数目，默认为10
     last_updated:最后下拉更新的时间戳（10位）
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"activity_id"]      = @(1003);
    params[@"page"]             = @(2);
    params[@"size"]             = @(10);
    _timeStamp                  = [[NSDate date] timeIntervalSince1970];
    params[@"last_updated"]     = @(_timeStamp);
    
    __weak typeof(self) weakSelf = self;
    [PIEChannelManager
     getSource_pageViewModels:params
     repliesResult:^(NSMutableArray<PIEPageVM *> *repliesResultArray) {
         if (repliesResultArray.count == 0) {
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [weakSelf.tableView.mj_footer endRefreshing];
             }];
         }
         else{
             [_source_reply addObjectsFromArray:repliesResultArray];
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [weakSelf.tableView.mj_footer endRefreshing];
                 [weakSelf.tableView reloadData];
             }];
         }
     }];
    
}

#pragma mark - Target-actions
- (void)goPSButtonClicked:(UIButton *)button
{
    NSLog(@"%s", __func__);

}

- (void)headerBannerViewClicked:(UIButton *)button
{
    NSLog(@"%s", __func__);

}

#pragma mark - Gesture Event - 识别PIENewReplyCell中的不同元素(头像，关注按钮，etc.)的点击事件

- (void)setupGestures {
    UITapGestureRecognizer* tapGestureReply =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnReply:)];
    UILongPressGestureRecognizer* longPressGestureReply =
    [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnReply:)];
    [self.tableView addGestureRecognizer:longPressGestureReply];
    [self.tableView addGestureRecognizer:tapGestureReply];
    
}

- (void)tapOnReply:(UITapGestureRecognizer *)gesture {
    
    PIELog(@"%s", __func__);
    
    CGPoint location = [gesture locationInView:self.tableView];
    _selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
        _selectedReplyCell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        _selectedVM = self.source_reply[_selectedIndexPath.row];
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
    
    PIELog(@"%s", __func__);
    
    CGPoint location   = [gesture locationInView:self.tableView];
    _selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
        _selectedReplyCell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        _selectedVM        = self.source_reply[_selectedIndexPath.row];
        CGPoint p          = [gesture locationInView:_selectedReplyCell];
        
        //点击大图
        if (CGRectContainsPoint(_selectedReplyCell.theImageView.frame, p)) {
            [self showShareView];
        }
    }
    
    
}

#pragma mark - reply cell 中的点击事件：喜欢该P图，关注P图主。

/**
 *  点击事件： 喜欢这张P图
 */
-(void)likeReply {
    
    PIELog(@"%s", __func__);
    
    
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

/**
 *  关注这张P图的P图主
 */
-(void)followReplier {
    
    PIELog(@"%s", __func__);
    
    
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


#pragma mark - Sharing-related method
#pragma mark - methods on Sharing<ATOMShareViewDelegate>
- (void)updateShareStatus {
    
    /**
     *  用户点击了updateShareStatus之后（在弹出的窗口完成分享，点赞），刷新本页面的点赞数和分享数（两个页面的UI元素的同步）
     */
    _selectedVM.shareCount = [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue]+1];
    [self updateStatus];
}

- (void)showShareView {
    [self.shareView show];
    
}

/**
 *  用户点击了updateShareStatus之后（在弹出的窗口完成分享，点赞），刷新本页面的点赞数和分享数
 */
- (void)updateStatus {
    if (_selectedIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - <PIEShareViewDelegate>
/*
 以下代理方法在用户点击了shareView中的8个button的其中一个（分享到新浪，微信，微博，etc.) 的时候被调用
 */

//sina
-(void)tapShare1 {
    PIELog(@"%s", __func__);
    
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeSinaWeibo block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//qqzone
-(void)tapShare2 {
    PIELog(@"%s", __func__);
    
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQZone block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//wechat moments
-(void)tapShare3 {
    PIELog(@"%s", __func__);
    
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatMoments block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//wechat friends
-(void)tapShare4 {
    PIELog(@"%s", __func__);
    
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatFriends block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
-(void)tapShare5 {
    PIELog(@"%s", __func__);
    
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQFriends block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
    
}

-(void)tapShare6 {
    PIELog(@"%s", __func__);
    
    [DDShareManager copy:_selectedVM];
}
-(void)tapShare7 {
    PIELog(@"%s", __func__);
    
    
    self.shareView.vm = _selectedVM;
}
-(void)tapShare8 {
    PIELog(@"%s", __func__);
    
    
    //    if (_scrollView.type == PIENewScrollTypeAsk) {
    //        if (_selectedVM.type == PIEPageTypeAsk) {
    [self collect];
    //        }
    //    } else {
    //        if (_selectedVM.type == PIEPageTypeAsk) {
    //            [self collect];
    //        } else {
    //            PIENewReplyTableCell* cell = [_scrollView.tableReply cellForRowAtIndexPath:_selectedIndexPath];
    //            [self collect:cell.collectView shouldShowHud:YES];
    //        }
    //    }
    
}

-(void)tapShareCancel {
    PIELog(@"%s", __func__);
    
    [self.shareView dismiss];
}

#pragma mark - "收藏"相关操作， shareView中用户点击了"收藏"之后被调用
-(void)collect {
    NSMutableDictionary *param = [NSMutableDictionary new];
    _selectedVM.collected = !_selectedVM.collected;
    if (_selectedVM.collected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:_selectedVM.type withID:_selectedVM.ID withBlock:^(NSError *error) {
        if (!error) {
            if (  _selectedVM.collected) {
                [Hud textWithLightBackground:@"收藏成功"];
            } else {
                [Hud textWithLightBackground:@"取消收藏成功"];
            }
        }   else {
            _selectedVM.collected = !_selectedVM.collected;
        }
    }];
}



#pragma mark - Lazy loadings
- (PIERefreshTableView *)tableView
{
    if (_tableView == nil) {
        // instantiate only for once
        _tableView = [[PIERefreshTableView alloc] init];
        
        _tableView.delegate   = self;
        _tableView.psDelegate = self;
        _tableView.dataSource = self;
        
        // iOS 8+, self-sizing cell
        _tableView.estimatedRowHeight = 400;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        // add headerBannerView
        _tableView.tableHeaderView = self.headerBannerView;
        
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // register cells
        [_tableView registerNib:[UINib nibWithNibName:@"PIENewReplyTableCell"
                                               bundle:nil]
         forCellReuseIdentifier:PIEChannelActivityReplyCellIdentifier];
        
        [_tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:PIEChannelActivityNormalCellIdentifier];
    }
    
    
    return  _tableView;
}


- (UIButton *)headerBannerView
{
    if (_headerBannerView == nil) {
        // instantiate only for once
        _headerBannerView = [[UIButton alloc] init];
        
        // set background image("表情有灵气")
        [_headerBannerView
         setBackgroundImage:[UIImage imageNamed:@"pie_channelActivityBanner"]
         forState:UIControlStateNormal];
        
        // 取消点击变暗的效果
        _headerBannerView.adjustsImageWhenHighlighted = NO;
        
        // set frame
        _headerBannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (448.0 / 750.0)*SCREEN_WIDTH);
        
        // Target-actions
        [_headerBannerView addTarget:self
                              action:@selector(headerBannerViewClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerBannerView;
}

- (UIButton *)goPsButton
{
    if (_goPsButton == nil) {
        // instantiate only for once
        _goPsButton = [[UIButton alloc] init];
        
        // set background image (make-shift case)
        [_goPsButton setBackgroundImage:[UIImage imageNamed:@"moment"]
                               forState:UIControlStateNormal];
        
        
        
        // Target-actions
        [_goPsButton addTarget:self
                        action:@selector(goPSButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _goPsButton;

}

- (PIEShareView *)shareView
{
    if (_shareView == nil) {
        // instantiate only for once
        _shareView = [[PIEShareView alloc] init];
        
        _shareView.delegate = self;
    }
    return  _shareView;
}

@end