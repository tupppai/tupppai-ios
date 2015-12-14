//
//  ATOMMainTabBarController.m
//  ATOMPSGod
//
//  Created by atom on 1padding/3/3.
//  Copyright (c) 201padding年 ATOM. All rights reserved.
//

#import "PIETabBarController.h"
#import "PIEChannelViewController.h"
#import "PIEEliteViewController.h"
#import "DDNavigationController.h"
#import "DDService.h"
#import "PIEMeViewController.h"
#import "PIECameraViewController.h"
#import "PIEProceedingViewController.h"
#import "AppDelegate.h"
#import "DDLoginNavigationController.h"
#import "ATOMUserDAO.h"
#import "PIEUploadManager.h"
#import "UIImage+Colors.h"
@interface PIETabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) DDNavigationController *navigation_new;
@property (nonatomic, strong) DDNavigationController *navigation_elite;
//@property (nonatomic, strong) DDNavigationController *centerNav;
@property (nonatomic, strong) DDNavigationController *navigation_proceeding;
@property (nonatomic, strong) DDNavigationController *navigation_me;
@property (nonatomic, strong) DDNavigationController *preNav;
@end

@implementation PIETabBarController

#pragma mark - Lazy Initialize

#pragma mark - Config

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureTabBarController];
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setupTitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetworkSignOutRET) name:@"NetworkSignOutCall" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoUploadJob:) name:@"UploadCall" object:nil];
}

- (void)setupTitle {
    [[UITabBarItem appearance] setTitleTextAttributes:@{   NSForegroundColorAttributeName: [UIColor blackColor],                                                           NSFontAttributeName: [UIFont systemFontOfSize:10]
                                                           }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{   NSForegroundColorAttributeName: [UIColor blackColor],                                                           NSFontAttributeName: [UIFont systemFontOfSize:10]
                                                           }
                                             forState:UIControlStateSelected];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadCall"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkSignOutCall"object:nil];
}
- (void) DoUploadJob:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    PIEEliteViewController* vc = (PIEEliteViewController*)((DDNavigationController*)[self.viewControllers objectAtIndex:0]).topViewController;
    PIEUploadManager* manager = [PIEUploadManager new];
    manager.uploadInfo = info;
    [manager upload:^(CGFloat percentage,BOOL success) {
        [vc.progressView setProgress:percentage animated:YES];
        if (success) {
            if ([manager.type isEqualToString:@"ask"]) {
                
            } else if ([manager.type isEqualToString:@"reply"]) {

            }
        }
    }];
}
-(void) NetworkSignOutRET {
    SIAlertView *alertView = [KShareManager NetworkErrorOccurredAlertView];
    [alertView addButtonWithTitle:@"好的"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              //清空数据库用户表
                              [ATOMUserDAO clearUsers];
                              //清空当前用户
                              [DDUserManager clearCurrentUser];
                              self.navigationController.viewControllers = @[];
                              PIELaunchViewController *lvc = [[PIELaunchViewController alloc] init];
                              [AppDelegate APP].window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}


- (void)configureTabBarController {
    
    PIEChannelViewController *channelVc = [PIEChannelViewController new];
    PIEEliteViewController *myAttentionViewController = [PIEEliteViewController new];
    PIEProceedingViewController *proceedingViewController = [PIEProceedingViewController new];
    
    PIEMeViewController *aboutMeVC = (PIEMeViewController *)[[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier: @"PIEME"];
    
    myAttentionViewController.title = @"首页";
    channelVc.title                 = @"图派";
    proceedingViewController.title  = @"进行中";
    aboutMeVC.title                 = @"我的";
    
    
    
    _navigation_new = [[DDNavigationController alloc] initWithRootViewController:channelVc];
    _navigation_elite = [[DDNavigationController alloc] initWithRootViewController:myAttentionViewController];
    _navigation_proceeding = [[DDNavigationController alloc] initWithRootViewController:proceedingViewController];
    _navigation_me = [[DDNavigationController alloc] initWithRootViewController:aboutMeVC];
//    _centerNav = [[DDNavigationController alloc] initWithRootViewController:takePhotoVC];
    _preNav = _navigation_elite;
    
    _navigation_elite.tabBarItem.image =
    [[UIImage imageNamed:@"pie_tab_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    _navigation_elite.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"pie_tab_1_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _navigation_new.tabBarItem.image =
    [[UIImage imageNamed:@"pie_tab_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_new.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"pie_tab_2_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_proceeding.tabBarItem.image =
    [[UIImage imageNamed:@"pie_tab_4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_proceeding.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"pie_tab_4_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    _navigation_me.tabBarItem.image =
    [[UIImage imageNamed:@"pie_tab_5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_me.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"pie_tab_5_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self updateTabbarAvatar];
//        [_centerNav.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    self.viewControllers = [NSArray arrayWithObjects:_navigation_elite, _navigation_new,_navigation_proceeding, _navigation_me, nil];
}


- (void)updateTabbarAvatar {
    [DDService downloadImage:[DDUserManager currentUser].avatar withBlock:^(UIImage *image) {
        if (image) {
            UIImage* scaledImage = [Util imageWithImage:image scaledToSize:CGSizeMake(28, 28) circlize:YES];
            _avatarImage = scaledImage;
            _navigation_me.tabBarItem.image = [_avatarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            _navigation_me.tabBarItem.selectedImage = [[_avatarImage maskWithImage:[UIImage imageFromColor:[UIColor colorWithHex:0xe23022 andAlpha:0.7]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == _navigation_new) {
        if (_preNav == _navigation_new) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNavigation_New" object:nil];
        }
    } else if (viewController == _navigation_elite) {
        if (_preNav == _navigation_elite) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNavigation_Elite" object:nil];
        }
    }
        _preNav = (DDNavigationController*)viewController;
}

//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (viewController == _centerNav) {
//        [self presentBlurViewController];
//        return NO;
//    }
//    return YES;
//}
//- (void)presentBlurViewController {
//    PIECameraViewController *pvc = [PIECameraViewController new];
//    pvc.blurStyle = UIBlurEffectStyleDark;
//    [self presentViewController:pvc animated:YES completion:nil];
//}


@end
