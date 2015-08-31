//
//  AppDelegate.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "AppDelegate.h"
#import "DDLaunchVC.h"
#import "DDTabBarController.h"
#import "DDNavigationController.h"
#import "DDLoginNavigationController.h"
#import "DDIntroVC.h"
#import "ATOMBaseDAO.h"
#import "UMessage.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "DDCommentVC.h"
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
    [self setupUmengPush:launchOptions];

    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[DDCommentVC class]];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    return YES;
}
-(void)setupUmengPush:(NSDictionary *)launchOptions {
    //set AppKey and AppSecret
    [UMessage startWithAppkey:@"55b1ecdbe0f55a1de9001164" launchOptions:launchOptions];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
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
//    [UMessage setLogEnabled:YES];
}
-(void)initializeAfterDB {
//    ATOMIntroductionOnFirstLaunchViewController* vc = [ATOMIntroductionOnFirstLaunchViewController new];
//    self.baseNav = [[ATOMLoginCustomNavigationController alloc] initWithRootViewController:vc];
//    self.window.rootViewController = self.baseNav;
//    [self.window makeKeyAndVisible];
    [[DDUserManager currentUser]fetchCurrentUserInDB:^(BOOL hasCurrentUser) {
        if (hasCurrentUser) {
            self.window.rootViewController = self.mainTabBarController;
        } else {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
            {
                //UIPageViewController
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                DDIntroVC* vc = [DDIntroVC new];
                self.baseNav = [[DDLoginNavigationController alloc] initWithRootViewController:vc];
                self.window.rootViewController = self.baseNav;
            } else {
                DDLaunchVC *lvc = [[DDLaunchVC alloc] init];
                self.baseNav = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
                self.window.rootViewController = self.baseNav;
            }
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

- (DDTabBarController *)mainTabBarController {
    if (_mainTabBarController == nil) {
        _mainTabBarController = [DDTabBarController new];
    }
    return _mainTabBarController;
}

#pragma mark - Share

- (void)setupShareSDK {
    [ShareSDK registerApp:@"65b1ce491325"
          activePlatforms:@[@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeSinaWeibo)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                             
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx86ff6f67a2b9b4b8" appSecret:@"c2da31fda3acf1c09c40ee25772b6ca5"];
                      break;
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"882276088"
                                                appSecret:@"454f67c8e6d29b770d701e9272bc5ee7"
                                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  default: break;
              }
          }
     ];
    

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
//    NSLog(@"standardUserDefaults setObject");
    [[NSUserDefaults standardUserDefaults]setObject:devicetokenString forKey:@"devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSLog(@"devicetokenString%@", devicetokenString);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
//userinfo:{
//    aps =     {
//        alert = "\U60a8\U6709\U4e00\U6761\U65b0\U7684\U6c42p\U9080\U8bf7";
//        badge = 1;
//        sound = chime;
//    };
//    count = 1;
//    d = uu75868143928550190401;
//    p = 0;
//    type = invite;
//}
    // 处理推送消息
    
//    [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:@"RemoteNoficationInfo"];
//    
//    NSLog(@"userinfo:%@",userInfo);
//    [UMessage didReceiveRemoteNotification:userInfo];
    
    NSString* notifyType = [userInfo objectForKey:@"type"];
    int badgeNumber = [[[userInfo objectForKey:@"aps"]objectForKey:@"badge"]intValue];

    typedef void (^CaseBlock)();
    NSDictionary *dic = @{
                        @"comment":
                            ^{
                                [self updateBadgeNumberForKey:@"NotifyType0" toAdd:badgeNumber];
                            },
                        @"post_reply":
                            ^{
                                [self updateBadgeNumberForKey:@"NotifyType1" toAdd:badgeNumber];
                            },
                        @"attention":
                            ^{
                                [self updateBadgeNumberForKey:@"NotifyType2" toAdd:badgeNumber];
                            },
                        @"invite":
                            ^{
                                [self updateBadgeNumberForKey:@"NotifyType3" toAdd:badgeNumber];
                            },
                        @"system":
                            ^{
                                [self updateBadgeNumberForKey:@"NotifyType4" toAdd:badgeNumber];
                            }
                        };
    
    ((CaseBlock)[dic objectForKey:notifyType])();
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ReceiveRemoteNotification" object:nil]];

}

-(void)updateBadgeNumberForKey:(NSString*)key toAdd:(int)badgeNumber {
    int currentBadgeNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:key]intValue];
    int newBadgeNumber = currentBadgeNumber + badgeNumber;
    [[NSUserDefaults standardUserDefaults]setObject:@(newBadgeNumber) forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}















@end
