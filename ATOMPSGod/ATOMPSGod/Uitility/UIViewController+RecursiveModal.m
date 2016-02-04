//
//  UIViewController+RecursiveModal.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/3/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "UIViewController+RecursiveModal.h"

@implementation UIViewController (RecursiveModal)

- (void)presentViewControllerFromVisibleViewController:(UIViewController *)viewControllerToPresent
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)self;
        [navController.topViewController presentViewControllerFromVisibleViewController:viewControllerToPresent];
    }
    /** 避免多线程同时调用两次请求，导致连续弹两次窗的问题：假如下一个窗口已经是viewControllerToPresent的话就不要再递归了 */
    else if (self.presentedViewController &&
             ![self.presentedViewController isKindOfClass:[viewControllerToPresent class]]) {
        [self.presentedViewController presentViewControllerFromVisibleViewController:viewControllerToPresent];
    }
    else {
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
    }
}

@end
