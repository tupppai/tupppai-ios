//
//  PIEChannelTutorialDetailViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/25/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialDetailViewController.h"
#import "PIEChannelTutorialModel.h"
#import "PIEChannelTutorialImageModel.h"

#import "PIECommentModel.h"

#import "PIEChannelTutorialTeacherDescTableViewCell.h"
#import "PIEChannelTutorialPrefaceTableViewCell.h"
#import "PIEChannelTutorialImageTableViewCell.h"

#import "PIEChannelTutorialCommentsCountTableViewCell.h"
#import "PIEChannelTutorialCommentTableViewCell.h"


#import "PIERefreshTableView.h"
#import "PIEChannelManager.h"
#import "PIEChannelTutorialDetailToolbar.h"
#import "PIEChannelTutorialLockedUpView.h"


#import "PIECommentVM.h"
#import "PIECommentManager.h"
#import "PIECommentViewController.h"
#import "LxDBAnything.h"
#import "PIEChannelTutorialRewardFailedView.h"
#import "PIEFriendViewController.h"
#import "PIEShareView.h"
#import "PIEChooseChargeSourceView.h"
#import "PIEChargeMoneyView.h"

@interface PIEChannelTutorialDetailViewController ()
<
    /* Protocols */
    UITableViewDelegate, UITableViewDataSource,

    PWRefreshBaseTableViewDelegate,

    ATOMViewControllerDelegate,

    PIEShareViewDelegate,

    PIEChannelTutorialRewardFailedViewDelegate,

    PIEChooseChargeSourceViewDelegate,

    PIEChargeMoneyViewDelegate
>
/* Variables */

@property (nonatomic, strong) PIERefreshTableView *tableView;

/** something to say:
    1. 因为thread/tutorials_list 和 thread/tutorial_details这两个接口返回的数据太相似，我并没有特地为前者做一个"listModel"的东西，
       所以统一用PIEChannelTutorialModel。前者接口返回一个PIEChannelTutorialModel的数组，后者仅返回一个PIEChannelTutorialModel。
    2. 前者返回的模型数组中，ask_uploads数组为空；后者的ask_uploads才开始有值。
    3. 前控制器传给了后控制器一整个PIEChannelTutorialModel , 而不是单单一个tutorial_id, 因为考虑到界面初始化的时候title和一些其它的东西，所以
       把这一个比较累赘的self.currentChannelTutorialModel留着了。
    4. 感觉这应该是后台接口设计冗余的问题？
 
 */
@property (nonatomic, strong) PIEChannelTutorialModel *source_tutorialModel;

@property (nonatomic, strong) NSMutableArray<PIECommentVM *> *source_tutorialCommentVM;

@property (nonatomic, assign) NSInteger currentCommentIndex;

@property (nonatomic, strong) PIEChannelTutorialDetailToolbar *toolBar;

@property (nonatomic, assign) PIEWalletChargeSourceType walletChargeSourceType;

/** 代缴的摇摇乐总额 */
@property (nonatomic, assign) double toBeRewardedAmount;

///** 准备充值的钱(总额 - 当前余额) */
//@property (nonatomic, assign) double toBeRechargeAmount;

@property (nonatomic, assign) BOOL canRefreshFooter;

@end

@implementation PIEChannelTutorialDetailViewController

static NSString *PIEChannelTutorialTeacherDescTableViewCellIdentifier =
@"PIEChannelTutorialTeacherDescTableViewCell";

static NSString *PIEChannelTutorialPrefaceTableViewCellIdentifier =
@"PIEChannelTutorialPrefaceTableViewCell";

static NSString *PIEChannelTutorialImageTableViewCelIdentifier =
@"PIEChannelTutorialImageTableViewCell";

static NSString *PIEChannelTutorialCommentsCountTableViewCellIdentifier =
@"PIEChannelTutorialCommentsCountTableViewCell";

static NSString *PIEChannelTutorialCommentTableViewCellIdentifier =
@"PIEChannelTutorialCommentTableViewCell";




#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor   = [UIColor whiteColor];
    
    [self setupData];
    
    [self setupSubviews];
    
    [self setupRAC];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self loadMoreTutorialComments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



#pragma mark - UI components setup
- (void)setupNavBar
{
    self.navigationItem.title = self.currentTutorialModel.title;
}

- (void)setupSubviews
{
    PIERefreshTableView *tableView = ({
        PIERefreshTableView *tableView = [[PIERefreshTableView alloc] init];
        
        tableView.delegate   = self;
        tableView.dataSource = self;
        tableView.psDelegate = self;
       
        tableView.estimatedRowHeight = 60;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tableView registerNib:[UINib nibWithNibName:@"PIEChannelTutorialTeacherDescTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:PIEChannelTutorialTeacherDescTableViewCellIdentifier];
        
        [tableView registerNib:[UINib nibWithNibName:@"PIEChannelTutorialPrefaceTableViewCell" bundle:nil]
        forCellReuseIdentifier:PIEChannelTutorialPrefaceTableViewCellIdentifier];
        
        [tableView registerNib:[UINib nibWithNibName:@"PIEChannelTutorialImageTableViewCell" bundle:nil]
        forCellReuseIdentifier:PIEChannelTutorialImageTableViewCelIdentifier];
        
        [tableView registerNib:[UINib nibWithNibName:@"PIEChannelTutorialCommentsCountTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:PIEChannelTutorialCommentsCountTableViewCellIdentifier];
        
        [tableView registerNib:[UINib nibWithNibName:@"PIEChannelTutorialCommentTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:PIEChannelTutorialCommentTableViewCellIdentifier];
        
        [self.view addSubview:tableView];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
    
    self.tableView = tableView;
    
    PIEChannelTutorialDetailToolbar *toolBar = ({
        PIEChannelTutorialDetailToolbar *toolBar =
        [PIEChannelTutorialDetailToolbar toolbar];
        
        [self.view addSubview:toolBar];
        
        [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
            make.left.bottom.right.equalTo(self.view);
        }];
        
        toolBar.hasBought  = self.currentTutorialModel.hasBought;
        
        toolBar;
    });
    
    self.toolBar = toolBar;
    
}

- (void)setupRAC
{
    @weakify(self);
    [[self.toolBar.rollDiceButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [Hud activity:@"随机打赏中..."];
         [self rollDiceRewardRequest];
         
     }];
    
    [[self.toolBar.commentButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         
         PIECommentViewController *commentVC = [[PIECommentViewController alloc] init];
         commentVC.vm = [self.source_tutorialModel piePageVM];
         commentVC.shouldShowHeaderView = NO;
         commentVC.delegate = self;
         [self.parentViewController.navigationController pushViewController:commentVC animated:YES];
     }];
    
    [[self.toolBar.shareButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         PIEShareView *shareView = [[PIEShareView alloc] init];
         shareView.delegate = self;
         [shareView show:[self.currentTutorialModel piePageVM]];

     }];
    
    [[self rac_signalForSelector:@selector(ATOMViewControllerPopedFromNavAfterSendingCommment)
                    fromProtocol:@protocol(ATOMViewControllerDelegate)]
     subscribeNext:^(id x) {
        @strongify(self);
        /* commentViewController曾经发过新的评论，并且返回才需要重刷数据 */
        [self loadNewTutorialComments];
    }];
    
    
    // 搞明白了！是@(0) 和 0 的区别！
    /* 不知道怎么搞的 tuple.second == 0 永远为false */
//    [[self rac_signalForSelector:@selector(shareView:didShareWithType:)
//                   fromProtocol:@protocol(PIEShareViewDelegate)] subscribeNext:^(id x) {
//        
//    }];
//
    
    // call-back hell begins
    
    [[self rac_signalForSelector:@selector(rewardFailedViewDidTapGoChargeMoneyButton:)
                   fromProtocol:@protocol(PIEChannelTutorialRewardFailedViewDelegate)]
    subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        PIEChannelTutorialRewardFailedView *rewardFaildView = tuple.first;
        [rewardFaildView dismiss];
        
        [self showChooseChargeMoneySourceView];
    }];
    
    [[self rac_signalForSelector:@selector(chooseChargeSourceView:tapButtonOfIndex:)
                    fromProtocol:@protocol(PIEChooseChargeSourceViewDelegate)]
     subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        // take record of the source

         PIEChooseChargeSourceView *chooseChargeSourceView =
         (PIEChooseChargeSourceView *)tuple.first;
         
         NSInteger index = [tuple.second integerValue];
         if (index == 0) {
             self.walletChargeSourceType = PIEWalletChargeSourceTypeAlipay;
         }else if (index == 1)
         {
             self.walletChargeSourceType = PIEWalletChargeSourceTypeWechat;
         }
         
         [chooseChargeSourceView dismiss];
         
         [self showInputMoneyView];
        
    }];
    
    [[self rac_signalForSelector:@selector(chargeMoneyView:tapConfirmButtonWithAmount:) fromProtocol:@protocol(PIEChargeMoneyViewDelegate)]
    subscribeNext:^(RACTuple *tuple) {
        
//        @strongify(self);
        PIEChargeMoneyView *chargeMoneyView = tuple.first;
        [chargeMoneyView dismiss];
        double amount = [tuple.second doubleValue];
        if (amount < kPIEChargeMinimumAmount) {
            NSString *prompt =
            [NSString stringWithFormat:@"至少要充值%.2f元", kPIEChargeMinimumAmount];
            [Hud error:prompt];
        }else{
//            [self chargeMoneyRequestWithType:_walletChargeSourceType
//                                      amount:([tuple.second doubleValue])];
        }
        
    }];
    
    // --- call-back hell ends
    
}

#pragma mark - Data setup
- (void)setupData
{
    _source_tutorialCommentVM = [NSMutableArray<PIECommentVM *> array];

    _currentCommentIndex      = 0;

    _canRefreshFooter         = YES;
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if (self.source_tutorialModel == nil) {
                return 0;
            }
            else{
                return 1;

            }
            break;
        }
        case 1:
        {
            if (self.source_tutorialModel == nil) {
                return 0;
            }
            else{
                return 1;
            }
            break;
        }
        case 2:
        {
            if (self.source_tutorialModel == nil) {
                return 0;
            }else{
                return self.source_tutorialModel.tutorial_images.count;
            }
            break;
        }
        case 3:{
            return self.source_tutorialCommentVM.count + 1;
            break;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        PIEChannelTutorialTeacherDescTableViewCell *teacherDescCell =
        [tableView dequeueReusableCellWithIdentifier:
         PIEChannelTutorialTeacherDescTableViewCellIdentifier];
        
        [teacherDescCell injectModel:self.source_tutorialModel];
        
        /*
         
         setup rac for this cell (do not worry about the cell's been recycled.)
         since all signals from the cell would stop sending anything upon its 'rac_prepareForReuseSignal'. while this cell is being reused,
         it would re-bound the subcrber for the second time.
         Result: only one subscriber, the block will only execute once  for every single 
                 tapping.
         
         */
        @weakify(self);
        [teacherDescCell.tapOnAvatar subscribeNext:^(id x) {
            @strongify(self);
            [self pushToFriendViewController];
            
        }];
        
        [teacherDescCell.tapOnFollowButton subscribeNext:^(id x) {
            @strongify(self);
            [self pressOnFollowButton];
        }];
        
        return teacherDescCell;
    }
    else if (indexPath.section == 1){
        PIEChannelTutorialPrefaceTableViewCell *prefaceCell =
        [tableView dequeueReusableCellWithIdentifier:
         PIEChannelTutorialPrefaceTableViewCellIdentifier];
        
        [prefaceCell injectModel:self.source_tutorialModel];
        
        return prefaceCell;
    }
    else if (indexPath.section == 2){
        PIEChannelTutorialImageTableViewCell *tutorialImageCell =
        [tableView dequeueReusableCellWithIdentifier:
         PIEChannelTutorialImageTableViewCelIdentifier];
        
        PIEChannelTutorialImageModel *imageModel =
        self.source_tutorialModel.tutorial_images[indexPath.row];
        
        [tutorialImageCell injectImageModel:imageModel];
        
        if ((indexPath.row == self.source_tutorialModel.tutorial_images.count - 1) &&
            self.source_tutorialModel.hasUnlocked == NO)
        {
            tutorialImageCell.locked = YES;
        }
        return tutorialImageCell;
    }
    else if(indexPath.section == 3){
        /* 第一个row：commentCount;其它是comment */
        if (indexPath.row == 0) {
            PIEChannelTutorialCommentsCountTableViewCell *commentCountsCell =
            [tableView dequeueReusableCellWithIdentifier:
             PIEChannelTutorialCommentsCountTableViewCellIdentifier];
            [commentCountsCell injectCommentCount:self.currentTutorialModel.comment_count];
            return commentCountsCell;
            
        }else{
            PIEChannelTutorialCommentTableViewCell *commentCell =
            [tableView dequeueReusableCellWithIdentifier:
             PIEChannelTutorialCommentTableViewCellIdentifier];
            
            [commentCell injectVM:self.source_tutorialCommentVM[indexPath.row - 1]];
            
            return commentCell;
        }
        
    }
    return nil;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* nothing yet */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        /* tutorial images */
        PIEChannelTutorialImageModel *imageModel =
        self.source_tutorialModel.tutorial_images[indexPath.row];
        CGFloat imageHeight =
        imageModel.imageHeight * (SCREEN_WIDTH / imageModel.imageWidth);
        return imageHeight;
    }
    else{
        return UITableViewAutomaticDimension;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        /* Teacher description */
        return 65;
    }
    else if (indexPath.section == 1){
        /* tutorial preface */
        return 220;
    }else if (indexPath.section == 2){
        /* tutorial images */
        return 190;
    }else if (indexPath.section == 3)
        /* comments */
        return 80;
    else{
        return 0;
    }
}


#pragma mark - <PWRefreshBaseTableViewDelegate>
- (void)didPullRefreshDown:(UITableView *)tableView
{
    /*
        开启两个线程，异步加载两种数据。（刷新UI放到主线程里应该就不会冲突，最多不就刷新两次tableView咯）
        不过为了避免race condition, reload data之类的UI更新操作还是统一放到了主队列里串行
     */
    [self loadNewTutorialDetails];
    [self loadMoreTutorialComments];
}

- (void)didPullRefreshUp:(UITableView *)tableView
{
    if (_canRefreshFooter == YES) {
        [self loadMoreTutorialComments];
    }else{
        [Hud text:@"已经拉到底啦"];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - <PIEShareViewDelegate>

/* 该死的RAC为啥tuple.second 不能判断 == 0??? */
- (void)shareView:(PIEShareView *)shareView didShareWithType:(ATOMShareType)type
{
    if (type == ATOMShareTypeWechatMoments) {
        [self unlockTutorial];
    }
}

#pragma mark - Network request 
- (void)loadNewTutorialDetails
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tutorial_id"] = [@(self.currentTutorialModel.ask_id) stringValue];
    
    [PIEChannelManager
     getSource_channelTutorialDetail:params
     block:^(PIEChannelTutorialModel *model) {
         _source_tutorialModel = [model copy];
         
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             
             _toolBar.hasBought = model.hasBought;
             [_tableView.mj_header endRefreshing];
             [_tableView reloadData];
         }];
     } failureBlock:^{
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [_tableView.mj_header endRefreshing];
         }];
         
     }];
    
}

- (void)loadNewTutorialComments
{
    _currentCommentIndex = 1;
    
    PIECommentManager *commentManager = [PIECommentManager new];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"page"]      = @(_currentCommentIndex);
    params[@"size"]      = @(10);
    params[@"type"]      = @(1);        /* 1: ask_id; 2: reply_id */
    params[@"target_id"] = [@(self.currentTutorialModel.ask_id) stringValue];
    
    @weakify(self);
    [commentManager
     ShowDetailOfComment:params
     withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
         @strongify(self);
         [self.tableView.mj_footer endRefreshing];
         if (error != nil) {
             [Hud error:error.domain];
         }else{
             
             if (recentCommentArray.count == 0) {
                 self.canRefreshFooter = NO;
             }else{
                 self.canRefreshFooter = YES;
             }
             
             [self.source_tutorialCommentVM removeAllObjects];
             [self.source_tutorialCommentVM addObjectsFromArray:recentCommentArray];
             
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [self.tableView reloadData];
             }];
         }
         
     }];

}

- (void)loadMoreTutorialComments
{
    _currentCommentIndex ++;
    
    PIECommentManager *commentManager = [PIECommentManager new];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"page"]      = @(_currentCommentIndex);
    params[@"size"]      = @(10);
    params[@"type"]      = @(1);        /* 1: ask_id; 2: reply_id */
    params[@"target_id"] = [@(self.currentTutorialModel.ask_id) stringValue];
    
    @weakify(self);
    [commentManager
     ShowDetailOfComment:params
     withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
         @strongify(self);
         [self.tableView.mj_footer endRefreshing];
         if (error != nil) {
             [Hud error:error.domain];
         }else{
             
             if (recentCommentArray.count < 10) {
                 _canRefreshFooter = NO;
             }else{
                 _canRefreshFooter = YES;
             }
             
             [self.source_tutorialCommentVM addObjectsFromArray:recentCommentArray];
             
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [self.tableView reloadData];
             }];
         }
     }];
}

- (void)rollDiceRewardRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"ask_id"] = [@(self.source_tutorialModel.ask_id) stringValue];
    
    [DDBaseService
     GET:params
     url:@"thread/reward"
     block:^(id responseObject) {
         [Hud dismiss];
         
         NSDictionary *dataDict = responseObject[@"data"];
         long rollDiceStatus    = [dataDict[@"type"] longValue];
         double balance         = [dataDict[@"balance"] doubleValue];
         double amount          = [dataDict[@"amount"] doubleValue];
         
         if (rollDiceStatus == kPIERewardFailedInteger){

//             PIEChannelTutorialRewardFailedView *rewardFailedView =
//             [PIEChannelTutorialRewardFailedView new];
//             
//             [rewardFailedView show];
//             rewardFailedView.delegate = self;
//             
//             // 记录待缴的总额
//             self.toBeRewardedAmount = amount;
             
             // 更改需求：直接跳进微信的支付页面
             @weakify(self);
             [self chargeMoneyRequestWithType:PIEWalletChargeSourceTypeWechat
                                       amount:amount
                                      success:^{
                                          @strongify(self);
                                          [self rewardWithConcreteAmount:amount];
                                      }];
             
             
             
         }else if (rollDiceStatus == kPIERewardSuccessInteger){
             NSString *prompt = [NSString stringWithFormat:@"支付%.2f元，剩余%.2f元", amount, balance];
             [Hud text:prompt];
             
             [self unlockTutorial];
             
         }else{
             NSString *prompt = [NSString stringWithFormat:@"type == %ld", (long)rollDiceStatus];
             [Hud error:prompt];
             
         }
     }];
    
}

- (void)chargeMoneyRequestWithType:(PIEWalletChargeSourceType)sourceType
                            amount:(double)amount
                           success:(void(^)(void))successBlock
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"amount"] = @(amount);
    if (sourceType == PIEWalletChargeSourceTypeWechat) {
        params[@"type"] = @"wx";
    }else if (sourceType == PIEWalletChargeSourceTypeAlipay)
    {
        params[@"type"] = @"alipay";
    }
    
    [DDService
     charge:params
     withBlock:^(BOOL success) {
         if (success && successBlock != nil) {
             successBlock();
         }
     }];
}

- (void)rewardWithConcreteAmount:(double)amount
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"ask_id"] = [@(self.source_tutorialModel.ask_id) stringValue];
    params[@"amount"] = @(amount);
    
    [DDBaseService
     GET:params
     url:@"thread/reward"
     block:^(id responseObject) {
         [Hud dismiss];
         
         NSDictionary *dataDict = responseObject[@"data"];
         long rollDiceStatus    = [dataDict[@"type"] longValue];
         double balance         = [dataDict[@"balance"] doubleValue];
         double amount          = [dataDict[@"amount"] doubleValue];
         
         // 已经充值了还会导致余额不足的情况吗？
         if (rollDiceStatus == kPIERewardFailedInteger){
             
             PIEChannelTutorialRewardFailedView *rewardFailedView =
             [PIEChannelTutorialRewardFailedView new];
             
             [rewardFailedView show];
             rewardFailedView.delegate = self;
             
             
         }else if (rollDiceStatus == kPIERewardSuccessInteger){
             NSString *prompt = [NSString stringWithFormat:@"支付%.2f元，剩余%.2f元", amount, balance];
             [Hud text:prompt];
             
             [self unlockTutorial];
             
         }else{
             NSString *prompt = [NSString stringWithFormat:@"type == %ld", (long)rollDiceStatus];
             [Hud error:prompt];
             
         }
     }];
}

#pragma mark - RAC response methods
- (void)showChooseChargeMoneySourceView
{
    // pop out the choosemoney source panel
    PIEChooseChargeSourceView *chooseChargeSourceView = [PIEChooseChargeSourceView new];
    
    // become delegate, take response
    chooseChargeSourceView.delegate = self;
    
    [chooseChargeSourceView show];
    
}

- (void)showInputMoneyView
{
    PIEChargeMoneyView *chargeMoneyView = [PIEChargeMoneyView new];
    
    chargeMoneyView.delegate = self;
    
    [chargeMoneyView showWithAmoutToBeCharge:kPIEChargeMinimumAmount];
}


#pragma mark - private helpers
- (void)pushToFriendViewController
{
    // fetch userid
     PIEFriendViewController *friendVC =
    [[PIEFriendViewController alloc] init];
    
    friendVC.pageVM = [self.currentTutorialModel piePageVM];
    
    // jump to FriendViewController
    [self.parentViewController.navigationController pushViewController:friendVC
                                                              animated:YES];
}

- (void)pressOnFollowButton{
    [self.source_tutorialModel followAction];
}


- (void)unlockTutorial
{
    // 打赏或分享到朋友圈后重刷UI
    [self loadNewTutorialDetails];
    
    // 心形满格
//    self.toolBar.hasBought = YES;
    
    // 解锁了之后可能toolBar不会心形满格（寒酸鬼只是分享到朋友圈解锁了而已，这时不能直接满格）。所以设置toolBar.hasBought应该在网络请求成功的回调中
    
}


@end
