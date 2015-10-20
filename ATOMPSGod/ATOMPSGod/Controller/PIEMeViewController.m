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
#import "DDMessageVC.h"
#import "UIImage+Blurring.h"
#import "FXBlurView.h"
#import "PIEFriendFollowingViewController.h"
#import "PIEFriendFansViewController.h"
#import "PIEMyAskViewController.h"


#import "PIENotificationViewController.h"
@interface PIEMeViewController ()<PWRefreshBaseCollectionViewDelegate,DZNEmptyDataSetSource,CAPSPageMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *dotView2;
@property (weak, nonatomic) IBOutlet UIView *dotView1;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *followCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topContainerView;
@property (weak, nonatomic) IBOutlet UIView *pageMenuContainerView;
@property (weak, nonatomic) IBOutlet UILabel *followView;
@property (weak, nonatomic) IBOutlet UILabel *fansView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *avatarContainerView;

@property (weak, nonatomic) IBOutlet UILabel *likedCountLabel;
@property (nonatomic, strong) PWRefreshFooterCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *homeImageDataSource;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFooter;
@property (nonatomic, assign) CGPoint startPanLocation;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollUp)
                                                 name:@"PIEMeScrollUp"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollDown)
                                                 name:@"PIEMeScrollDown"
                                               object:nil];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];

}
- (void)pushToSettingViewController {
    PIESettingsViewController* vc = [PIESettingsViewController new];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)pushToMessageViewController {
    PIENotificationViewController* vc = [PIENotificationViewController new];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)setupViews {
    _dotView1.layer.cornerRadius = _dotView1.frame.size.width/2;
    _dotView2.layer.cornerRadius = _dotView2.frame.size.width/2;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarContainerView.layer.cornerRadius = _avatarContainerView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    DDUserManager* user = [DDUserManager currentUser];
//    [_avatarView setImageWithURL:[NSURL URLWithString:[DDUserManager currentUser].avatar]];
    NSURLRequest* req = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[DDUserManager currentUser].avatar]];

    [_avatarView setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
        _avatarView.image = image;
        _topContainerView.image = [image blurredImageWithRadius:40 iterations:1 tintColor:nil];
    } failure:nil];
    _usernameLabel.text = user.username;
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
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0, _topContainerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topContainerView.frame.size.height) options:parameters];
    _pageMenu.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _pageMenu.delegate = self;
    [self.view addSubview:_pageMenu.view];
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [_pageMenu.view addGestureRecognizer:panGesture];
}
- (void)panGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        _startPanLocation = [sender locationInView:self.view];
    }
    if (_pageMenu.view.frame.origin.y >= 0 && _pageMenu.view.frame.origin.y <= 140) {
        
        CGFloat dif = [sender locationInView:self.view].y - _startPanLocation.y;
        CGFloat y = _pageMenu.view.frame.origin.y +  dif ;
        y = MIN(y, 140);
        y = MAX(y, 0);
       
        _pageMenu.view.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        _startPanLocation = [sender locationInView:self.view];
    }
}
- (void)scrollUp {
    if (_pageMenu.view.frame.origin.y != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            _pageMenu.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }

}
- (void)scrollDown {
    if (_pageMenu.view.frame.origin.y != 140) {
        [UIView animateWithDuration:0.5 animations:^{
            _pageMenu.view.frame = CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
}


@end
