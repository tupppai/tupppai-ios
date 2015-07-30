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
#import "ATOMLoginCustomNavigationController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "ATOMBaseDAO.h"
#import "UMessage.h"

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
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self initializeDatabase];
    [self initializeAfterDB];
    [self setupShareSDK];
    [self setCommonNavigationStyle];
    [self setupUmengPush:launchOptions];
    return YES;
}
-(void)setupUmengPush:(NSDictionary *)launchOptions {
    
    [UMessage setLogEnabled:YES];

    //set AppKey and AppSecret
    [UMessage startWithAppkey:@"55b1ecdbe0f55a1de9001164" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
//        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//        action1.identifier = @"action1_identifier";
//        action1.title=@"Accept";
//        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//        
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//        action2.identifier = @"action2_identifier";
//        action2.title=@"Reject";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//        
//        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
//        categorys.identifier = @"category1";//这组动作的唯一标示
//        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:nil];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];

    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
}
-(void)initializeAfterDB {
    [[ATOMCurrentUser currentUser]fetchCurrentUserInDB:^(BOOL hasCurrentUser) {
        if (hasCurrentUser) {
            NSLog(@"hasCurrentUser");
            self.window.rootViewController = self.mainTabBarController;
        } else {
            NSLog(@"hasCurrentUser == false");
            ATOMLaunchViewController *lvc = [[ATOMLaunchViewController alloc] init];
            self.baseNav = [[ATOMLoginCustomNavigationController alloc] initWithRootViewController:lvc];
            self.window.rootViewController = self.baseNav;
        }
        [self.window makeKeyAndVisible];
    }];
}

-(void)setupNotification {
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
}
-(void)initializeDatabase {
    [ATOMBaseDAO new];
}
- (void)setCommonNavigationStyle {
    [[UINavigationBar appearance] setBarTintColor:kBlueColor];
    [[UINavigationBar appearance] setTintColor:kNavBarColor];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

- (ATOMMainTabBarController *)mainTabBarController {
    if (_mainTabBarController == nil) {
        _mainTabBarController = [ATOMMainTabBarController new];
    }
    return _mainTabBarController;
}

#pragma mark - Share

- (void)setupShareSDK {
    [ShareSDK registerApp:@"65b1ce491325"];
    [ShareSDK connectWeChatWithAppId:@"wx86ff6f67a2b9b4b8"   //微信APPID
                           appSecret:@"c2da31fda3acf1c09c40ee25772b6ca5"  //微信APPSecret
                           wechatCls:[WXApi class]];
 
    [ShareSDK connectSinaWeiboWithAppKey:@"882276088"
                               appSecret:@"454f67c8e6d29b770d701e9272bc5ee7"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
//    [ShareSDK  connectSinaWeiboWithAppKey:@"882276088"
//                                appSecret:@"454f67c8e6d29b770d701e9272bc5ee7"
//                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
//                              weiboSDKCls:[WeiboSDK class]];
    
//    [Parse setApplicationId:@"SgknH6DsznpSXdBqqJlYMInkLviSPwltw0StP9es" clientKey:@"2zfmu9kMFLtpeDLgfszprClkGYrDGpqzUd3IpUT2"];
    
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
    [UMessage registerDeviceToken:deviceToken];
    NSString *devicetokenString = [[[deviceToken description]
                                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                   stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"devicetokenString%@", devicetokenString);
//
//    // Store the deviceToken in the current installation and save it to Parse.
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation setDeviceTokenFromData:deviceToken];
//    currentInstallation.channels = @[ @"global" ];
//    [currentInstallation saveInBackground];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
//    [PFPush handlePush:userInfo];
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}




















@end
