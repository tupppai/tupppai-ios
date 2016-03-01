//
//  PIEChannelDetailViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/8.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelDetailViewController.h"
#import "PIERefreshTableView.h"
#import "PIEChannelDetailLatestPSCell.h"
#import "SwipeView.h"
#import "PIEChannelDetailAskPSItemView.h"
#import "PIEChannelManager.h"

#import "PIEChannelViewModel.h"
#import "PIEShareView.h"
//#import "PIECarouselViewController2.h"
#import "PIEFriendViewController.h"
#import "PIECommentViewController.h"
#import "PIEReplyCollectionViewController.h"
#import "DDCollectManager.h"
#import "PIECameraViewController.h"
#import "PIENewAskViewController.h"
#import "DeviceUtil.h"

#import "PIEPageManager.h"
#import "PIEProceedingManager.h"

#import "LeesinViewController.h"
#import "MRNavigationBarProgressView.h"
#import "PIEChannelDetailIntoViewController.h"
#import "PIEEliteReplyTableViewCell.h"
#import "PIEPageDetailViewController.h"

@interface PIEChannelDetailViewController ()<LeesinViewControllerDelegate>
@property (nonatomic, strong) PIERefreshTableView           *tableView;
@property (nonatomic, strong) UIView                      *bottomContainerView;
@property (nonatomic, strong) NSMutableArray<PIEPageVM *>   *source_ask;
@property (nonatomic, strong) NSMutableArray<PIEPageVM *>   *source_reply;
//@property (nonatomic, strong) NSMutableArray<PIEPageVM *>   *source_toHelp;

@property (nonatomic, assign) long long                     timeStamp;
@property (nonatomic, assign) NSInteger                     currentPage_Reply;

@property (nonatomic, strong) SwipeView *swipeView;

@property (nonatomic, strong) PIEShareView *shareView;

@property (nonatomic, strong) PIEPageVM *selectedVM;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

//@property (nonatomic, strong) PIENewReplyTableCell *selectedReplyCell;

@property (nonatomic, strong) MASConstraint *bottomContainerViewBottomMC;
@property (nonatomic, assign) BOOL bottomContainerViewIsAnimating;

@property (nonatomic, strong) MRNavigationBarProgressView *progressView;

@end


@interface PIEChannelDetailViewController (TableView)
<UITableViewDelegate, UITableViewDataSource>
@end

@interface PIEChannelDetailViewController (PIERefreshTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEChannelDetailViewController (SwipeView)
<SwipeViewDelegate, SwipeViewDataSource>
@end

@interface PIEChannelDetailViewController (SharingDelegate)
<PIEShareViewDelegate>
@end


@implementation PIEChannelDetailViewController

static NSString *  PIEDetailLatestPSCellIdentifier =
@"DetailLatestPSCellIdentifier";

static NSString *  PIEDetailNormalIdentifier =
@"PIEDetailNormalIdentifier";
//
//static NSString * PIEDetailUsersPSCellIdentifier =
//@"PIENewReplyTableCell";

static  NSString *PIEEliteReplyCellIdentifier = @"PIEEliteReplyTableViewCell";

#pragma mark - Life cycles

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupData];
    [self setupViews];

//    [self setupGestures];
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavBar];
    [self setupProgressView];
}


-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)setupData
{
    self.title = self.currentChannelViewModel.title;
    _source_reply   = [NSMutableArray<PIEPageVM *> array];
    _source_ask     = [NSMutableArray<PIEPageVM *> array];
}

- (void)setupViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomContainerView];
    [self setupViewsContraints];
}
- (void)setupViewsContraints {
    [self.bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@44);
        self.bottomContainerViewBottomMC =
        make.bottom.equalTo(self.view);
    }];
}
- (void)setupProgressView {
    _progressView = [MRNavigationBarProgressView progressViewForNavigationController:self.navigationController];
    _progressView.progressTintColor = [UIColor colorWithHex:0x4a4a4a andAlpha:0.93];
}

- (void)setupNavBar
{
//    UIBarButtonItem *rightBarButton =
//    [[UIBarButtonItem alloc]
//     initWithImage:[UIImage imageNamed:@"pie_channelDetail_intro"]
//     style:UIBarButtonItemStylePlain
//     target:self action:@selector(tapRightBarButton)];
//    self.navigationItem.rightBarButtonItem = rightBarButton;
}


#pragma mark - <UITableViewDataSource>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.source_reply.count;
    }
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        PIEChannelDetailLatestPSCell *detailLatestPSCell =
        [tableView dequeueReusableCellWithIdentifier:PIEDetailLatestPSCellIdentifier];
        detailLatestPSCell.swipeView.delegate   = self;
        detailLatestPSCell.swipeView.dataSource = self;
        
        self.swipeView = detailLatestPSCell.swipeView;
        return detailLatestPSCell;
    }
    else
    {
        PIEEliteReplyTableViewCell *replyCell =
        [tableView dequeueReusableCellWithIdentifier:PIEEliteReplyCellIdentifier];
        
        PIEPageVM *viewModel = _source_reply[indexPath.row];
        
        [replyCell bindVM:viewModel];
        
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
    
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PIENewAskViewController* vc = [PIENewAskViewController new];
        vc.channelVM = _currentChannelViewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - <PWRefreshBaseTableViewDelegate>

/**
 *  上拉加载
 */
- (void)didPullRefreshUp:(UITableView *)tableView
{
    if (_source_ask.count <= 0) {
        [self getSource_Ask];
    }
    [self getMoreSource_Reply];
}

/**
 *  下拉刷新
 */
- (void)didPullRefreshDown:(UITableView *)tableView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //getSource_Ask 经常拿不到数据，如果和getSource_Reply几乎同时调用的话。
        [self getSource_Ask];
    });
    
    [self getSource_Reply:nil];
}

#pragma mark - <SwipeViewDelegate>
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    CGFloat screenWidth         = [UIScreen mainScreen].bounds.size.width;
    CGFloat swipeViewItemWidth  = screenWidth * (180.0 / 750.0);
    CGFloat swipeViewItemHeight = screenWidth * (214.0 / 750.0);
    return CGSizeMake(swipeViewItemWidth, swipeViewItemHeight);
}


- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    
    PIECommentViewController* vc = [PIECommentViewController new];
    vc.vm = _source_ask[index];
    vc.shouldShowHeaderView = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - <SwipeViewDataSource>
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.source_ask.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView
   viewForItemAtIndex:(NSInteger)index
          reusingView:(PIEChannelDetailAskPSItemView *)view
{
    if (view == nil)
    {
        NSInteger height = swipeView.frame.size.height;
        view = [[PIEChannelDetailAskPSItemView alloc]initWithFrame:CGRectMake(0, 0, height, height)];
    }
    
    NSString* urlString = [_source_ask[index].imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION*0.25];
    NSURL *imageURL = [NSURL URLWithString:urlString];
    [view.imageView sd_setImageWithURL:imageURL
                      placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    view.label.text = _source_ask[index].content;
    
    return view;
}

/*
- (void)tapOnReply:(UITapGestureRecognizer *)gesture {
    
    CGPoint location = [gesture locationInView:self.tableView];
    _selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    
    if (_selectedIndexPath.section == 0) {
        PIENewAskViewController* vc = [PIENewAskViewController new];
        vc.channelVM = _currentChannelViewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }

*/

#pragma mark - Network request
- (void)getSource_Ask {
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    params[@"category_id"]        = @(self.currentChannelViewModel.ID);
    params[@"page"]              = @(1);
    params[@"size"]              = @(10);
    params[@"type"]              = @"ask";
    
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    params[@"last_updated"]              = @(timeStamp);
    
    
    [params setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
    
    [PIEChannelManager getSource_channelPages:params resultBlock:^(NSMutableArray<PIEPageVM *> *pageArray) {
        [_source_ask removeAllObjects];
        [_source_ask addObjectsFromArray:pageArray];
    } completion:^{
        [self.swipeView reloadData];
        
    }];
}

- (void)getSource_Reply:(void (^)(BOOL success))block {
    WS(ws);
    _currentPage_Reply = 1;
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    params[@"category_id"]        = @(self.currentChannelViewModel.ID);
    params[@"page"]              = @(1);
    params[@"size"]              = @(20);
    params[@"type"]              = @"reply";
    _timeStamp                   = [[NSDate date] timeIntervalSince1970];
    params[@"last_updated"]      = @(_timeStamp);
    [params setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    
    [PIEChannelManager getSource_channelPages:params resultBlock:^(NSMutableArray<PIEPageVM *> *pageArray) {
        [_source_reply removeAllObjects];
        [_source_reply addObjectsFromArray:pageArray];
        
        if (block && pageArray.count > 0) {
            block(YES);
        }else if (block && pageArray.count == 0) {
            block(NO);
        }
    } completion:^{
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView reloadData];
    }];
}
- (void)getMoreSource_Reply {
    WS(ws);
    _currentPage_Reply++;
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    params[@"category_id"]        = @(self.currentChannelViewModel.ID);
    params[@"page"]              = @(_currentPage_Reply);
    params[@"size"]              = @(20);
    params[@"type"]              = @"reply";
    params[@"last_updated"]      = @(_timeStamp);
    [params setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    
    [PIEChannelManager getSource_channelPages:params resultBlock:^(NSMutableArray<PIEPageVM *> *pageArray) {
        [_source_reply addObjectsFromArray:pageArray];
    } completion:^{
        [ws.tableView.mj_footer endRefreshing];
        [ws.tableView reloadData];
    }];
}

#pragma mark - Target-actions
- (void)tapAsk{
    if ([DDUserManager currentUser].uid == kPIETouristUID) {
        [[NSNotificationCenter defaultCenter]
        postNotificationName:PIENetworkCallForFurtherRegistrationNotification
         object:nil];
    }else{
        LeesinViewController* vc = [LeesinViewController new];
        vc.delegate = self;
        vc.type = LeesinViewControllerTypeAsk;
        vc.channel_id = self.currentChannelViewModel.ID;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)tapReply {
    if ([DDUserManager currentUser].uid == kPIETouristUID) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PIENetworkCallForFurtherRegistrationNotification
         object:nil];
    }else{
        LeesinViewController* vc = [LeesinViewController new];
        vc.delegate = self;
        vc.type = LeesinViewControllerTypeReply;
        vc.channel_id = self.currentChannelViewModel.ID;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)tapRightBarButton
{
    PIEChannelDetailIntoViewController *introVC =
    [[PIEChannelDetailIntoViewController alloc] init];
    
    introVC.url = self.currentChannelViewModel.url;
    
    [self.navigationController pushViewController:introVC
                                         animated:YES];
}


#pragma mark - LeesinViewController delegate
-(void)leesinViewController:(LeesinViewController *)leesinViewController uploadPercentage:(CGFloat)percentage uploadSucceed:(BOOL)success {
    [self.progressView setProgress:percentage animated:YES];
    if (success) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

        if (leesinViewController.type == LeesinViewControllerTypeAsk) {
            [self getSource_Ask];
        } else {
            [self getSource_Reply:^(BOOL success) {
                if (success) {
                }
            }];

        }
    }
}


#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!_bottomContainerViewIsAnimating) {
        
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.bottomContainerViewBottomMC setOffset:50.0];
                             [self.bottomContainerView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 _bottomContainerViewIsAnimating = NO;
                             }
                         }];
    }

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!_bottomContainerViewIsAnimating) {

        [self.bottomContainerViewBottomMC setOffset:0];
        [UIView animateWithDuration:0.2
                              delay:2.0
             usingSpringWithDamping:0.88
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             [self.bottomContainerView layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             _bottomContainerViewIsAnimating = NO;
                         }];
    }
}

#pragma mark - RAC response actions
- (void)tapOnAvatarOrUsernameAtIndexPath:(NSIndexPath *)indexPath
{
    PIEFriendViewController *friendVC = [PIEFriendViewController new];
    friendVC.pageVM = _source_reply[indexPath.row];
    [self.navigationController pushViewController:friendVC animated:YES];
}

- (void)tapOnFollowViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _source_reply[indexPath.row];
    [selectedVM follow];
}

- (void)tapOnImageViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _source_reply[indexPath.row];
    PIEPageDetailViewController *pageDetailVC =
    [PIEPageDetailViewController new];
    pageDetailVC.pageViewModel = selectedVM;
    [self.navigationController pushViewController:pageDetailVC animated:YES];
}

- (void)longPressOnImageViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEShareView *shareView = [PIEShareView new];
    PIEPageVM *selectedVM = _source_reply[indexPath.row];
    [shareView show:selectedVM];
}

- (void)tapOnAllWorkAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _source_reply[indexPath.row];
    PIEReplyCollectionViewController *replyCollectionVC =
    [PIEReplyCollectionViewController new];
    replyCollectionVC.pageVM = selectedVM;
    [self.navigationController pushViewController:replyCollectionVC animated:YES];
}

- (void)tapOnShareViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _source_reply[indexPath.row];
    [self.shareView show:selectedVM];
    
}

- (void)tapOnCommentViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIECommentViewController *commentVC = [PIECommentViewController new];
    commentVC.vm = _source_reply[indexPath.row];
    commentVC.shouldShowHeaderView = NO;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)tapOnLikeViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _source_reply[indexPath.row];
    [selectedVM love:NO];
}

- (void)longPressOnLikeViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _source_reply[indexPath.row];
    [selectedVM love:YES];
}


#pragma mark - lazy loadings
- (PIERefreshTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[PIERefreshTableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.psDelegate = self;
        // iOS 8+, self-sizing cell
        _tableView.estimatedRowHeight = 400;
        _tableView.rowHeight          = UITableViewAutomaticDimension;
        
        [_tableView registerNib:[UINib nibWithNibName:@"PIEChannelDetailLatestPSCell" bundle:nil]forCellReuseIdentifier:PIEDetailLatestPSCellIdentifier];
        
        UINib *replyCellNib =
        [UINib nibWithNibName:@"PIEEliteReplyTableViewCell" bundle:nil];
        [_tableView registerNib:replyCellNib forCellReuseIdentifier:PIEEliteReplyCellIdentifier];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (UIView *)bottomContainerView
{
    if (_bottomContainerView == nil) {
        _bottomContainerView = [[UIView alloc] init];
        _bottomContainerView.backgroundColor = [UIColor clearColor];
        UIButton* askButton = [UIButton new];
        UIButton* replyButton = [UIButton new];
        [askButton setBackgroundColor:[UIColor colorWithHex:0x4a4a4a  andAlpha:0.93]];
        [replyButton setBackgroundColor:[UIColor colorWithHex:0xffef00 andAlpha:0.93]];
        [askButton      setTitle:@"我要求P"  forState:  UIControlStateNormal];
        [replyButton    setTitle:@"发布作品" forState:  UIControlStateNormal];
        [askButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        askButton.titleLabel.font = [UIFont mediumTupaiFontOfSize:14];
        replyButton.titleLabel.font = [UIFont mediumTupaiFontOfSize:14];

        [askButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [replyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [_bottomContainerView addSubview:askButton];
        [_bottomContainerView addSubview:replyButton];
        
        [askButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.top.and.bottom.equalTo(_bottomContainerView);
            make.width.equalTo(replyButton);
        }];
        [replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.and.top.and.bottom.equalTo(_bottomContainerView);
            make.leading.equalTo(askButton.mas_trailing);
        }];
        

        [askButton addTarget:self
                             action:@selector(tapAsk)
                   forControlEvents:UIControlEventTouchDown];
        [replyButton addTarget:self
                      action:@selector(tapReply)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomContainerView;
    
}

- (PIEShareView *)shareView
{
    if (_shareView == nil) {
        _shareView = [[PIEShareView alloc] init];
//        _shareView.delegate = self;
    }
    return  _shareView;
    
}


@end
