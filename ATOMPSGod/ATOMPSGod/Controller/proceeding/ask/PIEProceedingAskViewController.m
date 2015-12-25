//
//  PIEProceedingAskViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 12/23/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingAskViewController.h"
#import "QBImagePickerController.h"
#import "PIEProceedingShareView.h"
#import "PIERefreshTableView.h"
#import "PIEProceedingAskTableViewCell_NoGap.h"
#import "PIEProceedingAskTableViewCell.h"
#import "DDPageManager.h"


/* Variables */
@interface PIEProceedingAskViewController ()

@property (nonatomic, strong) PIERefreshTableView *askTableView;

@property (nonatomic, assign) BOOL isfirstLoadingAsk;

@property (nonatomic, strong)
NSMutableArray <NSMutableArray<PIEPageVM *> *> *sourceAsk;

@property (nonatomic, assign) NSInteger currentIndex_MyAsk;

@property (nonatomic, assign)  long long timeStamp_myAsk;

@property (nonatomic, assign) BOOL canRefreshAskFooter;

@property (nonatomic, strong) NSIndexPath* selectedIndexPath_ask;

@property (nonatomic, strong) PIEPageVM* selectedVM;

@property (nonatomic, strong) QBImagePickerController* QBImagePickerController;

@property (nonatomic, strong) PIEProceedingShareView *shareView;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureAsk;

@end

/* Protocols */
@interface PIEProceedingAskViewController (TableView)
<UITableViewDelegate, UITableViewDataSource>
@end

@interface PIEProceedingAskViewController (RefreshTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEProceedingAskViewController (DZNEmptyDataSet)
<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

@interface PIEProceedingAskViewController (ProceedingShareView)
<PIEProceedingShareViewDelegate>
@end


@implementation PIEProceedingAskViewController

static NSString *PIEProceedingAskTableViewCell_NoGapIdentifier =
@"PIEProceedingAskTableViewCell_NoGap";

static NSString *PIEProceedingAskTableViewCellIdentifier =
@"PIEProceedingAskTableViewCell";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configData];
    
    [self configAskTableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init methods
- (void)configData {
    _canRefreshAskFooter    = YES;
    
    _isfirstLoadingAsk      = YES;
    
    _currentIndex_MyAsk     = 1;
    
    _sourceAsk              =
    [NSMutableArray<NSMutableArray<PIEPageVM *> *> new];
}


- (void)configAskTableView {
    
    _askTableView = [[PIERefreshTableView alloc] init];
    _askTableView.dataSource           = self;
    _askTableView.delegate             = self;
    _askTableView.psDelegate           = self;
    _askTableView.emptyDataSetDelegate = self;
    _askTableView.emptyDataSetSource   = self;

    _askTableView.estimatedRowHeight   = 175;
    _askTableView.rowHeight            = UITableViewAutomaticDimension;
    
    UINib* nib = [UINib nibWithNibName:@"PIEProceedingAskTableViewCell" bundle:nil];
    [_askTableView registerNib:nib forCellReuseIdentifier:PIEProceedingAskTableViewCellIdentifier];
    
    UINib* nib2 = [UINib nibWithNibName:@"PIEProceedingAskTableViewCell_NoGap" bundle:nil];
    [_askTableView registerNib:nib2 forCellReuseIdentifier:PIEProceedingAskTableViewCell_NoGapIdentifier];
    
    [self.view addSubview:_askTableView];
    
    [_askTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    
}

#pragma mark - Gesture events
- (void)setupGestures {
    _longPressGestureAsk = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnAsk:)];
    [_askTableView addGestureRecognizer:_longPressGestureAsk];
}

- (void)longPressOnAsk:(UILongPressGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_askTableView];
    NSIndexPath *indexPath = [_askTableView indexPathForRowAtPoint:location];
    _selectedIndexPath_ask = indexPath;
    
    
    /* Bug fixed! */
    _selectedVM = [[_sourceAsk objectAtIndex:indexPath.row] firstObject];
    
    if (indexPath) {
        //点击图片
        [self showShareViewWithToHideDeleteButton:YES];
    }
}

#pragma mark - Public methods
- (void)getSourceIfEmpty_ask {
    if (_sourceAsk.count <= 0 || _isfirstLoadingAsk) {
        [self.askTableView.mj_header beginRefreshing];
    }
}

#pragma mark - <PWRefreshBaseTableViewDelegate>
- (void)didPullRefreshUp:(UITableView *)tableView
{
    if (_canRefreshAskFooter) {
        [self getMoreRemoteSourceMyAsk];
    }else{
        [_askTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)didPullRefreshDown:(UITableView *)tableView
{
    [self getRemoteSourceMyAsk];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceAsk.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PIEProceedingAskTableViewCell_NoGap *cell = [tableView dequeueReusableCellWithIdentifier:PIEProceedingAskTableViewCell_NoGapIdentifier];
        [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
        return cell;
    } else {
        PIEProceedingAskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PIEProceedingAskTableViewCellIdentifier];
        [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
        return cell;
    }
}


#pragma mark - <UITableViewDelegate>
/* nothing yet. */


#pragma mark - fetching remote data
- (void)getRemoteSourceMyAsk {
    WS(ws);
    [ws.askTableView.mj_footer endRefreshing];
    _currentIndex_MyAsk = 1;
    _timeStamp_myAsk = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
    [param setObject:@(_timeStamp_myAsk) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getAskWithReplies:param withBlock:^(NSArray *returnArray) {
        ws.isfirstLoadingAsk = NO;
        if (returnArray.count == 0) {
            _canRefreshAskFooter = NO;
        } else {
            _canRefreshAskFooter = YES;
            [ws.sourceAsk removeAllObjects];
            [ws.sourceAsk addObjectsFromArray:returnArray];
        }
        [ws.askTableView reloadData];
        [ws.askTableView.mj_header endRefreshing];
    }];
}

- (void)getMoreRemoteSourceMyAsk {
    WS(ws);
    [ws.askTableView.mj_header endRefreshing];
    _currentIndex_MyAsk++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_currentIndex_MyAsk) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
    [param setObject:@(_timeStamp_myAsk) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getAskWithReplies:param withBlock:^(NSArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshAskFooter = NO;
        } else {
            _canRefreshAskFooter = YES;
            [ws.sourceAsk addObjectsFromArray:returnArray];
        }
        [ws.askTableView reloadData];
        [ws.askTableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - <PIEProceedingShareViewDelegate>
//sina
-(void)tapShare1 {
    [self.shareView dismiss];
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeSinaWeibo block:nil];
}
//qqzone
-(void)tapShare2 {
    [self.shareView dismiss];
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQZone  block:nil];
}
//wechat moments
-(void)tapShare3 {
    [self.shareView dismiss];
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatMoments block:nil];
}
//wechat friends
-(void)tapShare4 {
    [self.shareView dismiss];
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatFriends  block:nil];
}
-(void)tapShare5 {
    [self.shareView dismiss];
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQFriends  block:nil];
    
}
-(void)tapShare6 {
    [DDShareManager copy:_selectedVM];
}
-(void)tapShare7 {
    [self.shareView dismiss];
}

-(void)tapShareCancel {
    [self.shareView dismiss];
}


#pragma mark - <DZNEmptyDataSetDataSource>

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"还没发布求P,赶快发布召唤大神";
    NSDictionary *attributes =
    @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
      NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}




#pragma mark - <DZNEmptyDataSetDelegate>
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (_isfirstLoadingAsk) {
        /* 假如是因为第一次打开这个页面而没有数据的话，不要显示这个emptyDataSet */
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - lazy loadings
- (void)showShareViewWithToHideDeleteButton:(BOOL)hide{
    self.shareView.hideDeleteButton = hide;
    [self.shareView show];
    
}
-(PIEProceedingShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEProceedingShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}


@end
