//
//  PIEEliteHotReplyViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/17.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteHotViewController.h"
#import "PIEActionSheet_PS.h"
#import "PIEShareView.h"
#import "SwipeView.h"
#import "PIEBannerModel.h"
#import "PIERefreshTableView.h"
#import "PIEWebViewViewController.h"
#import "SMPageControl.h"
//#import "PIEEliteHotReplyTableViewCell.h"
//#import "PIEEliteHotAskTableViewCell.h"

#import "PIEEliteAskTableViewCell.h"
#import "PIEEliteReplyTableViewCell.h"

//#import "DeviceUtil.h"
#import "PIEEliteManager.h"
//#import "PIECarouselViewController2.h"
#import "PIEFriendViewController.h"

#import "PIECommentViewController.h"
#import "PIEReplyCollectionViewController.h"
#import "PIEPageManager.h"
#import "PIEPageDetailViewController.h"

#define kEliteHotCellLimitedCacheCount 4

@interface PIEEliteHotViewController ()

@property (nonatomic, strong) PIERefreshTableView *tableHot;

@property (nonatomic, strong) SwipeView *swipeView;

@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *sourceHot;

@property (nonatomic, strong) NSMutableArray<PIEBannerModel *> *sourceBanner;

@property (nonatomic, assign) BOOL isfirstLoadingHot;

@property (nonatomic, assign) NSInteger currentIndex_hot;

@property (nonatomic, assign) BOOL canRefreshFooterHot;

@property (nonatomic, assign) long long timeStamp_hot;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath_hot;

@property (nonatomic, strong) PIEActionSheet_PS * psActionSheet;

@property (nonatomic, strong) PIEShareView * shareView;

@property (nonatomic, strong) PIEPageVM *selectedVM;

@property (nonatomic, strong) SMPageControl *pageControl_swipeView;

@property (nonatomic, copy) NSArray<NSManagedObject *> *pageManagedObjects;

@property (nonatomic, copy) NSArray<NSManagedObject *> *bannerManagedObjects;

@end

/* Protocols */
@interface PIEEliteHotViewController (TableView)
<UITableViewDelegate,UITableViewDataSource>
@end

@interface PIEEliteHotViewController (RefreshBaseTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEEliteHotViewController (PIEShareView)
<PIEShareViewDelegate>
@end

@interface PIEEliteHotViewController (SwipeView)
<SwipeViewDelegate,SwipeViewDataSource>
@end


@implementation PIEEliteHotViewController

static  NSString *PIEEliteAskCellIdentifier   = @"PIEEliteAskTableViewCell";
static  NSString *PIEEliteReplyCellIdentifier = @"PIEEliteReplyTableViewCell";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupNotificationObserver];
    
    [self configTableViewHot];
    
    [self getSourceIfEmpty_hot:nil];
    
   
    [self configureSwipeView];

    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchPageModelsFromDatabase];
    [self fetchBannerModelsFromDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNavigation_Elite_Hot" object:nil];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - Core data methods

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)renewPageModelInManagedContext:(NSArray*)array {
    [self clearPagesInDatabase];
    
    unsigned long minimumIterateCount = MIN(array.count, kEliteHotCellLimitedCacheCount);
    
    for (int i = 0; i < minimumIterateCount; i++) {
        PIEPageVM *vm = [array objectAtIndex:i];
        [self addPageModelToManagedContext:vm.model];
    }
}

- (void)renewBannerModelInManagedContext:(NSArray *)array
{
    [self clearBannersInDatabase];
    
    for (PIEBannerModel *bannerModel in array) {
        [self addBannerModelToManagedContext:bannerModel];
    }
}

- (void)addPageModelToManagedContext:(PIEPageModel*)model {
    NSManagedObjectContext *context = [self managedObjectContext];
    // Create a new managed object
    NSManagedObject *newPage = [NSEntityDescription insertNewObjectForEntityForName:@"Page" inManagedObjectContext:context];
    [newPage setValue:@(model.ID) forKey:@"id"];
    [newPage setValue:@(model.uid) forKey:@"user_id"];
    [newPage setValue:model.nickname forKey:@"username"];
    [newPage setValue:model.imageURL forKey:@"page_url"];
    [newPage setValue:model.avatar forKey:@"avatar_url"];
    [newPage setValue:@(model.type) forKey:@"type"];
    [context save:nil];
}

- (void)addBannerModelToManagedContext:(PIEBannerModel *)model
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newBanner = [NSEntityDescription insertNewObjectForEntityForName:@"Banner"
                                                               inManagedObjectContext:context];
    [newBanner setValue:@(model.ID) forKey:@"id"];
    [newBanner setValue:model.desc forKey:@"desc"];
    [newBanner setValue:model.url  forKey:@"url"];
    [newBanner setValue:model.imageUrl forKey:@"imageUrl"];
    [context save:nil];
}

- (void)fetchPageModelsFromDatabase {
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Page"];
    
    fetchRequest.fetchLimit = kEliteHotCellLimitedCacheCount;
    
    NSArray *pages = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.pageManagedObjects = pages;
    for (NSManagedObject *object in pages) {
        PIEPageModel *model = [PIEPageModel new];
        model.ID            = [[object valueForKey:@"id"]integerValue];
        model.uid           = [[object valueForKey:@"user_id"]integerValue];
        model.nickname      = [object valueForKey:@"username"];
        model.avatar        = [object valueForKey:@"avatar_url"];
        model.imageURL      = [object valueForKey:@"page_url"];
        model.type          = [[object valueForKey:@"type"]integerValue];

        PIEPageVM *vm       = [[PIEPageVM alloc]initWithPageEntity:model];
        
        // TODO: 这里self.sourceHot已经绑定了RAC， 一旦sourceHot有改变就会reload一次tableView；
        //       这里有可能会造成不必要的性能损耗（每次显示页面CPU都会有一次尖峰，导致卡顿）
        [self.sourceHot addObject:vm];
    }
    [self.tableHot reloadData];
}

- (void)fetchBannerModelsFromDatabase
{
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Banner"];
    
    NSArray *banners =
    [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.bannerManagedObjects = banners;
    
    for (NSManagedObject *bannerObject in banners) {
        PIEBannerModel *bannerModel = [PIEBannerModel new];
        bannerModel.ID              = [[bannerObject valueForKey:@"id"] integerValue];
        bannerModel.url             = [bannerObject valueForKey:@"url"];
        bannerModel.imageUrl        = [bannerObject valueForKey:@"imageUrl"];
        bannerModel.desc            = [bannerObject valueForKey:@"desc"];
        
        [self.sourceBanner addObject:bannerModel];
    }
    
    [self.swipeView reloadData];
}

- (void)clearPagesInDatabase {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    for (NSManagedObject *page in self.pageManagedObjects) {
        [context deleteObject:page];
    }
    [context save:nil];
}

- (void)clearBannersInDatabase
{
    NSManagedObjectContext *context = [self managedObjectContext];
    for (NSManagedObject *banner in self.bannerManagedObjects) {
        [context deleteObject:banner];
    }
    [context save:nil];
}

#pragma mark - data setup

- (void)configData {
    _canRefreshFooterHot    = YES;
    
    _currentIndex_hot       = 1;
    
    _isfirstLoadingHot      = YES;
    
    _sourceHot              = [NSMutableArray<PIEPageVM *> new];
    
    [[RACObserve(self, sourceHot)
      filter:^BOOL(id value) {
          NSArray *array = value;
          return array.count>0;
      }]
     subscribeNext:^(id x) {
         [self.tableHot reloadData];
     }];
}

#pragma mark - Notification setup
- (void)setupNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_Elite_Hot" object:nil];    

}

#pragma mark - UI components setup

- (void)configTableViewHot {
    
    // add as subview, then add constraints
    [self.view addSubview:self.tableHot];
    self.tableHot.separatorStyle = UITableViewCellSeparatorStyleNone;

    __weak typeof(self) weakSelf = self;
    [self.tableHot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];

    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
}

- (void)configureSwipeView{
    
}



#pragma mark - <SwipeViewDataSource>
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.sourceBanner.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        CGFloat width = self.swipeView.frame.size.width;
        CGFloat height = self.swipeView.frame.size.height;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    PIEBannerModel* vm = [self.sourceBanner objectAtIndex:index];
    for (UIView *subView in view.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)subView;
            [imageView sd_setImageWithURL:[NSURL URLWithString:vm.imageUrl]];
        }
    }

    return view;
}

#pragma mark - <SwipeViewDelegate>
-(void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    _pageControl_swipeView.currentPage = swipeView.currentItemIndex;
}

-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    PIEWebViewViewController* vc = [PIEWebViewViewController new];
    vc.viewModel = [self.sourceBanner objectAtIndex:index];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceHot.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIEPageVM* vm = [_sourceHot objectAtIndex:indexPath.row];
    if (vm.type == PIEPageTypeAsk) {
        // 类型一：求P
        PIEEliteAskTableViewCell *askCell =
        [tableView dequeueReusableCellWithIdentifier:PIEEliteAskCellIdentifier];
        
        [askCell bindVM:vm];
        
        // begin RAC binding
        @weakify(self);
        [askCell.tapOnUserSignal subscribeNext:^(id x) {
            @strongify(self);
            [self tapOnAvatarOrUsernameLabelAtIndexPath:indexPath];
        }];
        
        [askCell.tapOnFollowButtonSignal
         subscribeNext:^(UITapGestureRecognizer *tap) {
             @strongify(self);
             [self tapOnFollowButtonAtIndexPath:indexPath];
             tap.view.hidden = YES;
        }];
        
        [askCell.tapOnImageSignal
         subscribeNext:^(id x) {
             @strongify(self);
             [self tapOnImageViewAtIndexPath:indexPath];
         }];
        
        [askCell.longPressOnImageSignal
         subscribeNext:^(id x) {
             @strongify(self);
             [self longPressOnImageViewAtIndexPath:indexPath];
         }];
        
        [askCell.tapOnCommentSignal
         subscribeNext:^(id x) {
             @strongify(self);
             [self tapOnCommentPageButtonAtIndexPath:indexPath];
         }];
        
        [askCell.tapOnShareSignal
         subscribeNext:^(id x) {
             @strongify(self);
             [self tapOnSharePageButtonAtIndexPath:indexPath];
         }];
        
        [askCell.tapOnRelatedWorkSignal
         subscribeNext:^(id x) {
             @strongify(self);
             [self tapOnAllworkButtonAtIndexPath:indexPath];
         }];
        
        [askCell.tapOnBangSignal
         subscribeNext:^(id x) {
             @strongify(self);
             [self tapOnBangIconAtIndexPath:indexPath];
         }];
        
        // --- end of RAC binding
        
        return askCell;
    }
    else if (vm.type == PIEPageTypeReply){
        PIEEliteReplyTableViewCell *replyCell =
        [tableView dequeueReusableCellWithIdentifier:PIEEliteReplyCellIdentifier];
        
        [replyCell bindVM:vm];
        
        
        if (vm.askID == 0) {
            // 类型三：动态（像朋友圈那样，只是发一张图片而已）
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
             [self tapOnAvatarOrUsernameLabelAtIndexPath:indexPath];
        }];
        
        [replyCell.tapOnFollowButtonSignal
         subscribeNext:^(UITapGestureRecognizer *tap) {
             @strongify(self);
             [self tapOnFollowButtonAtIndexPath:indexPath];
             
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
             [self tapOnCommentPageButtonAtIndexPath:indexPath];
         }];
        
        [replyCell.tapOnShareSignal
         subscribeNext:^(id x) {
             @strongify(self);
             [self tapOnSharePageButtonAtIndexPath:indexPath];
         }];
        
        [replyCell.tapOnLoveSignal
         subscribeNext:^(id x) {
             @strongify(self);
             [self tapOnLikePageButtonAtIndexPath:indexPath];
         }];
        
        [replyCell.longPressOnLoveSignal
         subscribeNext:^(id x) {
             @strongify(self);
             [self longPressOnLikePageButtonAtIndexPath:indexPath];
         }];
        
        [replyCell.tapOnRelatedWorkSignal
         subscribeNext:^(id x) {
             @strongify(self);
             [self tapOnAllworkButtonAtIndexPath:indexPath];
         }];
        
        // --- end of RAC binding
        
        return replyCell;
    }
    
    
    return nil;
}



#pragma mark - <PIEShareViewDelegate> and its related methods


- (void)shareViewDidCancel:(PIEShareView *)shareView
{
    [shareView dismiss];
}


/** 分享当前pageVM对应的图片 */
- (void)showShareView:(PIEPageVM *)pageVM {
    [self.shareView show:pageVM];
}


#pragma mark - <PWRefreshBaseTableViewDelegate>
-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getRemoteSourceHot:nil];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooterHot) {
        [self getMoreRemoteSourceHot];
    } else {
        [Hud text:@"已经拉到底啦"];
        [self.tableHot.mj_footer endRefreshingWithNoMoreData];
    }

}

#pragma mark - <DZNEmptyDataSetSource> 

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"好伤心，再下拉刷新试试";
   
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 100;
}

#pragma mark - <DZNEmptyDataSetDelegate>

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    /* 如果是第一次加载数据之前，那么即使数据源为空也不要显示emptyDataSet */
    if (_isfirstLoadingHot) {
        return NO;
    }
    else{
        return YES;
    }
    

}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

/*
#pragma mark - Gesture events
- (void)longPressOnHot:(UILongPressGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.tableHot];
    _selectedIndexPath_hot = [self.tableHot indexPathForRowAtPoint:location];
    if (_selectedIndexPath_hot) {
        //关注  求p
        _selectedVM = _sourceHot[_selectedIndexPath_hot.row];
        
        if (_selectedVM.type == PIEPageTypeAsk) {
            
            PIEEliteHotAskTableViewCell* cell = [self.tableHot cellForRowAtIndexPath:_selectedIndexPath_hot];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                [self showShareView:_selectedVM];
            }          // 点赞
        }
        //关注  作品
        
        else {
//            PIEEliteHotReplyTableViewCell* cell = [self.tableHot cellForRowAtIndexPath:_selectedIndexPath_hot];
//            CGPoint p = [gesture locationInView:cell];
//            //点击大图
//            if (CGRectContainsPoint(cell.blurAnimateView.frame, p)) {
//                [self showShareView:_selectedVM];
//            }
//            else if (CGRectContainsPoint(cell.likeView.frame, p)) {
//                [_selectedVM love:YES];
//            }
        }
    }
}

- (void)tapGestureHot:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.tableHot];
    _selectedIndexPath_hot = [self.tableHot indexPathForRowAtPoint:location];
    
    if (_selectedIndexPath_hot == nil) {
        return;
    }
    _selectedVM = _sourceHot[_selectedIndexPath_hot.row];
    
    if (_selectedVM == nil) {
        return;
    }
    
    if (_selectedVM.type == PIEPageTypeAsk) {
        
        PIEEliteHotAskTableViewCell* cell = [self.tableHot cellForRowAtIndexPath:_selectedIndexPath_hot];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.theImageView.frame, p)) {
            //进入热门详情
            PIECarouselViewController2* vc = [PIECarouselViewController2 new];
            vc.pageVM = _selectedVM;
            [self presentViewController:vc animated:YES completion:nil];
            
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
        else if (CGRectContainsPoint(cell.bangView.frame, p)) {
            self.psActionSheet.vm = _selectedVM;
            [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
        }
        else if (CGRectContainsPoint(cell.followView.frame, p)) {
            [_selectedVM follow];
        }
        else if (CGRectContainsPoint(cell.shareView.frame, p)) {
            [self showShareView:_selectedVM];
        }
        
        else if ((CGRectContainsPoint(cell.commentView.frame, p))||(CGRectContainsPoint(cell.commentLabel1.frame, p))||(CGRectContainsPoint(cell.commentLabel2.frame, p)) ) {
            PIECommentViewController* vc = [PIECommentViewController new];
            vc.vm = _selectedVM;
            vc.shouldShowHeaderView = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (CGRectContainsPoint(cell.allWorkView.frame, p)) {
            PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
            vc.pageVM = _selectedVM;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
            else {
//                PIEEliteHotReplyTableViewCell* cell = [self.tableHot cellForRowAtIndexPath:_selectedIndexPath_hot];
//                CGPoint p = [gesture locationInView:cell];
//                //点击小图
//                if (CGRectContainsPoint(cell.blurAnimateView.frame, p)) {
//                    CGPoint pp = [gesture locationInView:cell.blurAnimateView.thumbView];
//                    if (CGRectContainsPoint(cell.blurAnimateView.thumbView.leftView.frame,pp)) {
//                        [cell animateWithType:PIEThumbAnimateViewTypeLeft];
//                    }
//                    
//                    else if (CGRectContainsPoint(cell.blurAnimateView.thumbView.rightView.frame,pp)) {
//                        [cell animateWithType:PIEThumbAnimateViewTypeRight];
//                    }
//                    
//                    else  if (CGRectContainsPoint(cell.blurAnimateView.imageView.frame, p)) {
//                        PIECarouselViewController2* vc = [PIECarouselViewController2 new];
//                        vc.pageVM = _selectedVM;
//                        [self presentViewController:vc animated:YES completion:nil];
//                    }
//                }
              
//                //点击头像
//                else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
//                    PIEFriendViewController * friendVC = [PIEFriendViewController new];
//                    friendVC.pageVM = _selectedVM;
//                    [self.navigationController pushViewController:friendVC animated:YES];
//                }
//                //点击用户名
//                else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
//                    PIEFriendViewController * friendVC = [PIEFriendViewController new];
//                    friendVC.pageVM = _selectedVM;
//                    [self.navigationController pushViewController:friendVC animated:YES];
//                }
//                // 点赞
//                else if (CGRectContainsPoint(cell.likeView.frame, p)) {
//                    [_selectedVM love:NO];
//                }
//                // 关注
//                else if (CGRectContainsPoint(cell.followView.frame, p)) {
//                    [_selectedVM follow];
//                }
                // 分享
//                else if (CGRectContainsPoint(cell.shareView.frame, p)) {
//                    [self showShareView:_selectedVM];
//                }
//                // 评论
//                else if ((CGRectContainsPoint(cell.commentView.frame, p))||(CGRectContainsPoint(cell.commentLabel1.frame, p))||(CGRectContainsPoint(cell.commentLabel2.frame, p)) ) {                    PIECommentViewController* vc = [PIECommentViewController new];
//                    vc.vm = _selectedVM;
//                    vc.shouldShowHeaderView = NO;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                 全部作品
//                else if (CGRectContainsPoint(cell.allWorkView.frame, p)) {
//                    PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
//                    vc.pageVM = _selectedVM;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
            }
}
*/


#pragma mark - Notification methods

- (void)refreshHeader {
    if (self.tableHot.mj_header.isRefreshing == false) {
        [self.tableHot.mj_header beginRefreshing];
    }
}


#pragma mark - target-actions
- (void) onTimer
{
    [self.swipeView scrollByNumberOfItems:1 duration:0.5];
}

#pragma mark - Fetch _source data
- (void)getRemoteSourceBanner {
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    
    [PIEEliteManager getBannerSource:param withBlock:^(NSMutableArray *array) {
        [self.sourceBanner removeAllObjects];
        [self.sourceBanner addObjectsFromArray:array];
        
        _pageControl_swipeView.numberOfPages = self.sourceBanner.count;
        
        [self renewBannerModelInManagedContext:array];
        
        [self.swipeView reloadData];
 

    }];
}

/** getSourceIfEmpty_xxx : 以下两个方法是public 方法 */
- (void)getSourceIfEmpty_banner {
    if (self.sourceBanner.count <= 0) {
        [self getRemoteSourceBanner];
    }
}

- (void)getSourceIfEmpty_hot:(void (^)(BOOL finished))block {
    if (_isfirstLoadingHot || _sourceHot.count <= 0) {
        [self.tableHot.mj_header beginRefreshing];
    }
}

- (void)getRemoteSourceHot:(void (^)(BOOL finished))block {
    
    [self.tableHot.mj_footer endRefreshing];
    _currentIndex_hot = 1;
    _timeStamp_hot = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_hot) forKey:@"last_updated"];
    
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];

    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(8) forKey:@"size"];
    
    [PIEEliteManager getHotPages:param withBlock:^(NSMutableArray *returnArray) {
        self.isfirstLoadingHot = NO;
        if (returnArray.count == 0) {
            _canRefreshFooterHot = NO;
        } else {
            _canRefreshFooterHot = YES;
            [self.sourceHot removeAllObjects];
            
            NSMutableArray *fromKVC = [self mutableArrayValueForKey:@"sourceHot"];
            [fromKVC addObjectsFromArray:returnArray];
            
            [self renewPageModelInManagedContext:returnArray];
        }
        [self.tableHot.mj_header endRefreshing];
        if (block) {
            block(YES);
        }
        
//        [self getSourceIfEmpty_banner];
        [self getRemoteSourceBanner];

    }];
    
}

- (void)getMoreRemoteSourceHot {
    [self.tableHot.mj_header endRefreshing];
    _currentIndex_hot ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_hot) forKey:@"last_updated"];
    
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    
    [param setObject:@(_currentIndex_hot) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    
    [PIEEliteManager getHotPages:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count < 15) {
            _canRefreshFooterHot = NO;
        } else {
            _canRefreshFooterHot = YES;
        }
        
        // TODO： 试试不用KVC看看怎样
        NSMutableArray *fromKVC = [self mutableArrayValueForKey:@"sourceHot"];
        [fromKVC addObjectsFromArray:returnArray];
        [self.tableHot.mj_footer endRefreshing];
    }];
}

#pragma mark - RAC signal response methods
- (void)tapOnAvatarOrUsernameLabelAtIndexPath:(NSIndexPath *)indexPath
{
    PIEFriendViewController * friendVC = [PIEFriendViewController new];
    friendVC.pageVM = _sourceHot[indexPath.row];
    
    [self.navigationController pushViewController:friendVC animated:YES];
}

- (void)tapOnFollowButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceHot[indexPath.row];
    [selectedVM follow];
}

- (void)tapOnCommentPageButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIECommentViewController* vc = [PIECommentViewController new];
    vc.vm = _sourceHot[indexPath.row];
    vc.shouldShowHeaderView = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapOnSharePageButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceHot[indexPath.row];
    [self showShareView:selectedVM];
}

- (void)tapOnImageViewAtIndexPath:(NSIndexPath *)indexPath
{
    
    PIEPageVM *selectedVM          = _sourceHot[indexPath.row];
//    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
//    vc.pageVM                      = selectedVM;
    //    [self presentViewController:vc animated:YES completion:nil];

    PIEPageDetailViewController *vc2 = [PIEPageDetailViewController new];
    vc2.pageViewModel = selectedVM;
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (void)longPressOnImageViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceHot[indexPath.row];
    [self showShareView:selectedVM];
}

- (void)tapOnAllworkButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceHot[indexPath.row];
    PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
    vc.pageVM = selectedVM;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapOnBangIconAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceHot[indexPath.row];
    self.psActionSheet.vm = selectedVM;
    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
}

- (void)tapOnLikePageButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceHot[indexPath.row];
    [selectedVM love:NO];
}

- (void)longPressOnLikePageButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceHot[indexPath.row];
    [selectedVM love:YES];
}

#pragma mark - Lazy loadings

- (PIERefreshTableView *)tableHot
{
    if (_tableHot == nil) {
        _tableHot = [[PIERefreshTableView alloc] init];
        _tableHot.dataSource           = self;
        _tableHot.delegate             = self;
        _tableHot.psDelegate           = self;
        _tableHot.emptyDataSetDelegate = self;
        _tableHot.emptyDataSetSource   = self;

        _tableHot.estimatedRowHeight   = SCREEN_WIDTH+225;
        _tableHot.rowHeight            = UITableViewAutomaticDimension;

        _tableHot.tableHeaderView      = self.swipeView;

        UINib *askCellNib =
        [UINib nibWithNibName:@"PIEEliteAskTableViewCell" bundle:nil];
        
        UINib *replyCellNib =
        [UINib nibWithNibName:@"PIEEliteReplyTableViewCell" bundle:nil];
        
        [_tableHot registerNib:askCellNib
        forCellReuseIdentifier:PIEEliteAskCellIdentifier];
        
        [_tableHot registerNib:replyCellNib
        forCellReuseIdentifier:PIEEliteReplyCellIdentifier];
    }
    
    return _tableHot;
}

- (SwipeView *)swipeView
{
    if (_swipeView == nil) {
        _swipeView = [[SwipeView alloc] init];
        
        NSInteger height = 333.0/750 * SCREEN_WIDTH;
        _swipeView =
        [[SwipeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        _swipeView.backgroundColor = [UIColor clearColor];
        _swipeView.wrapEnabled = YES;
        
        
        [_swipeView addSubview:self.pageControl_swipeView];
        
        CGPoint center = self.pageControl_swipeView.center;
        
        center.x = _swipeView.center.x;
        center.y = _swipeView.center.y+55;
        self.pageControl_swipeView.center = center;
        
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    
    return _swipeView;
}

-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEShareView new];
        _shareView.delegate = self;
        
    }
    return _shareView;
}

-(PIEActionSheet_PS *)psActionSheet {
    if (!_psActionSheet) {
        _psActionSheet = [PIEActionSheet_PS new];
    }
    return _psActionSheet;
}

- (SMPageControl *)pageControl_swipeView
{
    if (_pageControl_swipeView == nil) {
        _pageControl_swipeView =
        [[SMPageControl alloc]initWithFrame:CGRectMake(0,0, 200, 20)];
    }
    
    return _pageControl_swipeView;
}

- (NSMutableArray<PIEBannerModel *> *)sourceBanner
{
    if (_sourceBanner == nil) {
        _sourceBanner = [NSMutableArray<PIEBannerModel *> array];
    }
    
    return _sourceBanner;
}


@end
