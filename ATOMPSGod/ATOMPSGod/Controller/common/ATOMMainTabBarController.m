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

//#define  BUTTON_INTERVAL (SCREEN_WIDTH - 30 * 2 - 49 * 4) / 3

@interface ATOMMainTabBarController ()

@property (nonatomic, strong) ATOMCutstomNavigationController *nav1;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav2;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav3;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav4;
//@property (nonatomic, strong) UIView *tabbarView;
//@property (nonatomic, strong) UIButton *btn1;
//@property (nonatomic, strong) UIButton *btn2;
//@property (nonatomic, strong) UIButton *btn3;
//@property (nonatomic, strong) UIButton *btn4;

@end

@implementation ATOMMainTabBarController

//static int h_padding = 30;
////static int v_padding = 13;
////static int btn_width = 18;
////static int btn_height = 23;
//static int v_padding = 0;
//static int btn_width = 49;
//static int btn_height = 49;

#pragma mark - Lazy Initialize

//- (UIView *)tabbarView {
//    if (!_tabbarView) {
//        _tabbarView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//        _tabbarView.backgroundColor = [UIColor colorWithHex:0xffffff andAlpha:0.94];
//        [_tabbarView addSubview:self.btn1];
//        [_tabbarView addSubview:self.btn2];
//        [_tabbarView addSubview:self.btn3];
//        [_tabbarView addSubview:self.btn4];
//    }
//    return _tabbarView;
//}
//
//- (UIButton *)btn1 {
//    if (!_btn1) {
//        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(h_padding, v_padding, btn_width, btn_height)];
//        _btn1.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        _btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _btn1.tag = 1;
//        [_btn1 setImage:[UIImage imageNamed:@"btn_index_normal"] forState:UIControlStateNormal];
//        [_btn1 setImage:[UIImage imageNamed:@"btn_index_pressed"] forState:UIControlStateSelected];
//        [_btn1 setTitle:@"首页" forState:UIControlStateNormal];
//        [_btn1 setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
//        _btn1.titleLabel.font = [UIFont systemFontOfSize:kFont10];
//        [_btn1 setTitleColor:kBlueColor forState:UIControlStateSelected];
//        [_btn1 setImageEdgeInsets:UIEdgeInsetsMake(5, 14, 5, 14)];
//        [_btn1 setTitleEdgeInsets:UIEdgeInsetsMake(35, -6, 0, 6)];
//        [_btn1 addTarget:self action:@selector(clickTab:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btn1;
//}
//
//- (UIButton *)btn2 {
//    if (!_btn2) {
//        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btn1.frame) + BUTTON_INTERVAL, v_padding, btn_width, btn_height)];
//        _btn2.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        _btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _btn2.tag = 2;
//        [_btn2 setImage:[UIImage imageNamed:@"btn_look_normal"] forState:UIControlStateNormal];
//        [_btn2 setImage:[UIImage imageNamed:@"btn_look_pressed"] forState:UIControlStateSelected];
//        [_btn2 setTitle:@"关注" forState:UIControlStateNormal];
//        [_btn2 setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
//        _btn2.titleLabel.font = [UIFont systemFontOfSize:kFont10];
//        [_btn2 setTitleColor:kBlueColor forState:UIControlStateSelected];
//        [_btn2 setImageEdgeInsets:UIEdgeInsetsMake(5, 14, 5, 14)];
//        [_btn2 setTitleEdgeInsets:UIEdgeInsetsMake(35, -6, 0, 6)];
//        [_btn2 addTarget:self action:@selector(clickTab:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btn2;
//}
//
//- (UIButton *)btn3 {
//    if (!_btn3) {
//        _btn3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btn2.frame) + BUTTON_INTERVAL, v_padding, btn_width, btn_height)];
//        _btn3.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        _btn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _btn3.tag = 3;
//        [_btn3 setImage:[UIImage imageNamed:@"btn_info_normal"] forState:UIControlStateNormal];
//        [_btn3 setImage:[UIImage imageNamed:@"btn_info_pressed"] forState:UIControlStateSelected];
//        [_btn3 setTitle:@"消息" forState:UIControlStateNormal];
//        [_btn3 setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
//        _btn3.titleLabel.font = [UIFont systemFontOfSize:kFont10];
//        [_btn3 setTitleColor:kBlueColor forState:UIControlStateSelected];
//        [_btn3 setImageEdgeInsets:UIEdgeInsetsMake(5, 14, 5, 14)];
//        [_btn3 setTitleEdgeInsets:UIEdgeInsetsMake(35, -6, 0, 6)];
//        [_btn3 addTarget:self action:@selector(clickTab:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btn3;
//}
//
//- (UIButton *)btn4 {
//    if (!_btn4) {
//        _btn4 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btn3.frame) + BUTTON_INTERVAL, v_padding, btn_width, btn_height)];
//        _btn4.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        _btn4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _btn4.tag = 4;
//        [_btn4 setImage:[UIImage imageNamed:@"btn_user_normal"] forState:UIControlStateNormal];
//        [_btn4 setImage:[UIImage imageNamed:@"btn_user_pressed"] forState:UIControlStateSelected];
//        [_btn4 setTitle:@"我的" forState:UIControlStateNormal];
//        [_btn4 setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
//        _btn4.titleLabel.font = [UIFont systemFontOfSize:kFont10];
//        [_btn4 setTitleColor:kBlueColor forState:UIControlStateSelected];
//        [_btn4 setImageEdgeInsets:UIEdgeInsetsMake(5, 14, 5, 14)];
//        [_btn4 setTitleEdgeInsets:UIEdgeInsetsMake(35, -6, 0, 6)];
//        [_btn4 addTarget:self action:@selector(clickTab:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btn4;
//}
//
#pragma mark - Config

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureTabBarController];
    }
    return self;
}

- (void)configureTabBarController {
//    static int padding = 0;
    ATOMHomepageViewController *homePageViewController = [ATOMHomepageViewController new];
    ATOMMyAttentionViewController *myAttentionViewController = [ATOMMyAttentionViewController new];
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

//    _nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
//    _nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
//    _nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
//    _nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
//    _nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
//    _nav3.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
//    _nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
//    _nav4.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
    
//    NSLog(@"%f %f %f %f", CGOriginX(self.tabBar.frame), CGOriginY(self.tabBar.frame), CGWidth(self.tabBar.frame), CGHeight(self.tabBar.frame));
//    [self.tabBar addSubview:self.tabbarView];
//    [self clickTab:_btn1];
}

#pragma Event

//- (void)clickTab:(UIButton *)button {
//    _btn1.selected = NO;
//    _btn2.selected = NO;
//    _btn3.selected = NO;
//    _btn4.selected = NO;
//    _btn1.userInteractionEnabled = YES;
//    _btn2.userInteractionEnabled = YES;
//    _btn3.userInteractionEnabled = YES;
//    _btn4.userInteractionEnabled = YES;
//    button.selected = YES;
//    button.userInteractionEnabled = NO;
//    self.selectedIndex = button.tag - 1;
//}


























@end
