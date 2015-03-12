//
//  AppDelegate.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "AppDelegate.h"
#import "ATOMLaunchViewController.h"
#import "ATOMMainTabBarController.h"
#import "ATOMCutstomNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)APP {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ATOMLaunchViewController *lvc = [[ATOMLaunchViewController alloc] init];
    self.baseNav = [[ATOMCutstomNavigationController alloc] initWithRootViewController:lvc];
    self.window.rootViewController = self.baseNav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setCommonNavigationStyle {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:0xf8f8f8]];
}

- (UITabBarController *)mainTarBarController {
    if (_mainTarBarController == nil) {
        _mainTarBarController = [ATOMMainTabBarController new];
    }
    return _mainTarBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
