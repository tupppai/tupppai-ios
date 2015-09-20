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
#import "PIEEliteTableViewCellFollow.h"
#import "PIEEliteTableViewCellHot.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ATOMShowAttention.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

static  NSString* indentifier1 = @"PIEEliteTableViewCellFollow";
static  NSString* indentifier2 = @"PIEEliteTableViewCellHot";

@interface PIEEliteViewController ()<UITableViewDelegate,UITableViewDataSource,PWRefreshBaseTableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) PIEEliteScrollView *sv;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *sourceFollow;
@property (nonatomic, strong) NSMutableArray *sourceHot;

@property (nonatomic, assign) NSInteger currentIndex_follow;
@property (nonatomic, assign) NSInteger currentIndex_hot;

@property (nonatomic, assign) BOOL canRefreshFooterFollow;
@property (nonatomic, assign) BOOL canRefreshFooterHot;
@end

@implementation PIEEliteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    [self createNavBar];
    [self configSubviews];
    [self getRemoteSourceFollow];

}

#pragma mark - init methods

- (void)configData {
    _canRefreshFooterFollow = YES;
    _canRefreshFooterHot = YES;

    _currentIndex_follow = 1;
    _currentIndex_hot = 1;
    
    _sourceFollow = [NSMutableArray new];
    _sourceHot = [NSMutableArray new];
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
}

- (void)configTableViewHot {
    _sv.tableHot.dataSource = self;
    _sv.tableHot.delegate = self;
    _sv.tableHot.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:indentifier2 bundle:nil];
    [_sv.tableHot registerNib:nib forCellReuseIdentifier:indentifier2];
}
- (void)createNavBar {
    WS(ws);
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"关注",@"热门"]];
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
        [ws.sv toggle];
    }];
    
    self.navigationItem.titleView = _segmentedControl;
    
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
        PIEEliteTableViewCellFollow *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if (!cell) {
            cell = [[PIEEliteTableViewCellFollow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier1];
        }
        [cell injectSauce:[_sourceFollow objectAtIndex:indexPath.row]];
        return cell;
    } else if (tableView == _sv.tableHot) {
        PIEEliteTableViewCellHot *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
        if (!cell) {
            cell = [[PIEEliteTableViewCellHot alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier2];
        }
        [cell injectSauce:[_sourceHot objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _sv.tableFollow) {
        return [tableView fd_heightForCellWithIdentifier:indentifier1  cacheByIndexPath:indexPath configuration:^(PIEEliteTableViewCellFollow *cell) {
            [cell injectSauce:[_sourceFollow objectAtIndex:indexPath.row]];
        }];
    } else if (tableView == _sv.tableHot) {
        return [tableView fd_heightForCellWithIdentifier:indentifier2  cacheByIndexPath:indexPath configuration:^(PIEEliteTableViewCellHot *cell) {
            [cell injectSauce:[_sourceHot objectAtIndex:indexPath.row]];
        }];
    } else {
        return 0;
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
    [param setObject:@(15) forKey:@"size"];
    
    ATOMShowAttention *showAttention = [ATOMShowAttention new];
    [showAttention ShowAttention:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        if (resultArray.count == 0) {
            _canRefreshFooterFollow = NO;
            [ws.sv.tableFollow.header endRefreshing];
        } else {
            _canRefreshFooterFollow = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEEliteEntity *entity in resultArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithFollowEntity:entity];
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
    ATOMShowAttention *showAttention = [ATOMShowAttention new];
    [showAttention ShowAttention:param withBlock:^(NSMutableArray *resultArray, NSError *error) {
        if (resultArray.count == 0) {
            _canRefreshFooterFollow = NO;
            [ws.sv.tableFollow.footer endRefreshing];
        } else {
            _canRefreshFooterFollow = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEEliteEntity *entity in resultArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithFollowEntity:entity];
                [sourceAgent addObject:vm];
            }
            [ws.sv.tableFollow.footer endRefreshing];
            [ws.sourceFollow addObjectsFromArray:sourceAgent];
            [ws.sv.tableFollow reloadData];
        }
    }];
}

-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getRemoteSourceFollow];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshFooterFollow) {
        [self getMoreRemoteSourceFollow];
    } else {
        [_sv.tableFollow.footer endRefreshing];
    }
}

@end
