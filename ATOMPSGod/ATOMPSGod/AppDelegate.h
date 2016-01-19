//
//  AppDelegate.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIETabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) PIETabBarController *mainTabBarController;

+ (AppDelegate *)APP;


- (void)switchToMainTabbarController;

- (void)switchToLoginViewController;



@end

