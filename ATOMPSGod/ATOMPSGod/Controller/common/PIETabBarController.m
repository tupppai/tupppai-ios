//
//  ATOMMainTabBarController.m
//  ATOMPSGod
//
//  Created by atom on 1padding/3/3.
//  Copyright (c) 201padding年 ATOM. All rights reserved.
//

#import "PIETabBarController.h"
#import "DDHomeVC.h"
#import "DDMessageVC.h"
#import "PIEEliteViewController.h"
#import "ATOMPersonViewController.h"
#import "DDNavigationController.h"
#import "DDService.h"
#import "PIEMeViewController.h"
#import "PIECameraViewController.h"

#import "PIEProceedingViewController.h"

@interface PIETabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) DDNavigationController *navigation_new;
@property (nonatomic, strong) DDNavigationController *navigation_elite;
@property (nonatomic, strong) DDNavigationController *centerNav;
@property (nonatomic, strong) DDNavigationController *navigation_proceeding;
@property (nonatomic, strong) DDNavigationController *navigation_me;
@property (nonatomic, strong) DDNavigationController *preNav;
@end

@implementation PIETabBarController

#pragma mark - Lazy Initialize

#pragma mark - Config
static dispatch_once_t once;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureTabBarController];
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    [self uploadDeviceInfo];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{   NSForegroundColorAttributeName: [UIColor blackColor],                                                           NSFontAttributeName: [UIFont systemFontOfSize:11]
                                                                                 }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{   NSForegroundColorAttributeName: [UIColor blackColor],                                                           NSFontAttributeName: [UIFont systemFontOfSize:11]
                                                           }
                                             forState:UIControlStateSelected];

    self.delegate = self;
}
-(void)uploadDeviceInfo {
    dispatch_once(&once, ^ {
        NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
        NSString* token = [[NSUserDefaults standardUserDefaults]stringForKey:@"devicetoken"];
        NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:token, @"device_token",@1,@"platform",@([[UIDevice currentDevice].systemVersion floatValue]),@"device_os",deviceName(),@"device_name",[oNSUUID UUIDString],@"device_mac",nil];        
        [DDService updateToken:param withBlock:nil];
    });
}
- (void)configureTabBarController {
    DDHomeVC *homePageViewController = [DDHomeVC new];
    PIEEliteViewController *myAttentionViewController = [PIEEliteViewController new];
    PIEProceedingViewController *proceedingViewController = [PIEProceedingViewController new];
    ATOMPersonViewController *personViewController = [ATOMPersonViewController new];
    PIEMeViewController *vc4 = (PIEMeViewController *)[[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier: @"PIEME"];
    UIViewController* vc = [UIViewController new];
    homePageViewController.title = @"最新";
    myAttentionViewController.title = @"首页";
    proceedingViewController.title = @"进行中";
    personViewController.title = @"我的";
    
    _navigation_new = [[DDNavigationController alloc] initWithRootViewController:homePageViewController];
    _navigation_elite = [[DDNavigationController alloc] initWithRootViewController:myAttentionViewController];
    _navigation_proceeding = [[DDNavigationController alloc] initWithRootViewController:proceedingViewController];
    _navigation_me = [[DDNavigationController alloc] initWithRootViewController:vc4];
    _centerNav = [[DDNavigationController alloc] initWithRootViewController:vc];
    _preNav = _navigation_elite;
    
    _navigation_new.tabBarItem.image = [UIImage imageNamed:@"pie_home"];
    _navigation_new.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_home_selected"];
    _navigation_elite.tabBarItem.image = [UIImage imageNamed:@"pie_follow"];
    _navigation_elite.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_follow_selected"];
    _navigation_proceeding.tabBarItem.image = [UIImage imageNamed:@"pie_doing"];
    _navigation_proceeding.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_doing_selected"];
    _navigation_me.tabBarItem.image = [UIImage imageNamed:@"pie_profile"];
    _navigation_me.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_profile_selected"];
    
    _centerNav.tabBarItem.image = [UIImage imageNamed:@"pie_thirdTab_selected"];

    _navigation_new.tabBarItem.image = [ _navigation_new.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_new.tabBarItem.selectedImage = [ _navigation_new.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_elite.tabBarItem.image = [ _navigation_elite.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_elite.tabBarItem.selectedImage = [ _navigation_elite.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_proceeding.tabBarItem.image = [ _navigation_proceeding.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_proceeding.tabBarItem.selectedImage = [ _navigation_proceeding.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_me.tabBarItem.image = [ _navigation_me.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_me.tabBarItem.selectedImage = [ _navigation_me.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _centerNav.tabBarItem.image = [ _centerNav.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers = [NSArray arrayWithObjects:_navigation_elite, _navigation_new,_centerNav,_navigation_proceeding, _navigation_me, nil];
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == _navigation_new) {
        if (_preNav == _navigation_new) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNavigation_New" object:nil];
        }
    } else if (viewController == _navigation_elite) {
        if (_preNav == _navigation_elite) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNavigation_Elite" object:nil];
        }
    }
        _preNav = (DDNavigationController*)viewController;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == _centerNav) {
        [self presentBlurViewController];
        return NO;
    }
    return YES;
}
- (void)presentBlurViewController {
    PIECameraViewController *pvc = [PIECameraViewController new];
    pvc.blurStyle = UIBlurEffectStyleDark;
    [_preNav presentViewController:pvc animated:YES completion:nil];
}
@end
