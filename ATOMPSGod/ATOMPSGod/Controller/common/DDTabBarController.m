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
#import "DDFollowVC.h"
#import "ATOMPersonViewController.h"
#import "DDNavigationController.h"
#import "DDService.h"

@interface DDTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) DDNavigationController *nav1;
@property (nonatomic, strong) DDNavigationController *nav2;
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
    DDFollowVC *myAttentionViewController = [DDFollowVC new];
    DDMessageVC *myMessageViewController = [DDMessageVC new];
    ATOMPersonViewController *personViewController = [ATOMPersonViewController new];
    homePageViewController.title = @"首页";
    myAttentionViewController.title = @"关注";
    myMessageViewController.title = @"消息";
    personViewController.title = @"我的";
    
    _nav1 = [[DDNavigationController alloc] initWithRootViewController:homePageViewController];
    _nav2 = [[DDNavigationController alloc] initWithRootViewController:myAttentionViewController];
    _nav3 = [[DDNavigationController alloc] initWithRootViewController:myMessageViewController];
    _nav4 = [[DDNavigationController alloc] initWithRootViewController:personViewController];
    
    _nav1.tabBarItem.image = [UIImage imageNamed:@"pie_home"];
    _nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_home_selected"];
    _nav2.tabBarItem.image = [UIImage imageNamed:@"pie_follow"];
    _nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_follow_selected"];
    _nav3.tabBarItem.image = [UIImage imageNamed:@"pie_doing"];
    _nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_doing_selected"];
    _nav4.tabBarItem.image = [UIImage imageNamed:@"pie_profile"];
    _nav4.tabBarItem.selectedImage = [UIImage imageNamed:@"pie_profile_selected"];
    
    _nav1.tabBarItem.image = [ _nav1.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav1.tabBarItem.selectedImage = [ _nav1.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav2.tabBarItem.image = [ _nav2.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav2.tabBarItem.selectedImage = [ _nav2.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav3.tabBarItem.image = [ _nav3.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav3.tabBarItem.selectedImage = [ _nav3.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav4.tabBarItem.image = [ _nav4.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _nav4.tabBarItem.selectedImage = [ _nav4.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers = [NSArray arrayWithObjects:_nav1, _nav2, _nav3, _nav4, nil];
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
@end