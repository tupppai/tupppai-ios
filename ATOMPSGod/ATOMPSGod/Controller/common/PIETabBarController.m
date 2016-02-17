//
//  ATOMMainTabBarController.m
//  ATOMPSGod
//
//  Created by atom on 1padding/3/3.
//  Copyright (c) 201padding年 ATOM. All rights reserved.
//

#import "PIETabBarController.h"
#import "PIEChannelViewController.h"
#import "DDNavigationController.h"
#import "DDService.h"
#import "PIEMeViewController.h"
#import "PIECameraViewController.h"
#import "PIEProceedingViewController.h"

#import "DDLoginNavigationController.h"
#import "ATOMUserDAO.h"
#import "PIEUploadManager.h"
#import "UIImage+Colors.h"

#import "PIEProceedingViewController2.h"
#import "PIEEliteViewController.h"
#import "PIELaunchViewController_Black.h"
#import "PIEBindCellphoneViewController.h"
#import "UIViewController+RecursiveModal.h"


@interface PIETabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) DDNavigationController *navigation_new;
@property (nonatomic, strong) DDNavigationController *navigation_elite;
//@property (nonatomic, strong) DDNavigationController *centerNav;
@property (nonatomic, strong) DDNavigationController *navigation_proceeding;
@property (nonatomic, strong) DDNavigationController *navigation_me;
@property (nonatomic, strong) DDNavigationController *preNav;
@property (nonatomic, assign) long long timeStamp_error;

@end

@implementation PIETabBarController

#pragma mark - Lazy Initialize

#pragma mark - Config

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureTabBarController];
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setupTitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorOccuredRET) name:@"NetworkErrorCall" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetworkSignOutRET) name:@"NetworkSignOutCall" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showInfoRET:)
                                                 name:@"NetworkShowInfoCall"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(touristWantsFurtherRegistration)
     name:PIENetworkCallForFurtherRegistrationNotification
     object:nil];
    
    [RACObserve([DDUserManager currentUser], avatar)subscribeNext:^(id x) {
        [self updateTabbarAvatar];
    }];

}

- (void)setupTitle {
    [[UITabBarItem appearance] setTitleTextAttributes:@{   NSForegroundColorAttributeName: [UIColor blackColor],                                                           NSFontAttributeName: [UIFont systemFontOfSize:10]
                                                           }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{   NSForegroundColorAttributeName: [UIColor blackColor],                                                           NSFontAttributeName: [UIFont systemFontOfSize:10]
                                                           }
                                             forState:UIControlStateSelected];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkSignOutCall"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkErrorCall" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkShowInfoCall" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PIENetworkCallForFurtherRegistrationNotification
                                                  object:nil];
}

#pragma mark - Notification methods

-(void) errorOccuredRET {
    BOOL shouldShowError = NO;
    long long currentTimeStamp = [[NSDate date]timeIntervalSince1970];
    if (_timeStamp_error) {
        long long timeStamp_gap = currentTimeStamp - _timeStamp_error;
        if (timeStamp_gap>10) {
            shouldShowError = YES;
            _timeStamp_error = currentTimeStamp;
        } else {
            shouldShowError = NO;
        }
    } else {
        shouldShowError = YES;
        _timeStamp_error = currentTimeStamp;
    }
    
    if (shouldShowError) {
        [Hud text:@"网路好像有点问题～" inView:self.view];
    }
}

-(void) showInfoRET:(NSNotification *)notification {
    NSString* info = [[notification userInfo] valueForKey:@"info"];
    NSString *prompt = [NSString stringWithFormat:@"%@", info];
    [Hud text:prompt inView:self.view];
}


-(void) NetworkSignOutRET {
    SIAlertView *alertView = [KShareManager NetworkErrorOccurredAlertView];
    [alertView addButtonWithTitle:@"好的"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              //清空数据库用户表
                              [ATOMUserDAO clearUsers];
                              //清空当前用户
                              [DDUserManager clearCurrentUser];
                              [DDSessionManager resetSharedInstance];
                              [[AppDelegate APP] switchToLoginViewController];
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
    
}

- (void) touristWantsFurtherRegistration{
    PIEBindCellphoneViewController *bindCellphoneVC =
    [[PIEBindCellphoneViewController alloc] init];
    
    bindCellphoneVC.blurStyle = UIBlurEffectStyleDark;
    
//    [self presentViewController:bindCellphoneVC
//                       animated:YES
//                     completion:nil];
//    [[AppDelegate APP].window.rootViewController presentViewController:bindCellphoneVC
//                                                              animated:YES completion:nil];
    
    [[AppDelegate APP].window.rootViewController presentViewControllerFromVisibleViewController:bindCellphoneVC];
}

- (void)configureTabBarController {
    
    PIEChannelViewController *channelVc = [PIEChannelViewController new];

    PIEEliteViewController *myAttentionViewController = [PIEEliteViewController new];
    PIEProceedingViewController2 *proceedingViewController = [PIEProceedingViewController2 new];
    
    PIEMeViewController *aboutMeVC = (PIEMeViewController *)[[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier: @"PIEME"];

    
    myAttentionViewController.title = @"动态";
    channelVc.title                 = @"图派";
    proceedingViewController.title  = @"进行中";
    aboutMeVC.title                 = @"我";
    
    
    
    _navigation_new = [[DDNavigationController alloc] initWithRootViewController:channelVc];
    _navigation_elite = [[DDNavigationController alloc] initWithRootViewController:myAttentionViewController];
    _navigation_proceeding = [[DDNavigationController alloc] initWithRootViewController:proceedingViewController];
    _navigation_me = [[DDNavigationController alloc] initWithRootViewController:aboutMeVC];
    _preNav = _navigation_elite;
    
    _navigation_elite.tabBarItem.image =
    [[UIImage imageNamed:@"tab_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    _navigation_elite.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"tab_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _navigation_new.tabBarItem.image =
    [[UIImage imageNamed:@"tab_new_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_new.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"tab_new_seleted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_proceeding.tabBarItem.image =
    [[UIImage imageNamed:@"tab_jinxing_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_proceeding.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"tab_jinxing_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    _navigation_me.tabBarItem.image =
    [[UIImage imageNamed:@"pie_tab_5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_me.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"pie_tab_5_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self updateTabbarAvatar];
    self.viewControllers = [NSArray arrayWithObjects:_navigation_elite, _navigation_new,_navigation_proceeding, _navigation_me, nil];
}


- (void)updateTabbarAvatar {
    [DDService sd_downloadImage:[DDUserManager currentUser].avatar withBlock:^(UIImage *image) {
        if (image) {
            UIImage* scaledImage = [Util imageWithImage:image scaledToSize:CGSizeMake(26,26) circlize:YES];
            _avatarImage = scaledImage;
            _navigation_me.tabBarItem.image = [_avatarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            _navigation_me.tabBarItem.selectedImage = [[self getSelectedTabImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }];
}



- (UIImage*)getSelectedTabImage {
    
    UIImage* maskImage = [UIImage imageNamed:@"pie_tab_mask"];
    UIImage *resultImage = nil;
    UIGraphicsBeginImageContextWithOptions(_avatarImage.size, NO, 0.0);

    CGFloat width  = _avatarImage.size.width;
    CGFloat height = _avatarImage.size.height;

    [maskImage drawInRect:CGRectMake(0, 0, width, height)];
    
    CGRect rect2 = CGRectMake(1,1, width-2, height-2);
    [_avatarImage drawInRect:rect2];
    
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
    
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == _navigation_new) {
        if (_preNav == _navigation_new) {

            [[NSNotificationCenter defaultCenter]
            postNotificationName:PIERefreshNavigationChannelFromTabBarNotification
             object:nil];
        }
    } else if (viewController == _navigation_elite) {
        if (_preNav == _navigation_elite) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNavigation_Elite" object:nil];
        }
    } else if (viewController == _navigation_proceeding){
        if (_preNav == _navigation_proceeding) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:PIEPrefreshNavigationProceedingFromTabBarNotification
             object:nil];
        }
    }
        _preNav = (DDNavigationController*)viewController;
}



//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (viewController == _centerNav) {
//        [self presentBlurViewController];
//        return NO;
//    }
//    return YES;
//}
//- (void)presentBlurViewController {
//    PIECameraViewController *pvc = [PIECameraViewController new];
//    pvc.blurStyle = UIBlurEffectStyleDark;
//    [self presentViewController:pvc animated:YES completion:nil];
//}

//- (BOOL)tabBarController:(UITabBarController *)tabBarController
//shouldSelectViewController:(UIViewController *)viewController
//{
//    DDNavigationController *nav = (DDNavigationController *)viewController;
//    
//    if ([DDUserManager isTourist] &&
//        ([[nav topViewController] isKindOfClass:[PIEProceedingViewController2 class]] ||
//         [[nav topViewController] isKindOfClass:[PIEMeViewController class]]) )
//    {
//        // 如果是游客临时用户，然后又想点击“进行中”和“我”，直接发通知
//        
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:PIENetworkCallForFurtherRegistrationNotification
//         object:nil];
//        
//        return NO;
//    }
//    return YES;
//}


@end
