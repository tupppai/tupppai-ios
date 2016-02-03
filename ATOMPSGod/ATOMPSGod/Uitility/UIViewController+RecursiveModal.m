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
    else if (self.presentedViewController) {
        [self.presentedViewController presentViewControllerFromVisibleViewController:viewControllerToPresent];
    }
    else {
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
    }
}

@end
