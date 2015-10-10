//
//  ATOMLoginCustomNavigationController.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/30/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDLoginNavigationController.h"
@interface DDLoginNavigationController () <UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@end
@implementation DDLoginNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBarHidden = YES;
//    __weak typeof (self) weakSelf = self;
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.delegate = weakSelf;
//        self.delegate = self;
//    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        if (self.viewControllers.count == 1) {
//            self.interactivePopGestureRecognizer.enabled = NO;
//        } else {
//            self.interactivePopGestureRecognizer.enabled = YES;
//        }
//    }
}
@end
