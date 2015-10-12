//
//  ATOMCustomNavigationController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDNavigationController.h"

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
    [self setupNav];
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
    if (self.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]]];
        self.navigationItem.leftBarButtonItems = nil;
    } else {
        self.navigationItem.leftBarButtonItems = @[ barBackButtonItem];
    }
}

- (void)setCommonNavigationStyle {
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil]];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    [super pushViewController:viewController animated:animated];
}
//#pragma mark - UINavigationControllerDelegate
//
//- (void)navigationController:(UINavigationController *)navigationController
//       didShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animate {
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        if (self.viewControllers.count == 1) {
//            self.interactivePopGestureRecognizer.enabled = NO;
//        } else {
//            self.interactivePopGestureRecognizer.enabled = YES;
//        }
//    }
//}

@end
