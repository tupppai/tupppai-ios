//
//  BaseViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDBaseVC.h"
#import "DDHomeVC.h"
#import "ATOMPersonViewController.h"
#import "DDFollowVC.h"
#import "DDMessageVC.h"
#import "ATOMUserDAO.h"
#import "DDLoginNavigationController.h"
#import "AppDelegate.h"
#import "SIAlertView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface DDBaseVC ()

@end

@implementation DDBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signOutRET) name:@"SignOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorEccuredRET) name:@"ErrorOccurred" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfoRET:) name:@"ShowInfo" object:nil];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [backButton addTarget:self action:@selector(popCurrentController) forControlEvents:UIControlEventTouchUpInside];
    _negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    _negativeSpacer.width = 0;
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]]];
        self.navigationItem.leftBarButtonItems = nil;
    } else {
        self.navigationItem.leftBarButtonItems = @[_negativeSpacer, barBackButtonItem];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SignOut" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ErrorOccurred"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowInfo" object:nil];
    //compiler would call [super dealloc] automatically in ARC.
}
-(void) signOutRET {
    SIAlertView *alertView = [KShareManager signOutAlertView];
    [alertView addButtonWithTitle:@"好咯"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              //清空数据库用户表
                              [ATOMUserDAO clearUsers];
                              //清空当前用户
                              [[DDUserManager currentUser]wipe];
                              self.navigationController.viewControllers = @[];
                              DDLaunchVC *lvc = [[DDLaunchVC alloc] init];
                              [AppDelegate APP].window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}
-(void) errorEccuredRET {
    [Hud text:@"出现未知错误" inView:self.view];
}
-(void) showInfoRET:(NSNotification *)notification {
    NSString* info = [[notification userInfo] valueForKey:@"info"];
    [Hud text:info inView:self.view];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:animated];
    if ([self isKindOfClass:[DDHomeVC class]]) {
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[ATOMPersonViewController class]]){
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[DDFollowVC class]]) {
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[DDMessageVC class]]) {
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)popCurrentController {
    self.navigationItem.leftBarButtonItem.title = @"";
    [self.navigationController popViewControllerAnimated:YES];
}





@end
