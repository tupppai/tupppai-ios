//
//  UIViewController+RecursiveModal.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/3/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RecursiveModal)

- (void)presentViewControllerFromVisibleViewController:(UIViewController *)viewControllerToPresent;

@end
