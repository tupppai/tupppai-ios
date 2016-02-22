//
//  PIEEliteFollowReplyViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/17.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteFollowViewController.h"
#import "PIEActionSheet_PS.h"
#import "PIEShareView.h"
#import "PIERefreshTableView.h"
//#import "PIEEliteFollowReplyTableViewCell.h"
//#import "PIEEliteFollowAskTableViewCell.h"

#import "PIEEliteAskTableViewCell.h"
#import "PIEEliteReplyTableViewCell.h"

#import "DDCollectManager.h"
#import "DeviceUtil.h"
#import "PIEEliteManager.h"
#import "PIECarouselViewController2.h"
#import "PIEFriendViewController.h"

#import "PIECommentViewController.h"
#import "PIEReplyCollectionViewController.h"
#import "PIEPageDetailViewController.h"

#import "PIEPageManager.h"
/* Variables */
@interface PIEEliteFollowViewController ()
@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *sourceFollow;

@property (nonatomic, strong) PIERefreshTableView *tableFollow;

@property (nonatomic, assign) BOOL isfirstLoadingFollow;

@property (nonatomic, assign) NSInteger currentIndex_follow;

@property (nonatomic, assign) BOOL canRefreshFooterFollow;

@property (nonatomic, assign) long long timeStamp_follow;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath_follow;

@property (nonatomic, strong) PIEPageVM *selectedVM;

@property (nonatomic, strong) PIEActionSheet_PS * psActionSheet;

@property (nonatomic, strong) PIEShareView * shareView;

@end

/* Protocols */
@interface PIEEliteFollowViewController (TableView)
<UITableViewDelegate,UITableViewDataSource>
@end

@interface PIEEliteFollowViewController (PWRefreshBaseTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEEliteFollowViewController (PIEShareView)
<PIEShareViewDelegate>
@end


@interface PIEEliteFollowViewController (JGActionSheet)
<JGActionSheetDelegate>
@end

@implementation PIEEliteFollowViewController

//static  NSString* askIndentifier      = @"PIEEliteFollowAskTableViewCell";
//static  NSString* replyIndentifier    = @"PIEEliteFollowReplyTableViewCell";

static NSString *PIEEliteAskCellIdentifier   = @"PIEEliteAskTableViewCell";
static NSString *PIEEliteReplyCellIdentifier = @"PIEEliteReplyTableViewCell";


#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configData];
    
    [self setupNotificationObserver];
    
    [self configTableViewFollow];
    
//    [self setupGestures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNavigation_Elite_Follow" object:nil];
}

#pragma mark - data setup
- (void)configData {
    _canRefreshFooterFollow = YES;
    
    _currentIndex_follow    = 1;
    
    _isfirstLoadingFollow   = YES;
    
    _sourceFollow           = [NSMutableArray<PIEPageVM *> new];
    
}

#pragma mark - Notification Setup
- (void)setupNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_Elite_Follow" object:nil];
}


#pragma mark - UI components setup
- (void)configTableViewFollow {
    // add as subview and add constraint
    [self.view addSubview:self.tableFollow];
    self.tableFollow.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableFollow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

//- (void)setupGestures {
//    
//    UITapGestureRecognizer* tapGestureFollow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFollow:)];
//    [self.tableFollow addGestureRecognizer:tapGestureFollow];
//   
//    UILongPressGestureRecognizer* longPressGestureFollow = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnFollow:)];
//    [self.tableFollow addGestureRecognizer:longPressGestureFollow];
//    
//}

#pragma mark - Notification Methods
- (void)refreshHeader {
    if (self.tableFollow.mj_header.isRefreshing == false) {
        [self.tableFollow.mj_header beginRefreshing];
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceFollow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PIEPageVM* vm = [_sourceFollow objectAtIndex:indexPath.row];
    
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
    
//    if (vm.type == PIEPageTypeAsk) {
//        PIEEliteFollowAskTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:askIndentifier];
//        [cell injectSauce:vm];
//        return cell;
//    }
//    else {
//        PIEEliteFollowReplyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:replyIndentifier];
//        [cell injectSauce:vm];
//        return cell;
//    }
    
    return nil;
}

#pragma mark - <UITableViewDelegate>
/* Nothing yet. */

#pragma mark - <PIEShareViewDelegate> and its related methods

- (void)showShareView:(PIEPageVM *)pageVM {
    [self.shareView show:pageVM];
}

#pragma mark - fetch data source
- (void)getRemoteSourceFollow {
    WS(ws);
    [self.tableFollow.mj_footer endRefreshing];
    _currentIndex_follow = 1;
    _timeStamp_follow = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_follow) forKey:@"last_updated"];
    
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    
    [PIEEliteManager getMyFollow:param withBlock:^(NSMutableArray *returnArray) {
        ws.isfirstLoadingFollow = NO;
        if (returnArray.count == 0) {
            _canRefreshFooterFollow = NO;
        } else {
            _canRefreshFooterFollow = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageModel *entity in returnArray) {
                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
                [ws.sourceFollow removeAllObjects];
                [ws.sourceFollow addObjectsFromArray:sourceAgent];
            }
        }
        [ws.tableFollow.mj_header endRefreshing];
        [ws.tableFollow reloadData];
    }];
}

- (void)getMoreRemoteSourceFollow {
    [self.tableFollow.mj_header endRefreshing];
    _currentIndex_follow++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_timeStamp_follow) forKey:@"last_updated"];
    
    [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
    
    [param setObject:@(_currentIndex_follow) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    [PIEEliteManager getMyFollow:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count < 15) {
            _canRefreshFooterFollow = NO;
        } else {
            _canRefreshFooterFollow = YES;
        }
        NSMutableArray* sourceAgent = [NSMutableArray new];
        for (PIEPageModel *entity in returnArray) {
            PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
            [sourceAgent addObject:vm];
        }
        [_sourceFollow addObjectsFromArray:sourceAgent];
        [_tableFollow reloadData];
        [_tableFollow.mj_footer endRefreshing];
    }];
}

/** 以下方法设置为Public */
- (void)getSourceIfEmpty_follow:(void (^)(BOOL finished))block {
    if (_isfirstLoadingFollow || _sourceFollow.count <= 0) {
        [self.tableFollow.mj_header beginRefreshing];
    }
}

#pragma mark - <PWRefreshBaseTableViewDelegate>

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getRemoteSourceFollow];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooterFollow) {
        [self getMoreRemoteSourceFollow];
    } else {
        [self.tableFollow.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - <DZNEmptyDataSetSource>
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {

    return [UIImage imageNamed:@"pie_empty"];
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"赶快去关注些大神吧";

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
    if (_isfirstLoadingFollow) {
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
#pragma mark - Gesture Event

- (void)longPressOnFollow:(UILongPressGestureRecognizer *)gesture {
        CGPoint location = [gesture locationInView:self.tableFollow];
        _selectedIndexPath_follow = [self.tableFollow indexPathForRowAtPoint:location];
        _selectedVM = _sourceFollow[_selectedIndexPath_follow.row];
        if (_selectedIndexPath_follow) {
            //关注  求p
            _selectedVM = _sourceFollow[_selectedIndexPath_follow.row];
            
            if (_selectedVM.type == PIEPageTypeAsk) {
                
                PIEEliteFollowAskTableViewCell* cell = [self.tableFollow cellForRowAtIndexPath:_selectedIndexPath_follow];
                CGPoint p = [gesture locationInView:cell];
                if (CGRectContainsPoint(cell.theImageView.frame, p)) {
                    //进入热门详情
                    [self showShareView:_selectedVM];
                }            }
            
            //关注  作品
            else {
                PIEEliteFollowReplyTableViewCell* cell = [self.tableFollow cellForRowAtIndexPath:_selectedIndexPath_follow];
                CGPoint p = [gesture locationInView:cell];
                if (CGRectContainsPoint(cell.animateImageView.frame, p)) {
                    [self showShareView:_selectedVM];
                }      else if (CGRectContainsPoint(cell.likeView.frame, p)) {
                    [_selectedVM love:YES];
                }

            }
        }
    
}

- (void)tapGestureFollow:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.tableFollow];
    _selectedIndexPath_follow = [self.tableFollow indexPathForRowAtPoint:location];

    if (_selectedIndexPath_follow == nil) {
        return;
    }
    _selectedVM = _sourceFollow[_selectedIndexPath_follow.row];
    
    if (_selectedVM == nil) {
        return;
    }
    
    if (_selectedVM.type == PIEPageTypeAsk) {
        
        PIEEliteFollowAskTableViewCell* cell = [self.tableFollow cellForRowAtIndexPath:_selectedIndexPath_follow];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.theImageView.frame, p)) {
            //进入热门详情
            PIECarouselViewController2* vc = [PIECarouselViewController2 new];
            //                    _selectedVM.image = cell.theImageView.image;
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
//                else if (CGRectContainsPoint(cell.followView.frame, p)) {
////                    [self follow:cell.followView];
//                    [_selectedVM follow];
//                }
        else if (CGRectContainsPoint(cell.shareView.frame, p)) {
            [self showShareView:_selectedVM];
        }
        
        else if (CGRectContainsPoint(cell.commentView.frame, p)) {
            PIECommentViewController* vc = [PIECommentViewController new];
            vc.shouldShowHeaderView = NO;
            vc.vm = _selectedVM;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (CGRectContainsPoint(cell.allWorkView.frame, p)) {
            PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
            vc.pageVM = _selectedVM;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    
            //关注  作品
            
    else {
        PIEEliteFollowReplyTableViewCell* cell = [self.tableFollow cellForRowAtIndexPath:_selectedIndexPath_follow];
        CGPoint p = [gesture locationInView:cell];
        if (CGRectContainsPoint(cell.animateImageView.frame, p)) {
            //进入热门详情
//            PIECarouselViewController2* vc = [PIECarouselViewController2 new];
            //                    _selectedVM.image = cell.theImageView.image;
//            vc.pageVM = _selectedVM;
//            [self presentViewController:vc animated:YES completion:nil];
            
            PIEPageDetailViewController *vc2 = [PIEPageDetailViewController new];
            vc2.pageViewModel = _selectedVM;
            [self.navigationController pushViewController:vc2 animated:YES];
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
        else if (CGRectContainsPoint(cell.likeView.frame, p)) {
//                    [PIEPageManager love:cell.likeView viewModel:_selectedVM revert:NO];
            [_selectedVM love:NO];
        }
//                else if (CGRectContainsPoint(cell.followView.frame, p)) {
//                    [_selectedVM follow];
//                }
        else if (CGRectContainsPoint(cell.shareView.frame, p)) {
            [self showShareView:_selectedVM];
        }
//                else if (CGRectContainsPoint(cell.collectView.frame, p)) {
//                    [self collect:cell.collectView shouldShowHud:NO];
//                }
        else if (CGRectContainsPoint(cell.commentView.frame, p)) {
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
    
}
*/

#pragma mark - RAC signal response methods
- (void)tapOnAvatarOrUsernameLabelAtIndexPath:(NSIndexPath *)indexPath
{
    PIEFriendViewController * friendVC = [PIEFriendViewController new];
    friendVC.pageVM = _sourceFollow[indexPath.row];
    
    [self.navigationController pushViewController:friendVC animated:YES];
}

- (void)tapOnFollowButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceFollow[indexPath.row];
    [selectedVM follow];
}

- (void)tapOnCommentPageButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIECommentViewController* vc = [PIECommentViewController new];
    vc.vm = _sourceFollow[indexPath.row];
    vc.shouldShowHeaderView = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapOnSharePageButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceFollow[indexPath.row];
    [self showShareView:selectedVM];
}

- (void)tapOnImageViewAtIndexPath:(NSIndexPath *)indexPath
{
    
    PIEPageVM *selectedVM          = _sourceFollow[indexPath.row];
    //    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
    //    vc.pageVM                      = selectedVM;
    //    [self presentViewController:vc animated:YES completion:nil];
    
    PIEPageDetailViewController *vc2 = [PIEPageDetailViewController new];
    vc2.pageViewModel = selectedVM;
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (void)longPressOnImageViewAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceFollow[indexPath.row];
    [self showShareView:selectedVM];
}

- (void)tapOnAllworkButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceFollow[indexPath.row];
    PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
    vc.pageVM = selectedVM;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapOnBangIconAtIndexPath:(NSIndexPath *)indexPath
{
    [Hud text:@"BANG!"];
}

- (void)tapOnLikePageButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceFollow[indexPath.row];
    [selectedVM love:NO];
}

- (void)longPressOnLikePageButtonAtIndexPath:(NSIndexPath *)indexPath
{
    PIEPageVM *selectedVM = _sourceFollow[indexPath.row];
    [selectedVM love:YES];
}

#pragma mark - Lazy loadings
- (PIERefreshTableView *)tableFollow
{
    if (_tableFollow == nil) {
        _tableFollow = [[PIERefreshTableView alloc] init];
        
        _tableFollow.dataSource           = self;
        _tableFollow.delegate             = self;
        _tableFollow.psDelegate           = self;
        _tableFollow.emptyDataSetSource   = self;
        _tableFollow.emptyDataSetDelegate = self;
        
        
        _tableFollow.estimatedRowHeight   = SCREEN_WIDTH+155;
        _tableFollow.rowHeight            = UITableViewAutomaticDimension;
        
        
//        UINib* nib2 = [UINib nibWithNibName:askIndentifier bundle:nil];
//        [self.tableFollow registerNib:nib2 forCellReuseIdentifier:askIndentifier];
//        UINib* nib3 = [UINib nibWithNibName:replyIndentifier bundle:nil];
//        [self.tableFollow registerNib:nib3 forCellReuseIdentifier:replyIndentifier];
        
        UINib *askCellNib =
        [UINib nibWithNibName:@"PIEEliteAskTableViewCell" bundle:nil];
        
        UINib *replyCellNib =
        [UINib nibWithNibName:@"PIEEliteReplyTableViewCell" bundle:nil];
        
        [_tableFollow registerNib:askCellNib
        forCellReuseIdentifier:PIEEliteAskCellIdentifier];
        
        [_tableFollow registerNib:replyCellNib
        forCellReuseIdentifier:PIEEliteReplyCellIdentifier];
        
    }
    
    return _tableFollow;
}


-(PIEActionSheet_PS *)psActionSheet {
    if (!_psActionSheet) {
        _psActionSheet = [PIEActionSheet_PS new];
    }
    return _psActionSheet;
}

-(PIEShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}
@end
