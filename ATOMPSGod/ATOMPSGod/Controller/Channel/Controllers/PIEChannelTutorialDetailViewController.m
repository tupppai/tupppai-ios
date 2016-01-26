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

#import "PIERefreshTableView.h"




@interface PIEChannelTutorialDetailViewController ()
<
    /* Protocols */
    UITableViewDelegate, UITableViewDataSource,
    PWRefreshBaseTableViewDelegate
>
/* Variables */

@property (nonatomic, strong) PIERefreshTableView *tableView;

@property (nonatomic, strong) PIEChannelTutorialModel *source_tutorialModel;

@property (nonatomic, strong) NSMutableArray<PIECommentModel *> *source_tutorialComment;

@end

@implementation PIEChannelTutorialDetailViewController

static NSString *PIEChannelTutorialTeacherDescTableViewCellIdentifier =
@"PIEChannelTutorialTeacherDescTableViewCell";

static NSString *PIEChannelTutorialPrefaceTableViewCellIdentifier =
@"PIEChannelTutorialPrefaceTableViewCell";

static NSString *PIEChannelTutorialImageTableViewCelIdentifier =
@"PIEChannelTutorialImageTableViewCell";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupData];
    
    [self setupSubviews];
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
        
        
        [tableView registerNib:[UINib nibWithNibName:@"PIEChannelTutorialTeacherDescTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:PIEChannelTutorialTeacherDescTableViewCellIdentifier];
        
        [tableView registerNib:[UINib nibWithNibName:@"PIEChannelTutorialPrefaceTableViewCell" bundle:nil]
        forCellReuseIdentifier:PIEChannelTutorialPrefaceTableViewCellIdentifier];
        
        [tableView registerNib:[UINib nibWithNibName:@"PIEChannelTutorialImageTableViewCell" bundle:nil]
        forCellReuseIdentifier:PIEChannelTutorialImageTableViewCelIdentifier];
        
        [self.view addSubview:tableView];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        
        tableView;
    });
    
    self.tableView = tableView;
}

- (void)setupData
{
    
    
    
    _source_tutorialComment = [NSMutableArray<PIECommentModel *> new];
    
}

#pragma mark - Data setup

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
            break;
        }
        case 1:
        {
            return 1;
            break;
        }
        case 2:
        {
            return self.currentTutorialModel.tutorial_images.count;
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
        [teacherDescCell injectModel:self.currentTutorialModel];
        
        return teacherDescCell;
    }
    else if (indexPath.section == 1){
        PIEChannelTutorialPrefaceTableViewCell *prefaceCell =
        [tableView dequeueReusableCellWithIdentifier:
         PIEChannelTutorialPrefaceTableViewCellIdentifier];
        
        [prefaceCell injectModel:self.currentTutorialModel];
        
        return prefaceCell;
    }
    else if (indexPath.section == 2){
        PIEChannelTutorialImageTableViewCell *tutorialImageCell =
        [tableView dequeueReusableCellWithIdentifier:
         PIEChannelTutorialImageTableViewCelIdentifier];
        
        PIEChannelTutorialImageModel *imageModel =
        self.currentTutorialModel.tutorial_images[indexPath.row];
        
        [tutorialImageCell injectImageModel:imageModel];
        
        return tutorialImageCell;
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
        self.currentTutorialModel.tutorial_images[indexPath.row];
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
    }else{
        return 0;
    }
}

#pragma mark - <PWRefreshBaseTableViewDelegate>
- (void)didPullRefreshDown:(UITableView *)tableView
{
    [self loadNewTutorialDetails];
}

- (void)didPullRefreshUp:(UITableView *)tableView
{
    [self loadMoreTutorialDetails];
}

#pragma mark - Network request 
- (void)loadNewTutorialDetails
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)loadMoreTutorialDetails
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
}

@end
