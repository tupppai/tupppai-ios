//
//  BaseViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATOMBaseViewController : UIViewController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popCurrentController;

@end
