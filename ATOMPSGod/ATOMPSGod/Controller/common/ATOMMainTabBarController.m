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

#define  BUTTON_INTERVAL (SCREEN_WIDTH - 30 * 2 - 49 * 4) / 3

@interface ATOMMainTabBarController ()

@property (nonatomic, strong) ATOMCutstomNavigationController *nav1;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav2;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav3;
@property (nonatomic, strong) ATOMCutstomNavigationController *nav4;
@property (nonatomic, strong) UIView *tabbarView;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;

@end

@implementation ATOMMainTabBarController

static int h_padding = 30;
//static int v_padding = 13;
//static int btn_width = 18;
//static int btn_height = 23;
static int v_padding = 0;
static int btn_width = 49;
static int btn_height = 49;

#pragma mark - Lazy Initialize

- (UIView *)tabbarView {
    if (!_tabbarView) {
        _tabbarView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
        _tabbarView.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
        [_tabbarView addSubview:self.btn1];
        [_tabbarView addSubview:self.btn2];
        [_tabbarView addSubview:self.btn3];
        [_tabbarView addSubview:self.btn4];
    }
    return _tabbarView;
}

- (UIButton *)btn1 {
    if (!_btn1) {
        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(h_padding, v_padding, btn_width, btn_height)];
        _btn1.tag = 1;
        [_btn1 setImage:[UIImage imageNamed:@"btn_index_normal"] forState:UIControlStateNormal];
        [_btn1 setImage:[UIImage imageNamed:@"btn_index_pressed"] forState:UIControlStateSelected];
        [_btn1 addTarget:self action:@selector(clickTab:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

- (UIButton *)btn2 {
    if (!_btn2) {
        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btn1.frame) + BUTTON_INTERVAL, v_padding, btn_width, btn_height)];
        _btn2.tag = 2;
        [_btn2 setImage:[UIImage imageNamed:@"btn_look_normal"] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"btn_look_pressed"] forState:UIControlStateSelected];
        [_btn2 addTarget:self action:@selector(clickTab:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}

- (UIButton *)btn3 {
    if (!_btn3) {
        _btn3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btn2.frame) + BUTTON_INTERVAL, v_padding, btn_width, btn_height)];
        _btn3.tag = 3;
        [_btn3 setImage:[UIImage imageNamed:@"btn_info_normal"] forState:UIControlStateNormal];
        [_btn3 setImage:[UIImage imageNamed:@"btn_info_pressed"] forState:UIControlStateSelected];
        [_btn3 addTarget:self action:@selector(clickTab:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn3;
}

- (UIButton *)btn4 {
    if (!_btn4) {
        _btn4 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btn3.frame) + BUTTON_INTERVAL, v_padding, btn_width, btn_height)];
        _btn4.tag = 4;
        [_btn4 setImage:[UIImage imageNamed:@"btn_user_normal"] forState:UIControlStateNormal];
        [_btn4 setImage:[UIImage imageNamed:@"btn_user_pressed"] forState:UIControlStateSelected];
        [_btn4 addTarget:self action:@selector(clickTab:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn4;
}

#pragma mark - Config

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
    _nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    _nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
    _nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    _nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
    _nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    _nav3.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
    _nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    _nav4.tabBarItem.imageInsets = UIEdgeInsetsMake(padding, 0, -padding, 0);
    
    NSLog(@"%f %f %f %f", CGOriginX(self.tabBar.frame), CGOriginY(self.tabBar.frame), CGWidth(self.tabBar.frame), CGHeight(self.tabBar.frame));
    [self.tabBar addSubview:self.tabbarView];
    [self clickTab:_btn1];
}

#pragma Event

- (void)clickTab:(UIButton *)button {
    _btn1.selected = NO;
    _btn2.selected = NO;
    _btn3.selected = NO;
    _btn4.selected = NO;
    _btn1.userInteractionEnabled = YES;
    _btn2.userInteractionEnabled = YES;
    _btn3.userInteractionEnabled = YES;
    _btn4.userInteractionEnabled = YES;
    button.selected = YES;
    button.userInteractionEnabled = NO;
    self.selectedIndex = button.tag - 1;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    basicAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    basicAnimation.duration = 1;
    [button.layer addAnimation:basicAnimation forKey:@"btn_animation"];
}


























@end
