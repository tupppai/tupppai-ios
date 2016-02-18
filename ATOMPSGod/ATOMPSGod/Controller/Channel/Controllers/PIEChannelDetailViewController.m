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
#import "PIENewReplyTableCell.h"
#import "PIEShareView.h"
#import "PIECarouselViewController2.h"
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

@property (nonatomic, strong) PIENewReplyTableCell *selectedReplyCell;

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

static NSString * PIEDetailUsersPSCellIdentifier =
@"PIENewReplyTableCell";

#pragma mark - Life cycles

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupData];
    [self setupViews];

    [self setupGestures];
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
    _source_reply   = [NSMutableArray array];
    _source_ask     = [NSMutableArray array];
    //    _source_toHelp  = [NSMutableArray array];
}

- (void)setupGestures {
    UITapGestureRecognizer* tapGestureReply =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnReply:)];
    UILongPressGestureRecognizer* longPressGestureReply =
    [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnReply:)];
    [self.tableView addGestureRecognizer:longPressGestureReply];
    [self.tableView addGestureRecognizer:tapGestureReply];
    
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
        PIENewReplyTableCell *cell =
        [tableView dequeueReusableCellWithIdentifier:PIEDetailUsersPSCellIdentifier];
        
        [cell injectSauce:_source_reply[indexPath.row]];
        
        return cell;
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


#pragma mark - <PIEShareViewDelegate> and related methods

- (void)shareViewDidShare:(PIEShareView *)shareView
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


- (void)showShareView:(PIEPageVM *)pageVM {
    [self.shareView show:pageVM];
}





- (void)tapOnReply:(UITapGestureRecognizer *)gesture {
    
    CGPoint location = [gesture locationInView:self.tableView];
    _selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    
    if (_selectedIndexPath.section == 0) {
        PIENewAskViewController* vc = [PIENewAskViewController new];
        vc.channelVM = _currentChannelViewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if (_selectedIndexPath) {
        _selectedReplyCell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        _selectedVM = self.source_reply[_selectedIndexPath.row];
        CGPoint p = [gesture locationInView:_selectedReplyCell];
        
        //点击小图
        if (CGRectContainsPoint(_selectedReplyCell.blurAnimateImageView.frame, p)) {
            CGPoint pp = [gesture locationInView:_selectedReplyCell.blurAnimateImageView];
            if (CGRectContainsPoint(_selectedReplyCell.blurAnimateImageView.thumbView.frame,pp)) {
                CGPoint ppp = [gesture locationInView:_selectedReplyCell.blurAnimateImageView.thumbView];
                
                if (CGRectContainsPoint(_selectedReplyCell.blurAnimateImageView.thumbView.leftView.frame,ppp)) {
                    [_selectedReplyCell.blurAnimateImageView animateWithType:PIEThumbAnimateViewTypeLeft];
                }
                else if (CGRectContainsPoint(_selectedReplyCell.blurAnimateImageView.thumbView.rightView.frame,ppp)) {
                    [_selectedReplyCell.blurAnimateImageView animateWithType:PIEThumbAnimateViewTypeRight];
                }
                
            }
            else if (CGRectContainsPoint(_selectedReplyCell.blurAnimateImageView.imageView.frame,pp)) {
                PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                vc.pageVM = _selectedVM;
                [self presentViewController:vc animated:NO completion:nil];
            }
        }
        //点击大图
        else  if (CGRectContainsPoint(_selectedReplyCell.blurAnimateImageView.frame, p)) {
            PIECarouselViewController2* vc = [PIECarouselViewController2 new];
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

        else if (CGRectContainsPoint(_selectedReplyCell.likeView.frame, p)) {
            [_selectedVM love:NO];
        }
        else if (CGRectContainsPoint(_selectedReplyCell.followView.frame, p)) {
            [_selectedVM follow];
        }
        else if (CGRectContainsPoint(_selectedReplyCell.shareView.frame, p)) {
            [self showShareView:_selectedVM];
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
    
    CGPoint location   = [gesture locationInView:self.tableView];
    _selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath) {
        _selectedReplyCell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        _selectedVM        = self.source_reply[_selectedIndexPath.row];
        CGPoint p          = [gesture locationInView:_selectedReplyCell];
        
        //点击大图
        if (CGRectContainsPoint(_selectedReplyCell.blurAnimateImageView.frame, p)) {
            [self showShareView:_selectedVM];
        }        else if (CGRectContainsPoint(_selectedReplyCell.likeView.frame, p)) {
            [_selectedVM love:YES];
        }

    }
    
}



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

#pragma mark - Notification methods

/**
 *  用户点击了updateShareStatus之后（在弹出的窗口完成分享），刷新本页面的分享数（UI元素的同步）
 */
- (void)updateShareStatus {
    if (_selectedIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark - Target-actions


- (void)tapAsk {
    LeesinViewController* vc = [LeesinViewController new];
    vc.delegate = self;
    vc.type = LeesinViewControllerTypeAsk;
    vc.channel_id = self.currentChannelViewModel.ID;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)tapReply {
    LeesinViewController* vc = [LeesinViewController new];
    vc.delegate = self;
    vc.type = LeesinViewControllerTypeReply;
    vc.channel_id = self.currentChannelViewModel.ID;
    [self presentViewController:vc animated:YES completion:nil];
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"PIENewReplyTableCell" bundle:nil] forCellReuseIdentifier:PIEDetailUsersPSCellIdentifier];
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
        _shareView.delegate = self;
    }
    return  _shareView;
    
}


@end
