//
//  PIEChannelActivityViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/11.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelActivityViewController.h"
#import "PIERefreshTableView.h"
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
#import "PIEEliteReplyTableViewCell.h"
/* Variables */
@interface PIEChannelActivityViewController ()<LeesinViewControllerDelegate>

/*Views*/
@property (nonatomic, strong) PIERefreshTableView *tableView;
@property (nonatomic, strong) UIButton            *goPsButton;

/** image from currentChannelVM */
@property (nonatomic, strong) UIButton            *headerBannerView;

/*ViewModels*/
@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *source_reply;

/* HTTP Request parameter */
@property (nonatomic, assign) long long timeStamp;

/* ======= */

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


static  NSString *PIEEliteReplyCellIdentifier = @"PIEEliteReplyTableViewCell";

static NSString *
PIEChannelActivityNormalCellIdentifier = @"PIEChannelActivityNormalCellIdentifier";


#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = [NSString stringWithFormat:
                  @"#%@", self.currentChannelVM.title];
    
    [self setupData];
    [self configureTableView];
    [self configureGoPsButton];
    
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
    PIEEliteReplyTableViewCell *replyCell =
    [tableView dequeueReusableCellWithIdentifier:PIEEliteReplyCellIdentifier];
    
    PIEPageVM *viewModel = _source_reply[indexPath.row];
    
    [replyCell bindVM:viewModel];
    
    /*去掉ChannelActivity中的cell的“其它作品”按钮*/
    [replyCell setAllWorkButtonHidden:YES];
    
    // Begin RAC Binding
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

#pragma mark - Network request
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
    PIECarouselViewController2 *carouselVC = [PIECarouselViewController2 new];
    carouselVC.pageVM = selectedVM;
    
    [self presentViewController:carouselVC animated:YES completion:nil];
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
        UINib *replyCellNib =
        [UINib nibWithNibName:@"PIEEliteReplyTableViewCell" bundle:nil];
        [_tableView registerNib:replyCellNib
         forCellReuseIdentifier:PIEEliteReplyCellIdentifier];
        
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
        [manager downloadImageWithURL:bannerImageUrl
                              options:SDWebImageAllowInvalidSSLCertificates
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
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
        _shareView = [[PIEShareView alloc] init];
//        _shareView.delegate = self;
    }
    return  _shareView;
}


@end
