//
//  PIEBasePresentedViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/13/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBasePresentedViewController.h"
#import "ATOMUserDAO.h"
#import "DDLoginNavigationController.h"
#import "AppDelegate.h"
#import "SIAlertView.h"

#import "PIENewViewController.h"
#import "PIEEliteViewController.h"
#import "PIEProceedingViewController.h"
#import "PIEMeViewController.h"
@interface PIEBasePresentedViewController ()

@end

@implementation PIEBasePresentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObservers];
    [self setupNav];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signOutRET) name:@"SignOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorEccuredRET) name:@"ErrorOccurred" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfoRET:) name:@"ShowInfo" object:nil];
}
- (void)setupNav {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;    //this line make image align to left
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    backButton.imageView.contentMode = UIViewContentModeTopLeft;
    [backButton setImage:[UIImage imageNamed:@"PIE_icon_back"] forState:UIControlStateNormal];
    [backView addSubview:backButton];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [backButton addTarget:self action:@selector(popCurrentController) forControlEvents:UIControlEventTouchUpInside];

    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]]];
        self.navigationItem.leftBarButtonItem = barBackButtonItem;
    } else {
        self.navigationItem.leftBarButtonItem = barBackButtonItem;
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
                              PIELaunchViewController *lvc = [[PIELaunchViewController alloc] init];
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



- (void)popCurrentController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
