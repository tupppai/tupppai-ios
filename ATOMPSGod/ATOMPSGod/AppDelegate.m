//
//  AppDelegate.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "AppDelegate.h"
//#import "PIELaunchViewController.h"
#import "PIELaunchViewController_Black.h"
#import "DDNavigationController.h"
#import "DDLoginNavigationController.h"
#import "DDIntroVC.h"
#import "ATOMBaseDAO.h"
#import "UMessage.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "PIECommentViewController.h"
#import "PIENotificationViewController.h"
#import "MobClick.h"
#import "UMCheckUpdate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)APP {
    return [[UIApplication sharedApplication] delegate];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupNetworkManager];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self initializeDatabase];
    [self initializeAfterDB];
    [self setupShareSDK];
    [self setupUmengPush:launchOptions];
    [self setupBarButtonItem];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[PIECommentViewController class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[PIENotificationViewController class]];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    
    [self setupUmengAnalytics];
    
    
    
    return YES;
}

- (void)setupNetworkManager {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"BASEURL"] == nil) {
        [[NSUserDefaults standardUserDefaults]setObject:baseURLString forKey:@"BASEURL"];
    }
}
- (void)setupUmengAnalytics {
    [MobClick startWithAppkey:@"55b1ecdbe0f55a1de9001164"];
    [MobClick setCrashReportEnabled:YES];
    [MobClick setEncryptEnabled:YES];
    [MobClick setLogEnabled:NO];
    [UMCheckUpdate checkUpdateWithAppkey:@"55b1ecdbe0f55a1de9001164" channel:nil];
    NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [UMCheckUpdate setVersion:[version integerValue]];
}
- (void)setupBarButtonItem {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
    shadow.shadowColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont systemFontOfSize:14.0]
       }
     forState:UIControlStateNormal];
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
        
    }
//    else {
//        //register remoteNotification types (iOS 8.0以下)
//        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//         |UIRemoteNotificationTypeSound
//         |UIRemoteNotificationTypeAlert];
//    }
#else
    //register remoteNotification types (iOS 8.0以下)
//    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//     |UIRemoteNotificationTypeSound
//     |UIRemoteNotificationTypeAlert];
    
#endif

}
-(void)initializeAfterDB {

    [DDUserManager fetchUserInDBToCurrentUser:^(BOOL success) {
        if (success) {

            self.window.rootViewController = self.mainTabBarController;
        } else {
            
            NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString* launchKey = [NSString stringWithFormat:@"HasLaunchedOnce%@",version];
            
            if (![[NSUserDefaults standardUserDefaults] boolForKey:launchKey])
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:launchKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                DDIntroVC* vc = [DDIntroVC new];
                self.baseNav = [[DDLoginNavigationController alloc] initWithRootViewController:vc];
                self.window.rootViewController = self.baseNav;
            } else {
                PIELaunchViewController_Black *lvc = [[PIELaunchViewController_Black alloc] init];
                self.baseNav = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
                self.window.rootViewController = self.baseNav;
            }
        }
        [self.window makeKeyAndVisible];
    }];
}

//-(void)setupNotification {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    else
//    {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    }
//}
-(void)initializeDatabase {
    [ATOMBaseDAO new];
}

- (PIETabBarController *)mainTabBarController {
    if (_mainTabBarController == nil) {
        _mainTabBarController = [PIETabBarController new];
    }
    return _mainTabBarController;
}

#pragma mark - Share

- (void)setupShareSDK {
    [ShareSDK registerApp:@"65b1ce491325"
          activePlatforms:@[@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
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
                    case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1104845173" appKey:@"66J8VPEAzAO3yQt4" authType:SSDKAuthTypeBoth];
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
    
    [self uploadDeviceInfo:devicetokenString];
}
- (void)uploadDeviceInfo:(NSString*)token {
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:token, @"device_token",@1,@"platform",@([[UIDevice currentDevice].systemVersion floatValue]),@"device_os",deviceName(),@"device_name",[oNSUUID UUIDString],@"device_mac",version,@"version",nil];
    [DDService updateToken:param withBlock:nil];
}
- (void)addRedDotToTabBarItemIndex:(NSInteger)index {
    for (UIView* subview in self.mainTabBarController.tabBar.subviews) {
        if (subview && subview.tag == 1314) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    NSInteger RedDotRadius = 4;
    NSInteger RedDotDiameter = RedDotRadius*2;
    NSInteger TopMargin = 5;
    NSInteger TabBarItemCount = self.mainTabBarController.tabBar.items.count;
    NSInteger HalfItemWidth = SCREEN_WIDTH / (TabBarItemCount * 2);
    NSInteger xOffset = HalfItemWidth* (index * 2 + 1);
    NSInteger imageHalfWidth = [self.mainTabBarController.tabBar.items objectAtIndex:index].selectedImage.size.width/2;
    UIView* redDot = [[UIView alloc]initWithFrame:CGRectMake(xOffset+imageHalfWidth, TopMargin, RedDotDiameter, RedDotDiameter)];
    redDot.tag = 1314;
    redDot.backgroundColor = [UIColor redColor];
    redDot.layer.cornerRadius = RedDotRadius;
    [self.mainTabBarController.tabBar addSubview:redDot ];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userinfo:%@",userInfo);
    NSInteger notifyType = [[userInfo objectForKey:@"type"]integerValue];

    [self updateBadgeNumberForKey:@"NotificationAll" toAdd:1];
    if (notifyType == 0) {
        [self updateBadgeNumberForKey:@"NotificationSystem" toAdd:1];
    } else if (notifyType == 5) {
        [self updateBadgeNumberForKey:@"NotificationLike" toAdd:1];
    } else {
        [self updateBadgeNumberForKey:@"NotificationOthers" toAdd:1];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:@"NotificationNew"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self addRedDotToTabBarItemIndex:3];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"updateNoticationStatus" object:nil]];

}

-(void)updateBadgeNumberForKey:(NSString*)key toAdd:(int)badgeNumber {
    NSNumber* currentBadgeNumber = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if (!currentBadgeNumber) {
        currentBadgeNumber = @(0);
    }
    NSInteger newBadgeNumber = [currentBadgeNumber integerValue] + badgeNumber;
    [[NSUserDefaults standardUserDefaults]setObject:@(newBadgeNumber) forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}



#pragma mark - private helpers
- (void)switchToMainTabbarController
{
    
    [[AppDelegate APP].baseNav setViewControllers:[NSArray array]];
    /*
     使用懒加载，重新创建一次mainTabBarController
     */
    [AppDelegate APP].mainTabBarController = nil;
    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
    ;
}

- (void)switchToLoginViewController
{
    [[AppDelegate APP].baseNav setViewControllers:[NSArray array]];
    PIELaunchViewController_Black *lvc = [[PIELaunchViewController_Black alloc] init];
    [AppDelegate APP].window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
}











@end
