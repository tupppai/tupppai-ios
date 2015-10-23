//
//  BaseViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDBaseVC.h"
#import "ATOMUserDAO.h"
#import "DDLoginNavigationController.h"
#import "AppDelegate.h"
#import "SIAlertView.h"
#import "PIELaunchViewController.h"
#import "PIENewViewController.h"
#import "PIEEliteViewController.h"
#import "PIEProceedingViewController.h"
#import "PIEMeViewController.h"
;

@interface DDBaseVC ()

@end

@implementation DDBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObservers];
    [self setupNav];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorOccuredRET) name:@"NetworkErrorCall" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetworkSignOutRET) name:@"NetworkSignOutCall" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfoRET:) name:@"NetworkShowInfoCall" object:nil];
}
- (void)setupNav {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage imageNamed:@"PIE_icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popCurrentController) forControlEvents:UIControlEventTouchUpInside];
//    _negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    _negativeSpacer.width = 0;
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]]];
        self.navigationItem.leftBarButtonItems = nil;
    } else {
        self.navigationItem.leftBarButtonItems = @[ barBackButtonItem];
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkSignOutCall" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkSignOutCall"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkShowInfoCall" object:nil];
    //compiler would call [super dealloc] automatically in ARC.
}
-(void) NetworkSignOutRET {
    SIAlertView *alertView = [KShareManager NetworkErrorOccurredAlertView];
    [alertView addButtonWithTitle:@"好咯"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              //清空数据库用户表
                              [ATOMUserDAO clearUsers];
                              //清空当前用户
                              [[DDUserManager currentUser]wipe];
                              self.navigationController.viewControllers = @[];
                              PIELaunchViewController *lvc = [[PIELaunchViewController alloc] init];
                              [AppDelegate APP].window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}
-(void) errorOccuredRET {
    [Hud text:@"出现未知错误" inView:self.view];
}
-(void) showInfoRET:(NSNotification *)notification {
    NSString* info = [[notification userInfo] valueForKey:@"info"];
    [Hud text:info inView:self.view];
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:viewController animated:animated];
//    if ([self isKindOfClass:[PIENewViewController class]]) {
//        self.hidesBottomBarWhenPushed = NO;
//    } else if ([self isKindOfClass:[PIEEliteViewController class]]){
//        self.hidesBottomBarWhenPushed = NO;
//    } else if ([self isKindOfClass:[PIEProceedingViewController class]]) {
//        self.hidesBottomBarWhenPushed = NO;
//    } else if ([self isKindOfClass:[PIEMeViewController class]]) {
//        self.hidesBottomBarWhenPushed = NO;
//    }
//}

- (void)popCurrentController {
    [self.navigationController popViewControllerAnimated:YES];
}




@end
