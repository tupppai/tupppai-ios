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
#import "PIERefreshTableView.h"
#import "PIEMyCollectionViewController.h"
#import "PIEMyReplyViewController.h"
#import "PIESettingsViewController.h"
#import "FXBlurView.h"
#import "PIEMyAskViewController.h"

#import "BBBadgeBarButtonItem.h"
#import "PIENotificationViewController.h"
#import "PIEMyFollowViewController.h"
#import "PIEMyFansViewController.h"
#import "DDOtherUserManager.h"

@interface PIEMeViewController ()<PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource,CAPSPageMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *dotView2;
@property (weak, nonatomic) IBOutlet UIView *dotView1;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followView;
@property (weak, nonatomic) IBOutlet UILabel *fansView;
@property (weak, nonatomic) IBOutlet UILabel *likeView;

@property (weak, nonatomic) IBOutlet UIImageView *topContainerView;
@property (weak, nonatomic) IBOutlet UIView *pageMenuContainerView;
@property (weak, nonatomic) IBOutlet UIView *avatarContainerView;

@property (nonatomic, strong) PWRefreshFooterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) CGPoint startPanLocation;

@property (nonatomic) CAPSPageMenu *pageMenu;

@property (nonatomic, assign) long long timeStamp_updateCurrentUser;

@end


@implementation PIEMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setupViews];
    [self setupPageMenu];
    [self updateViewsWithData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollUp)
                                                 name:@"PIEMeScrollUp"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollDown)
                                                 name:@"PIEMeScrollDown"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNoticationStatus)
                                                 name:@"updateNoticationStatus"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PIEMeScrollUp" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PIEMeScrollDown" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateNoticationStatus" object:nil];
}
- (void)setupNavBar {
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage imageNamed:@"pie_message"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"pie_message_new"] forState:UIControlStateSelected];
    [backButton addTarget:self action:@selector(pushToMessageViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem =  barBackButtonItem;
    
    
    UIButton *buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    buttonLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [buttonLeft setImage:[UIImage imageNamed:@"pie_setting"] forState:UIControlStateNormal];
    [buttonLeft addTarget:self action:@selector(pushToSettingViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem =  buttonItem;
    
    [self hideNavitionBarTitleView];

}
- (void)hideNavitionBarTitleView {
    UILabel *label = [[UILabel alloc] init];
    self.navigationItem.titleView = label;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//
    
    self.edgesForExtendedLayout = UIRectEdgeAll;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    [self updateNoticationStatus];
    [MobClick beginLogPageView:@"进入我的"];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    [MobClick endLogPageView:@"离开我的"];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self update];
}

- (void)update {
    BOOL shouldUpdate = NO;
    long long currentTimeStamp = [[NSDate date]timeIntervalSince1970];
    if (_timeStamp_updateCurrentUser) {
        long long timeStamp_gap = currentTimeStamp - _timeStamp_updateCurrentUser;
        if (timeStamp_gap>300) {
            shouldUpdate = YES;
            _timeStamp_updateCurrentUser = currentTimeStamp;
        } else {
            shouldUpdate = NO;
        }
    } else {
        shouldUpdate = YES;
        _timeStamp_updateCurrentUser = currentTimeStamp;
    }
    
    if (shouldUpdate) {
        
        [DDUserManager DDGetUserInfoAndUpdateMe:^(BOOL success) {
            if (success) {
                [self updateViewsWithData];
            }
        }];
    }

}


- (void)updateNoticationStatus {
    if ( [[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationNew"]boolValue]) {
        UIButton *btn =  self.navigationItem.rightBarButtonItem.customView;
        btn.selected = YES;
    } else {
        UIButton *btn =  self.navigationItem.rightBarButtonItem.customView;
        btn.selected = NO;
        [self clearRedDot];
    }
}


- (void)clearRedDot {
    for (UIView* subview in self.tabBarController.tabBar.subviews) {
        if (subview && subview.tag == 1314) {
            [subview removeFromSuperview];
            break;
        }
    }
}
-(void)updateAvatar {
        [DDService downloadImage:[DDUserManager currentUser].avatar withBlock:^(UIImage *image) {
            _avatarView.image = image;
            _topContainerView.image = [image blurredImageWithRadius:100 iterations:5 tintColor:nil];
    }];
}
- (void)pushToSettingViewController {
    PIESettingsViewController* vc = [PIESettingsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushToMessageViewController {
    PIENotificationViewController* vc = [PIENotificationViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setupViews {
    
    UIView* viewBG = [[UIView alloc]initWithFrame:_topContainerView.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = viewBG.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [viewBG.layer insertSublayer:gradient atIndex:0];
    [self.view insertSubview:viewBG belowSubview:self.topContainerView];
    
    _dotView1.layer.cornerRadius = _dotView1.frame.size.width/2;
    _dotView2.layer.cornerRadius = _dotView2.frame.size.width/2;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarContainerView.layer.cornerRadius = _avatarContainerView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    
    [self setupColorAndFont];
    [self setupTapGesture];
}

- (void)setupColorAndFont {
    [ _usernameLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [ _followCountLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [ _followView setFont:[UIFont boldSystemFontOfSize:12]];
    [ _likedCountLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [ _likeView setFont:[UIFont boldSystemFontOfSize:12]];
    [ _fansCountLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [ _fansView setFont:[UIFont boldSystemFontOfSize:12]];

    [_usernameLabel setTextColor:[UIColor colorWithHex:0xffffff andAlpha:1.0]];
    [_followCountLabel setTextColor:[UIColor colorWithHex:0xffffff andAlpha:0.8]];
    [_followView setTextColor:[UIColor colorWithHex:0xffffff andAlpha:0.8]];
    [_fansCountLabel setTextColor:[UIColor colorWithHex:0xffffff andAlpha:0.8]];
    [_fansView setTextColor:[UIColor colorWithHex:0xffffff andAlpha:0.8]];
    [_likeView setTextColor:[UIColor colorWithHex:0xffffff andAlpha:0.8]];
    [_likedCountLabel setTextColor:[UIColor colorWithHex:0xffffff andAlpha:0.8]];

}
- (void)updateViewsWithData {
    PIEEntityUser* user = [DDUserManager currentUser];
    _usernameLabel.text = user.nickname;
    _followCountLabel.text = [NSString stringWithFormat:@"%zd",user.attentionNumber];
    _fansCountLabel.text = [NSString stringWithFormat:@"%zd",user.fansNumber];
    _likedCountLabel.text = [NSString stringWithFormat:@"%zd",user.likedCount];
    [self updateAvatar];
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
    PIEMyFollowViewController *opvcv = [PIEMyFollowViewController new];
    [self.navigationController pushViewController:opvcv animated:YES];
}
- (void)pushToFansVC {
    PIEMyFansViewController *mfvc = [PIEMyFansViewController new];
    [self.navigationController pushViewController:mfvc animated:YES];
}

- (void)setupPageMenu {
    // Array to keep track of controllers in page menu
    
    NSMutableArray *controllerArray = [NSMutableArray array];
    PIEMyAskViewController *controller3 = [PIEMyAskViewController new];
    controller3.title = @"求P";
    [controllerArray addObject:controller3];
    
    PIEMyReplyViewController *controller = [PIEMyReplyViewController new];
    controller.title = @"作品";
    [controllerArray addObject:controller];
    
    PIEMyCollectionViewController *controller2 = [PIEMyCollectionViewController new];
    controller2.title = @"收藏";
    [controllerArray addObject:controller2];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor pieYellowColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithHex:0x000000 andAlpha:0.1],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont boldSystemFontOfSize:15.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor blackColor],
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                 CAPSPageMenuOptionSelectionIndicatorWidth:@30,
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0, 0, SCREEN_WIDTH, 100) options:parameters];
    _pageMenu.view.backgroundColor = [UIColor whiteColor];
    _pageMenu.view.layer.borderColor = [UIColor colorWithHex:0x000000 andAlpha:0.1].CGColor;
    _pageMenu.view.layer.borderWidth = 0.5;
    [self.view addSubview:_pageMenu.view];
    [_pageMenu.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainerView.mas_bottom).with.priorityHigh();
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

}

- (void)scrollUp {
    if (_pageMenu.view.frame.origin.y != 60) {
        [self.pageMenu.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topContainerView.mas_bottom).with.offset(-self.topContainerView.frame.size.height+60).with.priorityHigh();
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [self.pageMenu.view layoutIfNeeded];
        }];
    }

}
- (void)scrollDown {
    if (_pageMenu.view.frame.origin.y != self.topContainerView.frame.size.height) {
        [self.pageMenu.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topContainerView.mas_bottom).with.offset(0).with.priorityHigh();
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [self.pageMenu.view layoutIfNeeded];
        }];
    }
}


@end
