//
//  PIEEliteHotReplyViewController.m
//  TUPAI
//
//  Created by huangwei on 15/12/17.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEEliteHotReplyViewController.h"
#import "PIEActionSheet_PS.h"
#import "PIEShareView.h"
#import "PIEEliteViewController.h"
#import "SwipeView.h"
#import "PIEBannerViewModel.h"
#import "PIERefreshTableView.h"

/* Variables */
@interface PIEEliteHotReplyViewController ()

@property (nonatomic, strong) PIERefreshTableView *tableHot;

@property (nonatomic, strong) SwipeView *swipeView;

@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *sourceHot;

@property (nonatomic, strong) NSMutableArray<PIEBannerViewModel *> *sourceBanner;

@property (nonatomic, assign) BOOL isfirstLoadingHot;

@property (nonatomic, assign) NSInteger currentIndex_hot;

@property (nonatomic, assign) BOOL canRefreshFooterHot;

@property (nonatomic, assign)  long long timeStamp_hot;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath_hot;

@property (nonatomic, strong)  PIEActionSheet_PS * psActionSheet;

@property (nonatomic, strong)  PIEShareView * shareView;

@property (nonatomic, strong) PIEPageVM *selectedVM;

@end

/* Protocols */
@interface PIEEliteHotReplyViewController (TableView)
<UITableViewDelegate,UITableViewDataSource>
@end

@interface PIEEliteHotReplyViewController (RefreshBaseTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEEliteHotReplyViewController (PIEShareView)
<PIEShareViewDelegate>
@end

@interface PIEEliteHotReplyViewController (SwipeView)
<SwipeViewDelegate,SwipeViewDataSource>
@end

@interface PIEEliteHotReplyViewController (DZNEmptyDataSet)
<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@end

//@interface PIEEliteViewController (JGActionSheet)
//<JGActionSheetDelegate>
//@end

@implementation PIEEliteHotReplyViewController

static  NSString* hotReplyIndentifier = @"PIEEliteHotReplyTableViewCell";
static  NSString* hotAskIndentifier   = @"PIEEliteHotAskTableViewCell";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNavigation_Elite" object:nil];
}

#pragma mark - data setup

- (void)configData {
    _canRefreshFooterHot    = YES;
    
    _currentIndex_hot       = 1;
    
    _isfirstLoadingHot      = YES;
    
    _sourceHot              = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:@"RefreshNavigation_Elite" object:nil];
}



#pragma mark - UI components setup
- (void)configSubviews
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configTableViewHot];
    [self setupGestures];
}
- (void)configTableViewHot {
    
    _tableHot.dataSource = self;
    _tableHot.delegate = self;
    _tableHot.psDelegate = self;
    _tableHot.emptyDataSetDelegate = self;
    _tableHot.emptyDataSetSource = self;
    _tableHot.estimatedRowHeight = SCREEN_WIDTH+225;
    _tableHot.rowHeight = UITableViewAutomaticDimension;
    UINib* nib = [UINib nibWithNibName:hotReplyIndentifier bundle:nil];
    [_tableHot registerNib:nib forCellReuseIdentifier:hotReplyIndentifier];
    UINib* nib2 = [UINib nibWithNibName:hotAskIndentifier bundle:nil];
    [_tableHot registerNib:nib2 forCellReuseIdentifier:hotAskIndentifier];
    _swipeView.dataSource = self;
    _swipeView.delegate = self;
    
}

- (void)setupGestures {
    UITapGestureRecognizer* tapGestureHot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHot:)];
    [_tableHot addGestureRecognizer:tapGestureHot];
    
    UILongPressGestureRecognizer* longPressGestureHot = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnHot:)];
    [_tableHot addGestureRecognizer:longPressGestureHot];
   
    
}


#pragma mark - Notification methods
- (void)refreshHeader {
    if (_tableHot.mj_header.isRefreshing == false) {
        [ _tableHot.mj_header beginRefreshing];
    }
}

#pragma mark - <SwipeViewDataSource>
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return _sourceBanner.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
        CGFloat width = _sv.swipeView.frame.size.width;
        CGFloat height = _sv.swipeView.frame.size.height;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    PIEBannerViewModel* vm = [_sourceBanner objectAtIndex:index];
    for (UIView *subView in view.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)subView;
            //            imageView.image = tabbar.avatarImage;
            //            NSLog(@"[DDUserManager currentUser].avatar]%@",[DDUserManager currentUser].avatar);
            [imageView setImageWithURL:[NSURL URLWithString:vm.imageUrl]];
        }
    }
    ;
    return view;
}

#pragma mark - <SwipeViewDelegate>

@end
