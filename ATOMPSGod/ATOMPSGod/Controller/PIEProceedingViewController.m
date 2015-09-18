//
//  PIEProceedingViewController.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingViewController.h"
#import "PIEProceedingScrollView.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "HMSegmentedControl.h"
#import "PIEMyAskCollectionCell.h"

#import "DDMyAskManager.h"
#import "DDPageVM.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface PIEProceedingViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PWRefreshBaseCollectionViewDelegate,PWRefreshBaseTableViewDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) PIEProceedingScrollView *sv;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *sourceAsk;
@property (nonatomic, strong) NSMutableArray *sourceToHelp;
@property (nonatomic, strong) NSMutableArray *sourceDone;

@property (nonatomic, assign) NSInteger currentIndex_MyAsk;
@property (nonatomic, assign) NSInteger currentIndex_ToHelp;
@property (nonatomic, assign) NSInteger currentIndex_Done;

@property (nonatomic, assign) BOOL canRefreshAskFooter;
@property (nonatomic, assign) BOOL canRefreshToHelpFooter;
@property (nonatomic, assign) BOOL canRefreshDoneFooter;

@end

@implementation PIEProceedingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    [self createNavBar];
    [self configSubviews];
    
    
    [self getRemoteSourceMyAsk];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init methods

- (void)configData {
    _canRefreshAskFooter = YES;
    _canRefreshToHelpFooter = YES;
    _canRefreshDoneFooter = YES;
    _currentIndex_MyAsk = 1;
    _currentIndex_ToHelp = 1;
    _currentIndex_Done = 1;
}
- (void)configSubviews {
    self.view = self.sv;
    [self configAskCollectionView];
//    [self configToHelpTableView];
//    [self configDoneCollectionView];
}
- (void)configAskCollectionView {
    _sv.askCollectionView.dataSource = self;
    _sv.askCollectionView.delegate = self;
    _sv.askCollectionView.psDelegate = self;
}
- (void)configDoneCollectionView {
    _sv.doneCollectionView.dataSource = self;
    _sv.doneCollectionView.delegate = self;
    _sv.doneCollectionView.psDelegate = self;
}
- (void)configToHelpTableView {
    
}
- (void)createNavBar {
    WS(ws);
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"求P",@"帮P",@"已完成"]];
    _segmentedControl.frame = CGRectMake(0, 120, SCREEN_WIDTH-100, 45);
    _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -5, 0);
    _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (index == 0) {
            [ws.sv toggleWithType:PIEProceedingTypeAsk];
        } else if (index == 1) {
            [ws.sv toggleWithType:PIEProceedingTypeToHelp];
        } else if (index == 2) {
            [ws.sv toggleWithType:PIEProceedingTypeDone];
        }
    }];
    
    _segmentedControl.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = _segmentedControl;
    
}

#pragma mark - Getters and Setters

-(PIEProceedingScrollView*)sv {
    if (!_sv) {
        _sv = [PIEProceedingScrollView new];
        _sv.delegate =self;
    }
    return _sv;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceAsk.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEMyAskCollectionCell *cell =
    (PIEMyAskCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIEMyAskCollectionCell"
                                                                      forIndexPath:indexPath];
    [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
    return cell;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 200);
}

#pragma mark - getSource
#pragma mark - GetDataSource

- (void)getRemoteSourceMyAsk {
    WS(ws);
    _currentIndex_MyAsk = 1;

    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    
    [DDMyAskManager getMyAsk:param withBlock:^(NSMutableArray *resultArray) {
        
        NSMutableArray* sourceAgent = [NSMutableArray new];

        for (ATOMAskPage *homeImage in resultArray) {
            DDPageVM *vm = [DDPageVM new];
            [vm setViewModelData:homeImage];
            [sourceAgent addObject:vm];
        }
        [ws.sourceAsk removeAllObjects];
        [ws.sourceAsk addObjectsFromArray:sourceAgent];
        [ws.sv.askCollectionView reloadData];
    }];
}

- (void)getMoreRemoteSourceMyAsk {
    WS(ws);
    _currentIndex_MyAsk++;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_currentIndex_MyAsk) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    
    [DDMyAskManager getMyAsk:param withBlock:^(NSMutableArray *resultArray) {
        NSMutableArray* sourceAgent = [NSMutableArray new];
        for (ATOMAskPage *homeImage in resultArray) {
            DDPageVM *vm = [DDPageVM new];
            [vm setViewModelData:homeImage];
            [sourceAgent addObject:vm];
        }
        [ws.sourceAsk addObjectsFromArray:sourceAgent];
        [ws.sv.askCollectionView reloadData];
    }];
}

-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
    [self getRemoteSourceMyAsk];
}
-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    [self getMoreRemoteSourceMyAsk];
}
-(void)didPullRefreshDown:(UITableView *)tableView {
    
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    
}
@end
