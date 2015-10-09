//
//  PIEFollowViewController.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/20/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteViewController.h"
#import "PIEEliteScrollView.h"
#import "HMSegmentedControl.h"
#import "PIEEliteFollowTableViewCell.h"
#import "PIEEliteHotTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PIEEliteManager.h"
#import "PIEReplyCarouselViewController.h"
#import "PIEFriendViewController.h"
#import "DDCommentVC.h"
#import "DDCollectManager.h"
#import "PIEShareFunctionView.h"
#import "PIEReplyCollectionViewController.h"
#import "JGActionSheet.h"
#import "AppDelegate.h"
#import "ATOMReportModel.h"
#import "DDInviteVC.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

static  NSString* indentifier1 = @"PIEEliteFollowTableViewCell";
static  NSString* indentifier2 = @"PIEEliteHotTableViewCell";

@interface PIEEliteViewController ()<UITableViewDelegate,UITableViewDataSource,PWRefreshBaseTableViewDelegate,UIScrollViewDelegate,PIEShareFunctionViewDelegate,JGActionSheetDelegate>
@property (nonatomic, strong) PIEEliteScrollView *sv;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *sourceFollow;
@property (nonatomic, strong) NSMutableArray *sourceHot;

@property (nonatomic, assign) NSInteger currentIndex_follow;
@property (nonatomic, assign) NSInteger currentIndex_hot;

@property (nonatomic, assign) BOOL canRefreshFooterFollow;
@property (nonatomic, assign) BOOL canRefreshFooterHot;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureHot;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureFollow;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) PIEEliteFollowTableViewCell *selectedFollowCell;
@property (nonatomic, strong) PIEEliteHotTableViewCell *selectedHotCell;
@property (nonatomic, strong) DDPageVM *selectedVM;

@property (nonatomic, strong) PIEShareFunctionView *shareFunctionView;
@property (nonatomic, strong)  JGActionSheet * psActionSheet;
@property (nonatomic, strong)  JGActionSheet * reportActionSheet;

@end

@implementation PIEEliteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    [self createNavBar];
    [self configSubviews];
    [self getRemoteSourceHot:^(BOOL finished) {
        if (finished) {
            [self getRemoteSourceFollow];
        }
    }];

}

#pragma mark - init methods

- (void)configData {
    _canRefreshFooterFollow = YES;
    _canRefreshFooterHot = YES;

    _currentIndex_follow = 1;
    _currentIndex_hot = 1;
    
    _sourceFollow = [NSMutableArray new];
    _sourceHot = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_Elite" object:nil];
}
- (void)configSubviews {
    self.view = self.sv;
    [self configTableViewFollow];
    [self configTableViewHot];
}
- (void)configTableViewFollow {
    _sv.tableFollow.dataSource = self;
    _sv.tableFollow.delegate = self;
    _sv.tableFollow.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:indentifier1 bundle:nil];
    [_sv.tableFollow registerNib:nib forCellReuseIdentifier:indentifier1];
    _tapGestureFollow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFollow:)];
    [_sv.tableFollow addGestureRecognizer:_tapGestureFollow];
}

- (void)configTableViewHot {
    _sv.tableHot.dataSource = self;
    _sv.tableHot.delegate = self;
    _sv.tableHot.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:indentifier2 bundle:nil];
    [_sv.tableHot registerNib:nib forCellReuseIdentifier:indentifier2];
    _tapGestureHot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHot:)];
    [_sv.tableHot addGestureRecognizer:_tapGestureHot];
}
- (void)createNavBar {
    WS(ws);
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"热门",@"关注"]];
    _segmentedControl.frame = CGRectMake(0, 120, SCREEN_WIDTH-100, 45);
    _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -5, 0);
    _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentedControl.backgroundColor = [UIColor clearColor];

    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (index == 0) {
            [ws.sv toggleWithType:PIEPageTypeEliteHot];
        }
        else {
            [ws.sv toggleWithType:PIEPageTypeEliteFollow];
        }
    }];
    
    self.navigationItem.titleView = _segmentedControl;
    
}
- (void)refreshHeader {
    if (_sv.type == PIEPageTypeEliteFollow && ![_sv.tableFollow.header isRefreshing]) {
        [_sv.tableFollow.header beginRefreshing];
    } else if (_sv.type == PIEPageTypeEliteHot && ![_sv.tableHot.header isRefreshing]) {
        [_sv.tableHot.header beginRefreshing];
    }
}

#pragma mark - Getters and Setters

-(PIEEliteScrollView*)sv {
    if (!_sv) {
        _sv = [PIEEliteScrollView new];
        _sv.delegate =self;
    }
    return _sv;
}
#pragma mark - UITableView Datasource and delegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _sv.tableFollow) {
        return _sourceFollow.count;
    } else if (tableView == _sv.tableHot) {
        return _sourceHot.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _sv.tableFollow) {
        PIEEliteFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if (!cell) {
            cell = [[PIEEliteFollowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier1];
        }
        [cell injectSauce:[_sourceFollow objectAtIndex:indexPath.row]];
        return cell;
    } else if (tableView == _sv.tableHot) {
        PIEEliteHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
        if (!cell) {
            cell = [[PIEEliteHotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier2];
        }
        [cell injectSauce:[_sourceHot objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _sv.tableFollow) {
        return [tableView fd_heightForCellWithIdentifier:indentifier1  cacheByIndexPath:indexPath configuration:^(PIEEliteFollowTableViewCell *cell) {
            [cell injectSauce:[_sourceFollow objectAtIndex:indexPath.row]];
        }];
    } else if (tableView == _sv.tableHot) {
        return [tableView fd_heightForCellWithIdentifier:indentifier2  cacheByIndexPath:indexPath configuration:^(PIEEliteHotTableViewCell *cell) {
            [cell injectSauce:[_sourceHot objectAtIndex:indexPath.row]];
        }];
    } else {
        return 0;
    }
}

#pragma mark - Gesture Event


- (void)tapGestureFollow:(UITapGestureRecognizer *)gesture {
    NSLog(@"tapGestureFollow");
    if (_sv.type == PIEPageTypeEliteFollow) {
        NSLog(@"tapGestureFollow2");

        CGPoint location = [gesture locationInView:_sv.tableFollow];
        _selectedIndexPath = [_sv.tableFollow indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            _selectedFollowCell = [_sv.tableFollow cellForRowAtIndexPath:_selectedIndexPath];
            _selectedVM = _sourceFollow[_selectedIndexPath.row];
            CGPoint p = [gesture locationInView:_selectedFollowCell];
            
            //点击小图
            if (CGRectContainsPoint(_selectedFollowCell.thumbView.frame, p)) {
                NSLog(@"tapGestureFollow3");

                [_selectedFollowCell animateToggleExpanded];
            }
            //点击大图
            else  if (CGRectContainsPoint(_selectedFollowCell.theImageView.frame, p)) {
                //进入热门详情
                PIEReplyCarouselViewController* vc = [PIEReplyCarouselViewController new];
                _selectedVM.image = _selectedFollowCell.theImageView.image;
                vc.pageVM = _selectedVM;
                [self pushViewController:vc animated:YES];
            }
            //点击头像
            else if (CGRectContainsPoint(_selectedFollowCell.avatarView.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self pushViewController:friendVC animated:YES];
            }
            //点击用户名
            else if (CGRectContainsPoint(_selectedFollowCell.nameLabel.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self pushViewController:friendVC animated:YES];
            }
            else if (CGRectContainsPoint(_selectedFollowCell.moreView.frame, p)) {
//                [self collect:_selectedFollowCell.collectView];
            }
            else if (CGRectContainsPoint(_selectedFollowCell.likeView.frame, p)) {
                if (_selectedVM.type == 2) {
                    [self like:_selectedFollowCell.likeView];
                } else {
                    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
                }
            }
            else if (CGRectContainsPoint(_selectedFollowCell.followView.frame, p)) {
                [self follow:_selectedFollowCell.followView];
            }
            else if (CGRectContainsPoint(_selectedFollowCell.shareView.frame, p)) {
                [self showShareFunctionView];
            }
            else if (CGRectContainsPoint(_selectedFollowCell.commentView.frame, p)) {
                DDCommentVC* vc = [DDCommentVC new];
                vc.vm = _selectedVM;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (CGRectContainsPoint(_selectedFollowCell.allWorkView.frame, p)) {
                PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
                vc.pageVM = _selectedVM;
                [self pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)tapGestureHot:(UITapGestureRecognizer *)gesture {
    if (_sv.type == PIEPageTypeEliteHot) {
        CGPoint location = [gesture locationInView:_sv.tableHot];
        _selectedIndexPath = [_sv.tableHot indexPathForRowAtPoint:location];
        if (_selectedIndexPath) {
            _selectedHotCell = [_sv.tableHot cellForRowAtIndexPath:_selectedIndexPath];
            _selectedVM = _sourceHot[_selectedIndexPath.row];
            CGPoint p = [gesture locationInView:_selectedHotCell];
            
            //点击小图
            if (CGRectContainsPoint(_selectedHotCell.thumbView.frame, p)) {
                [_selectedHotCell animateToggleExpanded];
            }
            //点击大图
            else  if (CGRectContainsPoint(_selectedHotCell.theImageView.frame, p)) {
                //进入热门详情
                PIEReplyCarouselViewController* vc = [PIEReplyCarouselViewController new];
                _selectedVM.image = _selectedHotCell.theImageView.image;
                vc.pageVM = _selectedVM;
                [self pushViewController:vc animated:YES];
            }
            //点击头像
            else if (CGRectContainsPoint(_selectedHotCell.avatarView.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self pushViewController:friendVC animated:YES];
            }
            //点击用户名
            else if (CGRectContainsPoint(_selectedHotCell.nameLabel.frame, p)) {
                PIEFriendViewController * friendVC = [PIEFriendViewController new];
                friendVC.pageVM = _selectedVM;
                [self pushViewController:friendVC animated:YES];
            }
            else if (CGRectContainsPoint(_selectedHotCell.collectView.frame, p)) {
                [self collect:_selectedHotCell.collectView];
            }
            else if (CGRectContainsPoint(_selectedHotCell.likeView.frame, p)) {
                if (_selectedVM.type == 2) {
                    [self like:_selectedHotCell.likeView];
                } else {
                    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
                }
            }
            else if (CGRectContainsPoint(_selectedHotCell.followView.frame, p)) {
                [self follow:_selectedHotCell.followView];
            }
            else if (CGRectContainsPoint(_selectedHotCell.shareView.frame, p)) {
                [self showShareFunctionView];
            }
            else if (CGRectContainsPoint(_selectedHotCell.commentView.frame, p)) {
                DDCommentVC* vc = [DDCommentVC new];
                vc.vm = _selectedVM;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (CGRectContainsPoint(_selectedHotCell.allWorkView.frame, p)) {
                PIEReplyCollectionViewController* vc = [PIEReplyCollectionViewController new];
                vc.pageVM = _selectedVM;
                [self pushViewController:vc animated:YES];
            }
        }
    }
}



- (void)showShareFunctionView {
    [self.shareFunctionView showInView:self.view animated:YES];
    self.shareFunctionView.collectButton.selected = _selectedVM.collected;
}

-(void)follow:(UIImageView*)followView {
    followView.highlighted = !followView.highlighted;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_selectedVM.userID) forKey:@"uid"];
    if (followView.highlighted) {
        [param setObject:@1 forKey:@"status"];
    }
    else {
        [param setObject:@0 forKey:@"status"];
    }

    [DDService follow:param withBlock:^(BOOL success) {
        if (success) {
            _selectedVM.followed = followView.highlighted;
        } else {
            followView.highlighted = !followView.highlighted;
        }
    }];
}
-(void)collect:(PIEPageButton*) collectView {
    NSMutableDictionary *param = [NSMutableDictionary new];
    collectView.selected = !collectView.selected;
    if (collectView.selected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:_selectedVM.type withID:_selectedVM.ID withBlock:^(NSError *error) {
        if (!error) {
            _selectedVM.collected = collectView.selected;
            _selectedVM.collectCount = collectView.numberString;
        }   else {
            collectView.selected = !collectView.selected;
        }
    }];
}

-(void)like:(PIEPageLikeButton*)likeView {
    NSMutableDictionary *param = [NSMutableDictionary new];
    likeView.selected = !likeView.selected;
    if (likeView.selected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDService toggleLike:likeView.selected ID:_selectedVM.ID type:_selectedVM.type  withBlock:^(BOOL success) {
        if (success) {
            _selectedVM.liked = likeView.selected;
        } else {
            likeView.selected = !likeView.selected;
        }
    }];
}


- (void)help:(BOOL)shouldDownload {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@"ask" forKey:@"type"];
    [param setObject:@(_selectedVM.ID) forKey:@"target"];
    [DDService signProceeding:param withBlock:^(NSString *imageUrl) {
        if (imageUrl != nil) {
            if (shouldDownload) {
                [DDService downloadImage:imageUrl withBlock:^(UIImage *image) {
                    UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }];
            }
        }
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Hud error:@"保存失败" inView:self.view];
    } else {
        [Hud success:@"保存成功" inView:self.view];
    }
}

#pragma mark - ATOMShareFunctionViewDelegate
-(void)tapWechatFriends {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeWechatFriends withPageType:PIEPageTypeAsk];
}
-(void)tapWechatMoment {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeWechatMoments withPageType:PIEPageTypeAsk];
}
-(void)tapSinaWeibo {
    [DDShareSDKManager postSocialShare:_selectedVM.ID withSocialShareType:ATOMShareTypeSinaWeibo withPageType:PIEPageTypeAsk];
}
-(void)tapInvite {
    DDInviteVC* ivc = [DDInviteVC new];
    ivc.askPageViewModel = _selectedVM;
    [self pushViewController:ivc animated:YES];
}
-(void)tapReport {
    [self.reportActionSheet showInView:[AppDelegate APP].window animated:YES];
}
-(void)tapCollect {
    if (_sv.type == PIEPageTypeEliteHot) {
        [self collect:_selectedHotCell.collectView];
    } else {
        [self collect:nil];
    }
}


#pragma mark - getDataSource

- (void)getRemoteSourceFollow {
    WS(ws);
    [ws.sv.tableFollow.footer endRefreshing];
    _currentIndex_follow = 1;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(5) forKey:@"size"];
    
    [PIEEliteManager getMyFollow:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterFollow = NO;
            [ws.sv.tableFollow.header endRefreshing];
        } else {
            _canRefreshFooterFollow = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
            }
            [ws.sv.tableFollow.header endRefreshing];
            [ws.sourceFollow removeAllObjects];
            [ws.sourceFollow addObjectsFromArray:sourceAgent];
            [ws.sv.tableFollow reloadData];
        }
    }];
}

- (void)getMoreRemoteSourceFollow {
    WS(ws);
    [ws.sv.tableFollow.header endRefreshing];
    _currentIndex_follow++;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_currentIndex_follow) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    [PIEEliteManager getMyFollow:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterFollow = NO;
            [ws.sv.tableFollow.footer endRefreshing];
        } else {
            _canRefreshFooterFollow = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
            }
            [ws.sv.tableFollow.footer endRefreshing];
            [ws.sourceFollow addObjectsFromArray:sourceAgent];
            [ws.sv.tableFollow reloadData];
        }
    }];
}



- (void)getRemoteSourceHot:(void (^)(BOOL finished))block {
    WS(ws);
    [ws.sv.tableHot.footer endRefreshing];
    _currentIndex_hot = 1;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(8) forKey:@"size"];
    
    [PIEEliteManager getHotPages:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterHot = NO;
        } else {
            _canRefreshFooterHot = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
            }
            [ws.sourceHot removeAllObjects];
            [ws.sourceHot addObjectsFromArray:sourceAgent];
            [ws.sv.tableHot reloadData];
        }
        [ws.sv.tableHot.header endRefreshing];
        if (block) {
            block(YES);
        }
    }];
}
- (void)getMoreRemoteSourceHot {
    WS(ws);
    [ws.sv.tableHot.header endRefreshing];
    _currentIndex_hot ++;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_currentIndex_hot) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    
    [PIEEliteManager getHotPages:param withBlock:^(NSMutableArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshFooterHot = NO;
        } else {
            _canRefreshFooterHot = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in returnArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [sourceAgent addObject:vm];
            }
            [ws.sourceHot addObjectsFromArray:sourceAgent];
            [ws.sv.tableHot reloadData];
        }
        [ws.sv.tableHot.footer endRefreshing];
    }];
}

-(void)didPullRefreshDown:(UITableView *)tableView {
    if (tableView == _sv.tableFollow) {
        [self getRemoteSourceFollow];
    } else  {
        [self getRemoteSourceHot:nil];
    }
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (tableView == _sv.tableFollow) {
        if (_canRefreshFooterFollow) {
            [self getMoreRemoteSourceFollow];
        } else {
            [_sv.tableFollow.footer endRefreshing];
        }
    } else {
        if (_canRefreshFooterHot) {
            [self getMoreRemoteSourceHot];
        } else {
            [_sv.tableHot.footer endRefreshing];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _sv) {
        int currentPage = (scrollView.contentOffset.x + CGWidth(scrollView.frame) * 0.1) / CGWidth(scrollView.frame);
        if (currentPage == 0) {
            _sv.tableHot.scrollsToTop = NO;
            _sv.tableFollow.scrollsToTop = YES;
            [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
            _sv.type = PIEPageTypeEliteHot;
        } else if (currentPage == 1) {
            [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
            _sv.tableHot.scrollsToTop = YES;
            _sv.tableFollow.scrollsToTop = NO;
            _sv.type = PIEPageTypeEliteFollow;
        }
    }
}

- (JGActionSheet *)psActionSheet {
    WS(ws);
    if (!_psActionSheet) {
        _psActionSheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"下载图片，马上帮P", @"塞入“进行中”,暂不下载",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
        [section setButtonStyle:JGActionSheetButtonStyleCancel forButtonAtIndex:2];
        NSArray *sections = @[section];
        _psActionSheet = [JGActionSheet actionSheetWithSections:sections];
        _psActionSheet.delegate = self;
        [_psActionSheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_psActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            switch (indexPath.row) {
                case 0:
                    [ws.psActionSheet dismissAnimated:YES];
                    [ws help:YES];
                    break;
                case 1:
                    [ws.psActionSheet dismissAnimated:YES];
                    [ws help:NO];
                    break;
                case 2:
                    [ws.psActionSheet dismissAnimated:YES];
                    break;
                default:
                    [ws.psActionSheet dismissAnimated:YES];
                    break;
            }
        }];
    }
    return _psActionSheet;
}
- (JGActionSheet *)reportActionSheet {
    WS(ws);
    if (!_reportActionSheet) {
        _reportActionSheet = [JGActionSheet new];
        JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"色情、淫秽或低俗内容", @"广告或垃圾信息",@"违反法律法规的内容"] buttonStyle:JGActionSheetButtonStyleDefault];
        NSArray *sections = @[section];
        _reportActionSheet = [JGActionSheet actionSheetWithSections:sections];
        _reportActionSheet.delegate = self;
        [_reportActionSheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        [_reportActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            NSMutableDictionary* param = [NSMutableDictionary new];
            [param setObject:@(ws.selectedVM.ID) forKey:@"target_id"];
            [param setObject:@(PIEPageTypeAsk) forKey:@"target_type"];
            UIButton* b = section.buttons[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 1:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                case 2:
                    [ws.reportActionSheet dismissAnimated:YES];
                    [param setObject:b.titleLabel.text forKey:@"content"];
                    break;
                default:
                    [ws.reportActionSheet dismissAnimated:YES];
                    break;
            }
            [ATOMReportModel report:param withBlock:^(NSError *error) {
                if(!error) {
                    [Hud text:@"已举报" inView:[AppDelegate APP].window];
                }
                
            }];
        }];
    }
    return _reportActionSheet;
}


- (PIEShareFunctionView *)shareFunctionView {
    if (!_shareFunctionView) {
        _shareFunctionView = [PIEShareFunctionView new];
        _shareFunctionView.delegate = self;
    }
    return _shareFunctionView;
}

@end
