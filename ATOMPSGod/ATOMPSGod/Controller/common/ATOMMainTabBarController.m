//
//  ATOMMainTabBarController.m
//  ATOMPSGod
//
//  Created by atom on 1padding/3/3.
//  Copyright (c) 201padding年 ATOM. All rights reserved.
//

#import "ATOMMainTabBarController.h"
#import "HomeViewController.h"
#import "ATOMMyMessageViewController.h"
#import "ATOMMyFollowViewController.h"
#import "ATOMPersonViewController.h"
#import "ATOMCustomNavigationController.h"
#import "ATOMBaseRequest.h"

@interface ATOMMainTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) ATOMCustomNavigationController *nav1;
@property (nonatomic, strong) ATOMCustomNavigationController *nav2;
@property (nonatomic, strong) ATOMCustomNavigationController *nav3;
@property (nonatomic, strong) ATOMCustomNavigationController *nav4;
@property (nonatomic, strong) ATOMCustomNavigationController *preNav;

@end

@implementation ATOMMainTabBarController

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
        [ATOMBaseRequest post:param withUrl:@"user/device_token" withBlock:nil];
    });
}
- (void)configureTabBarController {
    HomeViewController *homePageViewController = [HomeViewController new];
    ATOMMyFollowViewController *myAttentionViewController = [ATOMMyFollowViewController new];
    ATOMMyMessageViewController *myMessageViewController = [ATOMMyMessageViewController new];
    ATOMPersonViewController *personViewController = [ATOMPersonViewController new];
    homePageViewController.title = @"首页";
    myAttentionViewController.title = @"关注";
    myMessageViewController.title = @"消息";
    personViewController.title = @"我的";
    _nav1 = [[ATOMCustomNavigationController alloc] initWithRootViewController:homePageViewController];
    _nav2 = [[ATOMCustomNavigationController alloc] initWithRootViewController:myAttentionViewController];
    _nav3 = [[ATOMCustomNavigationController alloc] initWithRootViewController:myMessageViewController];
    _nav4 = [[ATOMCustomNavigationController alloc] initWithRootViewController:personViewController];
    _nav1.tabBarItem.image = [UIImage imageNamed:@"btn_index_normal"];
    _nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"btn_index_pressed"];
    _nav2.tabBarItem.image = [UIImage imageNamed:@"btn_look_normal"];
    _nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"btn_look_pressed"];
    _nav3.tabBarItem.image = [UIImage imageNamed:@"btn_info_normal"];
    _nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"btn_info_pressed"];
    _nav4.tabBarItem.image = [UIImage imageNamed:@"btn_user_normal"];
    _nav4.tabBarItem.selectedImage = [UIImage imageNamed:@"btn_user_pressed"];
    
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
    _preNav = (ATOMCustomNavigationController*)viewController;
}
@end
