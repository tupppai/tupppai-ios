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
#import "DDBaseService.h"

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
        [DDBaseService post:param withUrl:@"account/updateToken" withBlock:nil];
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
    _preNav = (DDNavigationController*)viewController;
}
@end
