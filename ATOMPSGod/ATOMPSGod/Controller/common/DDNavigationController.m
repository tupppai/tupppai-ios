//
//  ATOMCustomNavigationController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDNavigationController.h"
#import "PIECommentViewController.h"

@interface DDNavigationController ()
<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation DDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = self;
    }
    [self setCommonNavigationStyle];
}

- (void)setCommonNavigationStyle {
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:16],NSFontAttributeName, nil]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - overriden methods
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    if ([self isBannedFromTouristViewController:viewController]) {
        // 如果当前用户是临时的游客用户，并且想要跳进一些比较敏感的控制器的话，直接发通知
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PIENetworkCallForFurtherRegistrationNotification
         object:nil];
        
        return;
    }
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark - private helpers
/**
    viewController -> BOOL
 
    check whether the viewController is not for a tourist user.
 */
- (BOOL)isBannedFromTouristViewController:(UIViewController *)viewController
{
    // TODO: 需要阿Ken为我提供更多的数据，目前只有一个评论页
    if ([DDUserManager isTourist] &&
        [viewController isKindOfClass:[PIECommentViewController class]]) {
        return YES;
    }else{
        return NO;
    }
    
}



@end
