//
//  PIEMeViewController.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/10/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMeViewController.h"
#import "CAPSPageMenu.h"
#import "PIEUploadVC.h"
#import "RefreshTableView.h"
#import "ATOMMyCollectionViewController.h"
#import "ATOMMyWorkViewController.h"
#import "ATOMAccountSettingViewController.h"
#import "DDMessageVC.h"

#import "PIEFriendFollowingViewController.h"
#import "PIEFriendFansViewController.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface PIEMeViewController ()<PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *followCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet UIView *pageMenuContainerView;
@property (weak, nonatomic) IBOutlet UILabel *followView;
@property (weak, nonatomic) IBOutlet UILabel *fansView;

@property (weak, nonatomic) IBOutlet UILabel *likedCountLabel;
@property (nonatomic, strong) PWRefreshFooterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;

@property (nonatomic) CAPSPageMenu *pageMenu;
@end

@implementation PIEMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setupPageMenu];
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(pushToSettingViewController)];
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(pushToMessageViewController)];
}
- (void)pushToSettingViewController {
    ATOMAccountSettingViewController* vc = [ATOMAccountSettingViewController new];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)pushToMessageViewController {
    DDMessageVC* vc = [DDMessageVC new];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)setupViews {
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    DDUserManager* user = [DDUserManager currentUser];
    [_avatarView setImageWithURL:[NSURL URLWithString:[DDUserManager currentUser].avatar]];
    _followCountLabel.text = [NSString stringWithFormat:@"%zd",user.attentionNumber];
    _fansCountLabel.text = [NSString stringWithFormat:@"%zd",user.fansNumber];
    _likedCountLabel.text = [NSString stringWithFormat:@"%zd",user.likeNumber];
    [self setupTapGesture];
}

- (void)setupTapGesture {
    _followCountLabel.userInteractionEnabled = YES;
    _fansCountLabel.userInteractionEnabled = YES;
    _followView.userInteractionEnabled = YES;
    _fansView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFollowingVC)];
    UITapGestureRecognizer *tapG22 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFollowingVC)];
    
    [_followCountLabel addGestureRecognizer:tapG2];
    [_followView addGestureRecognizer:tapG22];
    UITapGestureRecognizer *tapG3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFansVC)];
    UITapGestureRecognizer *tapG33 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFansVC)];
    [_fansCountLabel addGestureRecognizer:tapG3];
    [_fansView addGestureRecognizer:tapG33];
}


- (void)pushToFollowingVC {
    PIEFriendFollowingViewController *opvcv = [PIEFriendFollowingViewController new];
    opvcv.uid = [DDUserManager currentUser].uid;
    opvcv.userName = [DDUserManager currentUser].username;
    [self.navigationController pushViewController:opvcv animated:YES];
    
}
- (void)pushToFansVC {
    PIEFriendFansViewController *mfvc = [PIEFriendFansViewController new];
    mfvc.uid = [DDUserManager currentUser].uid;
    mfvc.userName = [DDUserManager currentUser].username;
    [self.navigationController pushViewController:mfvc animated:YES];
}

- (void)setupPageMenu {
    // Array to keep track of controllers in page menu
    NSMutableArray *controllerArray = [NSMutableArray array];
    ATOMMyWorkViewController *controller = [ATOMMyWorkViewController new];
    controller.title = @"图片";
    [controllerArray addObject:controller];
    ATOMMyCollectionViewController *controller2 = [ATOMMyCollectionViewController new];
    controller2.title = @"收藏";
    [controllerArray addObject:controller2];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor pieYellowColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:0.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont systemFontOfSize:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor blackColor],
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                 CAPSPageMenuOptionSelectionIndicatorWidth:@30,
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0, _topContainerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topContainerView.frame.size.height) options:parameters];
    
    [self.view addSubview:_pageMenu.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
