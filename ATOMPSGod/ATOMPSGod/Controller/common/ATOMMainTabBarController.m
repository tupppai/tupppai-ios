//
//  ATOMMainTabBarController.m
//  ATOMPSGod
//
//  Created by atom on 1padding/3/3.
//  Copyright (c) 201padding年 ATOM. All rights reserved.
//

#import "ATOMMainTabBarController.h"
#import "ATOMHomepageViewController.h"
#import "ATOMMyMessageViewController.h"
#import "ATOMMyFollowViewController.h"
#import "ATOMPersonViewController.h"
#import "ATOMCutstomNavigationController.h"

//#define  BUTTON_INTERVAL (SCREEN_WIDTH - 30 * 2 - 49 * 4) / 3

@interface ATOMMainTabBarController ()

@property (nonatomic, strong) ATOMCutstomNavigationController *nav1;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav2;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav3;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav4;
@end

@implementation ATOMMainTabBarController

#pragma mark - Lazy Initialize

#pragma mark - Config

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureTabBarController];
    }
    return self;
}

- (void)configureTabBarController {
    ATOMHomepageViewController *homePageViewController = [ATOMHomepageViewController new];
    ATOMMyFollowViewController *myAttentionViewController = [ATOMMyFollowViewController new];
    ATOMMyMessageViewController *myMessageViewController = [ATOMMyMessageViewController new];
    ATOMPersonViewController *personViewController = [ATOMPersonViewController new];
    homePageViewController.title = @"首页";
    myAttentionViewController.title = @"关注";
    myMessageViewController.title = @"消息";
    personViewController.title = @"我的";

    _nav1 = [[ATOMCutstomNavigationController alloc] initWithRootViewController:homePageViewController];
    _nav2 = [[ATOMCutstomNavigationController alloc] initWithRootViewController:myAttentionViewController];
    _nav3 = [[ATOMCutstomNavigationController alloc] initWithRootViewController:myMessageViewController];
    _nav4 = [[ATOMCutstomNavigationController alloc] initWithRootViewController:personViewController];
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

























@end
