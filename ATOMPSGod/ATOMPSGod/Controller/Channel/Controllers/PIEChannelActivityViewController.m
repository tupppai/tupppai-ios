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
//#import "QBImagePickerController.h"
//#import "PIEUploadVC.h"
#import "PIEWebViewViewController.h"
#import "DDSessionManager.h"
#import "DDNavigationController.h"

#import "PIEPageManager.h"

#import "LeesinViewController.h"
#import "MRNavigationBarProgressView.h"
/* Variables */
@interface PIEChannelActivityViewController ()<LeesinViewControllerDelegate>

/*Views*/
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, strong) UIButton            *goPsButton;

/** image from currentChannelVM */
@property (nonatomic, strong) UIButton            *headerBannerView;

/*ViewModels*/
@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *source_reply;
@property (nonatomic, strong) PIEPageVM                   *selectedVM;


/* HTTP Request parameter */
@property (nonatomic, assign) long long timeStamp;

/* ======= */

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) PIENewReplyTableCell *selectedReplyCell;

/** 点击弹出的分享页面 */
@property (nonatomic, strong) PIEShareView *shareView;

/** 当前加载的页面 */
@property (nonatomic, assign) NSUInteger currentPageIndex;


//@property (nonatomic, strong) QBImagePickerController* QBImagePickerController;

/* Autolayout animation */
@property (nonatomic, strong) MASConstraint *goPsButtonBottomConstraint;

@property (nonatomic, assign) NSInteger                     currentPage_Reply;

@property (nonatomic, strong) MRNavigationBarProgressView *progressView;

@property (nonatomic, assign) BOOL canRefreshFooter;

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
    
    self.title = [NSString stringWithFormat:
                  @"#%@", self.currentChannelVM.title];
    
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


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupProgressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)hidesBottomBarWhenPushed {
    return  YES;
}

- (void)dealloc
{
}
#pragma mark - UI components setup
- (void)configureTableView
{
    [self.view addSubview:self.tableView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
}


- (void)configureGoPsButton
{
    [self.view addSubview:self.goPsButton];
    
    [self.goPsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(32);
        
        self.goPsButtonBottomConstraint =
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-17);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - data setup
- (void)setupData
{
    _source_reply = [[NSMutableArray<PIEPageVM *> alloc] init];
    
    _currentPageIndex = 0;
    
    _canRefreshFooter = YES;
    
}

- (void)setupProgressView {
    _progressView = [MRNavigationBarProgressView progressViewForNavigationController:self.navigationController];
    _progressView.progressTintColor = [UIColor colorWithHex:0x4a4a4a andAlpha:0.93];
}


#pragma mark - LeesinViewController delegate
-(void)leesinViewController:(LeesinViewController *)leesinViewController uploadPercentage:(CGFloat)percentage uploadSucceed:(BOOL)success {
    [self.progressView setProgress:percentage animated:YES];
    if (success) {
        if (leesinViewController.type == LeesinViewControllerTypeReplyNoMissionSelection) {
            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
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
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self.goPsButtonBottomConstraint setOffset:50.0];
                         [self.goPsButton layoutIfNeeded];
                     }];
    
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.goPsButtonBottomConstraint setOffset:-12];
    [UIView animateWithDuration:0.8
                          delay:2.0
         usingSpringWithDamping:0.67
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.goPsButton layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                     }];
}



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
    replyCell.blurAnimateImageView.thumbView.hidden = YES;
    [replyCell injectSauce:_source_reply[indexPath.row]];
   
    
    /*去掉ChannelActivity中的cell的“其它作品”按钮*/
    replyCell.allWorkView.hidden = YES;
    [replyCell.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(replyCell.allWorkView.mas_left);
    }];
    
    
    return replyCell;
}
#pragma mark - <PWRefreshBaseTableViewDelegate>


- (void)didPullRefreshDown:(UITableView *)tableView
{
    [self getSource_Reply:nil];
}
- (void)didPullRefreshUp:(UITableView *)tableView
{
    if (_canRefreshFooter) {
        [self getMoreSource_Reply];
    }else{
        [Hud text:@"已经拉到底啦"];
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)getSource_Reply:(void (^)(BOOL success))block {
    WS(ws);
    _currentPage_Reply = 1;
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    params[@"category_id"]        = @(self.currentChannelVM.ID);
    params[@"page"]              = @(1);
    params[@"size"]              = @(10);
    params[@"type"]              = @"reply";
    _timeStamp                   = [[NSDate date] timeIntervalSince1970];
    params[@"last_updated"]      = @(_timeStamp);
    [params setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];

    [PIEChannelManager getSource_channelPages:params
                                  resultBlock:^(NSMutableArray<PIEPageVM *> *pageArray) {
                                      
                                      if (pageArray.count == 0) {
                                          _canRefreshFooter = NO;
                                      }else{
                                          _canRefreshFooter = YES;
                                      }
                                      [_source_reply removeAllObjects];
                                      [_source_reply addObjectsFromArray:pageArray];
                                      if (block) {
                                          block(YES);
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
    params[@"category_id"]        = @(self.currentChannelVM.ID);
    params[@"page"]              = @(_currentPage_Reply);
    params[@"size"]              = @(10);
    params[@"type"]              = @"reply";
    params[@"last_updated"]      = @(_timeStamp);
    [params setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];

    [PIEChannelManager getSource_channelPages:params resultBlock:^(NSMutableArray<PIEPageVM *> *pageArray) {
        if (pageArray.count < 10) {
            _canRefreshFooter = NO;
        }else{
            _canRefreshFooter = YES;
        }
        
        [_source_reply addObjectsFromArray:pageArray];
    } completion:^{
        [ws.tableView.mj_footer endRefreshing];
        [ws.tableView reloadData];
    }];
}

#pragma mark - Notification Methods
/**
 *  用户点击了updateShareStatus之后（在弹出的窗口完成分享），刷新本页面的分享数（两个页面的UI元素的同步）
 */
- (void)updateShareStatus {
    
    // _vm.shareCount ++ 这个副作用集中发生在PIEShareView之中。
    
    //    _selectedVM.shareCount = [NSString stringWithFormat:@"%zd",[_selectedVM.shareCount integerValue]+1];
    //    [self updateStatus]; 将刷新的方法摆到了这里
    if (_selectedIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Target-actions
- (void)goPSButtonClicked:(UIButton *)button
{
    LeesinViewController* vc = [LeesinViewController new];
    vc.delegate = self;
    vc.type = LeesinViewControllerTypeReplyNoMissionSelection;
    vc.channel_id = self.currentChannelVM.ID;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)headerBannerViewClicked:(UIButton *)button
{
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_currentChannelVM.askID) forKey:@"target"];
    [DDService signProceeding:param withBlock:nil];
    
    PIEWebViewViewController* vc = [PIEWebViewViewController new];
    vc.url = _currentChannelVM.url;
    DDNavigationController *nav = [[DDNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];

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
    

    
    CGPoint location = [gesture locationInView:self.tableView];
    _selectedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    if (_selectedIndexPath == nil) {
        return;
    }
        _selectedReplyCell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        _selectedVM = self.source_reply[_selectedIndexPath.row];
        CGPoint p = [gesture locationInView:_selectedReplyCell];
        

        //点击大图
          if (CGRectContainsPoint(_selectedReplyCell.blurAnimateImageView.frame, p)) {
            //进入热门详情
            PIECarouselViewController2* vc = [PIECarouselViewController2 new];
            vc.pageVM = _selectedVM;
            NSLog(@"!!%@,%zd,%zd",_selectedVM,_selectedVM.askID,_selectedVM.ID);
            [self presentViewController:vc animated:YES completion:nil];
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
//            [PIEPageManager love:_selectedReplyCell.likeView viewModel:_selectedVM revert:NO];
            [_selectedVM love:NO];
        }
        else if (CGRectContainsPoint(_selectedReplyCell.followView.frame, p)) {
//            [self followReplier];
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
        
        
        /*去掉ChannelActivity中的cell的“其它作品”按钮*/

//        else if (CGRectContainsPoint(_selectedReplyCell.allWorkView.frame, p)) {
//            PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
//            vc.pageVM = _selectedVM;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    
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
//            [PIEPageManager love:_selectedReplyCell.likeView viewModel:_selectedVM revert:YES];
            [_selectedVM love:YES];
        }

    }
    
    
}

#pragma mark - reply cell 中的点击事件：喜欢该P图，关注P图主。



#pragma mark - <PIEShareViewDelegate>
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

#pragma mark - Sharing-related method


- (void)showShareView:(PIEPageVM *)pageVM {
    [self.shareView show:pageVM];
    
}




//#pragma mark - qb_imagePickerController delegate
//-(void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
//    
//    [PIEUploadManager shareModel].channel_id = _currentChannelVM.ID;
//
//    [PIEUploadManager shareModel].type = PIEPageTypeReply;
//    PIEUploadVC* vc = [PIEUploadVC new];
////    vc.channelVM = _currentChannelVM;
//    vc.assetsArray = assets;
//    vc.hideSecondView = YES;
//    [imagePickerController.albumsNavigationController pushViewController:vc animated:YES];
//    
//}
//
//-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
//    [self.QBImagePickerController.selectedAssetURLs removeAllObjects];
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}


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
        
        _tableView.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
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
        
        NSString* urlString = [self.currentChannelVM.banner_pic trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
        NSURL *bannerImageUrl = [NSURL URLWithString:urlString];
        
        SDWebImageManager* manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:bannerImageUrl options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [_headerBannerView setBackgroundImage:image forState:UIControlStateNormal];
        }];
        
        _headerBannerView.backgroundColor = [UIColor colorWithHex:0xf8f8f8 andAlpha:1.0];
        // 取消点击变暗的效果
        _headerBannerView.adjustsImageWhenHighlighted = NO;
        
        // set frame
        _headerBannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (448.0 / 750.0)*SCREEN_WIDTH);
        _headerBannerView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        
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
        
        NSURL *backgroundImageUrl = [NSURL URLWithString:
                                     self.currentChannelVM.post_btn];
        [_goPsButton setBackgroundImageForState:UIControlStateNormal
                                        withURL:backgroundImageUrl];
        
        [_goPsButton setContentMode:UIViewContentModeScaleAspectFit];
        
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
