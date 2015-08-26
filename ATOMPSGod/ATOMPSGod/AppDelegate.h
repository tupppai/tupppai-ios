//
//  AppDelegate.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *baseNav;
@property (nonatomic, strong) DDTabBarController *mainTabBarController;

+ (AppDelegate *)APP;

@end

