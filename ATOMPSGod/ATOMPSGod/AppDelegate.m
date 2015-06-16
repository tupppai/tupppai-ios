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
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WXApi.h"
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
    [self setupShareSDK];
    [self setCommonNavigationStyle];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    
    return YES;
}

- (void)setCommonNavigationStyle {
    [[UINavigationBar appearance] setBarTintColor:kBlueColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (ATOMMainTabBarController *)mainTarBarController {
    if (_mainTarBarController == nil) {
        _mainTarBarController = [ATOMMainTabBarController new];
    }
    return _mainTarBarController;
}

#pragma mark - Share

- (void)setupShareSDK {
    [ShareSDK registerApp:@"65b1ce491325"];
    [ShareSDK connectWeChatWithAppId:@"wx86ff6f67a2b9b4b8"   //微信APPID
                           appSecret:@"c2da31fda3acf1c09c40ee25772b6ca5"  //微信APPSecret
                           wechatCls:[WXApi class]];
    

    [ShareSDK connectSinaWeiboWithAppKey:@"1251119895"
                               appSecret:@"454f67c8e6d29b770d701e9272bc5ee7"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    
    [Parse setApplicationId:@"SgknH6DsznpSXdBqqJlYMInkLviSPwltw0StP9es" clientKey:@"2zfmu9kMFLtpeDLgfszprClkGYrDGpqzUd3IpUT2"];
    
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *devicetokenString = [[[deviceToken description]
                                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                   stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"devicetokenString%@", devicetokenString);
    
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}




















@end
