//
//  ATOMCustomNavigationController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCustomNavigationController.h"

@interface ATOMCustomNavigationController ()
<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation ATOMCustomNavigationController

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
//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//    [self.navigationBar setBarTintColor:color];
    [self.navigationBar setBarTintColor:kBlueColor];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
