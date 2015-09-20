//
//  ATOMMainTabBarController.m
//  ATOMPSGod
//
//  Created by atom on 1padding/3/3.
//  Copyright (c) 201padding年 ATOM. All rights reserved.
//

#import "DDTabBarController.h"
#import "DDHomeVC.h"
#import "DDMessageVC.h"
#import "PIEEliteViewController.h"
#import "ATOMPersonViewController.h"
#import "DDNavigationController.h"
#import "DDService.h"
#import "PIEMeViewController.h"
#import "PIECameraViewController.h"

#import "PIEProceedingViewController.h"

@interface DDTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) DDNavigationController *nav1;
@property (nonatomic, strong) DDNavigationController *nav2;
@property (nonatomic, strong) DDNavigationController *centerNav;
@property (nonatomic, strong) DDNavigationController *nav3;
@property (nonatomic, strong) DDNavigationController *nav4;
@property (nonatomic, strong) DDNavigationController *preNav;
@end

@implementation DDTabBarController

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
    myAttentionViewController.title = @"精选";
    proceedingViewController.title = @"进行中";
    personViewController.title = @"我的";
    
    _nav1 = [[DDNavigationController alloc] initWithRootViewController:homePageViewController];
    _nav2 = [[DDNavigationController alloc] initWithRootViewController:myAttentionViewController];
    _nav3 = [[DDNavigationController alloc] initWithRootViewController:proceedingViewController];
    _nav4 = [[DDNavigationController alloc] initWithRootViewController:vc4];
    _centerNav = [[DDNavigationController alloc] initWithRootViewController:vc];
    _preNav = _nav1;
    _nav1.tabBarItem.image = [UIImage imageNamed:@"pie_home"];
    _nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_home_selected"];
    _nav2.tabBarItem.image = [UIImage imageNamed:@"pie_follow"];
    _nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_follow_selected"];
    _nav3.tabBarItem.image = [UIImage imageNamed:@"pie_doing"];
    _nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_doing_selected"];
    _nav4.tabBarItem.image = [UIImage imageNamed:@"pie_profile"];
    _nav4.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_profile_selected"];
    
    _centerNav.tabBarItem.image = [UIImage imageNamed:@"pie_thirdTab_selected"];

    _nav1.tabBarItem.image = [ _nav1.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav1.tabBarItem.selectedImage = [ _nav1.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav2.tabBarItem.image = [ _nav2.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav2.tabBarItem.selectedImage = [ _nav2.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav3.tabBarItem.image = [ _nav3.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav3.tabBarItem.selectedImage = [ _nav3.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav4.tabBarItem.image = [ _nav4.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav4.tabBarItem.selectedImage = [ _nav4.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _centerNav.tabBarItem.image = [ _centerNav.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers = [NSArray arrayWithObjects:_nav1, _nav2,_centerNav,_nav3, _nav4, nil];
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == _nav1) {
        if (_preNav == _nav1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNav1" object:nil];
        }
    } else if (viewController == _nav2) {
        if (_preNav == _nav2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNav2" object:nil];
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
