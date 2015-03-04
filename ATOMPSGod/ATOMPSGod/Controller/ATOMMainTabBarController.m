//
//  ATOMMainTabBarController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMainTabBarController.h"
#import "ATOMHomepageViewController.h"
#import "ATOMMyMessageViewController.h"
#import "ATOMMyAttentionViewController.h"
#import "ATOMPersonViewController.h"

@interface ATOMMainTabBarController ()

@property (nonatomic, strong) UINavigationController *nav1;
@property (nonatomic, strong) UINavigationController *nav2;
@property (nonatomic, strong) UINavigationController *nav3;
@property (nonatomic, strong) UINavigationController *nav4;

@end

@implementation ATOMMainTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureTabBarController];
    }
    return self;
}

- (void)configureTabBarController {
    ATOMHomepageViewController *homePageViewController = [ATOMHomepageViewController new];
    ATOMMyAttentionViewController *myAttentionViewController = [ATOMMyAttentionViewController new];
    ATOMMyMessageViewController *myMessageViewController = [ATOMMyMessageViewController new];
    ATOMPersonViewController *personViewController = [ATOMPersonViewController new];
    _nav1 = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
    _nav2 = [[UINavigationController alloc] initWithRootViewController:myAttentionViewController];
    _nav3 = [[UINavigationController alloc] initWithRootViewController:myMessageViewController];
    _nav4 = [[UINavigationController alloc] initWithRootViewController:personViewController];
    self.viewControllers = [NSArray arrayWithObjects:_nav1, _nav2, _nav3, _nav4, nil];
    _nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"btn_index_normal"] tag:1];
    _nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"btn_index_pressed"];
    _nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"关注" image:[UIImage imageNamed:@"icon_trend_normal"] tag:2];
    _nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"btn_trend_pressed"];
    _nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"btn_info_normal"] tag:3];
    _nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"btn_info_pressed"];
    _nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"btn_user_normal"] tag:4];
    _nav4.tabBarItem.selectedImage = [UIImage imageNamed:@"btn_user_pressed"];
}



@end
