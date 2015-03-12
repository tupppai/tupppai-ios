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
#import "ATOMMyAttentionViewController.h"
#import "ATOMPersonViewController.h"
#import "ATOMCutstomNavigationController.h"

@interface ATOMMainTabBarController ()

@property (nonatomic, strong) ATOMCutstomNavigationController *nav1;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav2;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav3;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav4;

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
    static int padding = 0;
    ATOMHomepageViewController *homePageViewController = [ATOMHomepageViewController new];
    ATOMMyAttentionViewController *myAttentionViewController = [ATOMMyAttentionViewController new];
    ATOMMyMessageViewController *myMessageViewController = [ATOMMyMessageViewController new];
    ATOMPersonViewController *personViewController = [ATOMPersonViewController new];
    _nav1 = [[ATOMCutstomNavigationController alloc] initWithRootViewController:homePageViewController];
    _nav2 = [[ATOMCutstomNavigationController alloc] initWithRootViewController:myAttentionViewController];
    _nav3 = [[ATOMCutstomNavigationController alloc] initWithRootViewController:myMessageViewController];
    _nav4 = [[ATOMCutstomNavigationController alloc] initWithRootViewController:personViewController];
    self.viewControllers = [NSArray arrayWithObjects:_nav1, _nav2, _nav3, _nav4, nil];
    _nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"btn_index_normal"] selectedImage:[UIImage imageNamed:@"btn_index_pressed"]];
    _nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
    _nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"关注" image:[UIImage imageNamed:@"icon_look_normal"] selectedImage:[UIImage imageNamed:@"btn_look_pressed"]];
    _nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
    _nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"btn_info_normal"] selectedImage:[UIImage imageNamed:@"btn_info_pressed"]];
    _nav3.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
    _nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"btn_user_normal"] selectedImage:[UIImage imageNamed:@"btn_user_pressed"]];
    _nav4.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
}



@end
