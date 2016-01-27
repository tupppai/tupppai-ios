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


@interface PIEChannelTutorialDetailViewController ()
<
    /* Protocols */
    UITableViewDelegate, UITableViewDataSource,
    PWRefreshBaseTableViewDelegate
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

@property (nonatomic, strong) PIEChannelTutorialLockedUpView *lockedUpView;

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupData];
    
    [self setupSubviews];
    
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
        
        toolBar;
    });
    
    self.toolBar = toolBar;
    
    @weakify(self);
    [[toolBar.rollDiceButton
     rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self rollDiceReward];
         
    }];
}

#pragma mark - Data setup
- (void)setupData
{
    _source_tutorialCommentVM = [NSMutableArray<PIECommentVM *> array];

    _currentCommentIndex      = 0;
    
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
            self.source_tutorialModel.hasBought == NO)
        {
            [tutorialImageCell addSubview:self.lockedUpView];
            
            [self.lockedUpView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(tutorialImageCell);
            }];
            
            [tutorialImageCell setNeedsLayout];
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
        开启两个线程，异步加载两种数据。（刷新UI放到主线程里应该就不会冲突，最多不久加载两次咯）
     */
    [self loadNewTutorialDetails];
    [self loadMoreTutorialComments];

}

- (void)didPullRefreshUp:(UITableView *)tableView
{
    [self loadMoreTutorialComments];
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
             [_tableView.mj_header endRefreshing];
             [_tableView reloadData];
         }];
         
         
     } failureBlock:^{
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [_tableView.mj_header endRefreshing];
         }];
         
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
             [self.source_tutorialCommentVM addObjectsFromArray:recentCommentArray];
             
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [self.tableView reloadData];
             }];
         }
         
     }];
    
}

- (void)rollDiceReward
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"ask_id"] = [@(self.source_tutorialModel.ask_id) stringValue];
    
    [DDBaseService
     GET:params
     url:@"thread/reward"
     block:^(id responseObject) {
         NSDictionary *dataDict = responseObject[@"data"];
         long rollDiceStatus    = [dataDict[@"type"] longValue];
         double balance         = [dataDict[@"balance"] doubleValue];
         double amount          = [dataDict[@"amount"] doubleValue];
         
         if (rollDiceStatus == -1){
             NSString *prompt = [NSString stringWithFormat:@"支付失败：剩余余额%.2f, 需付款%.2f", balance,amount];
             [Hud text:prompt];
         }else if (rollDiceStatus == 1){
             NSString *prompt = [NSString stringWithFormat:@"支付%.2f元，剩余%.2f元", amount, balance];
             [Hud text:prompt];
             
         }else{
             NSString *prompt = [NSString stringWithFormat:@"type == %ld", (long)rollDiceStatus];
             [Hud error:prompt];
         }
     }];
    
}

#pragma mark - Lazy loadings
- (PIEChannelTutorialLockedUpView *)lockedUpView
{
    if (_lockedUpView == nil) {
        _lockedUpView =  [PIEChannelTutorialLockedUpView lockedUpView];
    }
    
    return _lockedUpView;
}


@end
