//
//  AppDelegate.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//


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

#import "OpenShareHeader.h"

#import "PIECommentViewController.h"
#import "PIENotificationViewController.h"
#import "MobClick.h"
#import "Pingpp.h"

@interface AppDelegate ()
//@property (nonatomic, strong) UINavigationController *baseNav;

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
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //going to remove
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [self initializeDatabase];
    [self initializeAfterDB];
    
    // 新需求：用Openshare替换ShareSDK
    //    [self setupShareSDK];
    [self setupOpenShare];
    
    
    [self setupUmengPush:launchOptions];
    [self setupBarButtonItem];
//    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[PIECommentViewController class]];
//    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[PIENotificationViewController class]];
//    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    
    [self setupUmengAnalytics];
    
    
    
    return YES;
}

-(void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
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
    NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setVersion:[version integerValue]];
//    [UMCheckUpdate checkUpdateWithAppkey:@"55b1ecdbe0f55a1de9001164" channel:nil];
//    NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [UMCheckUpdate setVersion:[version integerValue]];
}
- (void)setupBarButtonItem {
    NSShadow *shadow    = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
    shadow.shadowColor  = [UIColor whiteColor];
    
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

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:nil];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    }

}
-(void)initializeAfterDB {
    // ## Step 1: 先尝试在本地沙盒加载用户的数据...
    [DDUserManager getMyProfileFromDatabase:^(BOOL success) {
        if (success) {
            self.window.rootViewController = self.mainTabBarController;
        } else {
            
            // ## Step 2: 假如沙盒里没有用户数据，先判断在登录注册页面之前，是否有需要显示新版本展示页
            
            NSNumber *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString* launchKey = [NSString stringWithFormat:@"HasLaunchedOnce%@",version];
            
            if (![[NSUserDefaults standardUserDefaults] boolForKey:launchKey])
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:launchKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                DDIntroVC* vc = [DDIntroVC new];
                self.window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:vc];
            } else {
                PIELaunchViewController_Black *lvc = [[PIELaunchViewController_Black alloc] init];
                self.window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
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

- (void)setupOpenShare
{
    // 第一步：注册Key
    [OpenShare connectQQWithAppId:kSNSPlatformQQID];
    [OpenShare connectWeiboWithAppKey:kSNSPlatformWeiboID];
    [OpenShare connectWeixinWithAppId:kSNSPlatformWeixinID];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL pingppCanHandleURL    = [Pingpp handleOpenURL:url withCompletion:nil];
    
    BOOL openShareCanHandleURL = [OpenShare handleOpenURL:url];
    
    return (pingppCanHandleURL || openShareCanHandleURL);
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    BOOL pingppCanHandleURL    = [Pingpp handleOpenURL:url withCompletion:nil];

    BOOL openShareCanHandleURL = [OpenShare handleOpenURL:url];
    
    return (pingppCanHandleURL || openShareCanHandleURL);
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
    
    NSInteger notifyType = [[userInfo objectForKey:@"type"] integerValue];
    
    [self updateBadgeNumberForKey:PIENotificationCountAllKey toAdd:1];
    
    if (notifyType == PIENotificationTypeSystem) {
        [self updateBadgeNumberForKey:PIENotificationCountSystemKey toAdd:1];
    } else if (notifyType == PIENotificationTypeLike) {
        [self updateBadgeNumberForKey:PIENotificationCountLikeKey toAdd:1];
    } else if (notifyType == PIENotificationTypeComment){
        [self updateBadgeNumberForKey:PIENotificationCountCommentKey toAdd:1];
    }
    else {
        [self updateBadgeNumberForKey:PIENotificationCountOthersKey toAdd:1];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:@(YES)
                                             forKey:PIEHasNewNotificationFlagKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self addRedDotToTabBarItemIndex:4];
    [[NSNotificationCenter defaultCenter] postNotification:
     [NSNotification
      notificationWithName:PIEUpdateNotificationStatusNotification object:nil]];
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
    
    [AppDelegate APP].mainTabBarController = nil;
    [[AppDelegate APP].window setRootViewController:[AppDelegate APP].mainTabBarController];
    ;
}

- (void)switchToLoginViewController
{
    
    
    PIELaunchViewController_Black *lvc = [[PIELaunchViewController_Black alloc] init];
    [AppDelegate APP].window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
    
    [AppDelegate APP].mainTabBarController = nil;

}






#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "w.test" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PageModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"tupai.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



@end
