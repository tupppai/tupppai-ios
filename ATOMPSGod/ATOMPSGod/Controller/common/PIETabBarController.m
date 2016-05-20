//
//  ATOMMainTabBarController.m
//  ATOMPSGod
//
//  Created by atom on 1padding/3/3.
//  Copyright (c) 201padding年 ATOM. All rights reserved.
//
#import "PIEShopViewController.h"
#import "PIETabBarController.h"
//#import "PIEChannelViewController.h"
#import "DDNavigationController.h"
#import "DDService.h"
#import "PIEMeViewController.h"
#import "PIECameraViewController.h"
//#import "PIEProceedingViewController.h"

#import "DDLoginNavigationController.h"
#import "ATOMUserDAO.h"
#import "PIEUploadManager.h"
#import "UIImage+Colors.h"

//#import "PIEProceedingViewController2.h"
#import "PIEEliteViewController.h"
#import "PIELaunchViewController_Black.h"
#import "PIEBindCellphoneViewController.h"
#import "UIViewController+RecursiveModal.h"
#import "RengarViewController.h"
#import "LeesinUploadModel.h"
#import "LeesinUploadManager.h"
#import "MRNavigationBarProgressView.h"
#import "PIEMovieViewController.h"

@interface PIETabBarController ()
<
    UITabBarControllerDelegate
>

@property (nonatomic, strong) DDNavigationController *navigation_first;
@property (nonatomic, strong) DDNavigationController *navigation_second;
@property (nonatomic, strong) DDNavigationController *navigation_third;
@property (nonatomic, strong) DDNavigationController *navigation_fourth;
@property (nonatomic, strong) DDNavigationController *navigation_fifth;
@property (nonatomic, strong) DDNavigationController *preNav;
@property (nonatomic, assign) long long timeStamp_error;

//@property (nonatomic, strong) MRNavigationBarProgressView *progressView;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self setupNavBar];
}

- (void)setupNavBar
{
    
//    self.progressView = [MRNavigationBarProgressView progressViewForNavigationController:]
    
    // TODO: NO navigationBar to attach on
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

#pragma mark - Public method
- (void)toggleToEliteFollow{
    [self setSelectedIndex:0];
    PIEEliteViewController *eliteViewController = _navigation_first.viewControllers[0];
    [eliteViewController toggleToEliteFollow];
}

- (void)refreshMoments{
    PIEEliteViewController *eliteViewController = _navigation_first.viewControllers[0];
    [eliteViewController refreshMoments];
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
    
//    PIEMovieViewController *vc2 = [PIEMovieViewController new];
    
    PIEEliteViewController *myAttentionViewController = [PIEEliteViewController new];
//    PIEShopViewController *proceedingViewController = [PIEShopViewController new];
    
    PIEMeViewController *aboutMeVC = (PIEMeViewController *)[[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier: @"PIEME"];
    
    myAttentionViewController.title = @"动态";
//    vc2.title                 = @"微出品";
//    proceedingViewController.title  = @"进行中";
    aboutMeVC.title                 = @"我";

    _navigation_second = [[DDNavigationController alloc] init];
    _navigation_second.title = @"微出品";
    _navigation_fourth = [[DDNavigationController alloc] init];
    _navigation_fourth.title = @"影视";

    
    _navigation_first = [[DDNavigationController alloc] initWithRootViewController:myAttentionViewController];
    _navigation_fifth = [[DDNavigationController alloc] initWithRootViewController:aboutMeVC];
    _preNav = _navigation_first;
    _navigation_third = [[DDNavigationController alloc] init];
    
    _navigation_first.tabBarItem.image =
    [[UIImage imageNamed:@"tab_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    _navigation_first.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"tab_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _navigation_second.tabBarItem.image =
    [[UIImage imageNamed:@"tab_new_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_second.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"tab_new_seleted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_fourth.tabBarItem.image =
    [[UIImage imageNamed:@"tab_jinxing_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_fourth.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"tab_jinxing_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    _navigation_fifth.tabBarItem.image =
    [[UIImage imageNamed:@"pie_tab_5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_fifth.tabBarItem.selectedImage =
    [[UIImage imageNamed:@"pie_tab_5_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _navigation_third.title = nil;
    _navigation_third.tabBarItem.image =
    [[UIImage imageNamed:@"tab_post"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _navigation_third.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [self updateTabbarAvatar];
    self.viewControllers = [NSArray arrayWithObjects:_navigation_first,
                            _navigation_second,
                            _navigation_third,
                            _navigation_fourth,
                            _navigation_fifth, nil];
}


- (void)updateTabbarAvatar {
    [DDService sd_downloadImage:[DDUserManager currentUser].avatar withBlock:^(UIImage *image) {
        if (image) {
            UIImage* scaledImage = [Util imageWithImage:image scaledToSize:CGSizeMake(26,26) circlize:YES];
            _avatarImage = scaledImage;
            _navigation_fifth.tabBarItem.image = [_avatarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            _navigation_fifth.tabBarItem.selectedImage = [[self getSelectedTabImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
    if (viewController == _navigation_second) {
        if (_preNav == _navigation_second) {

        }
    } else if (viewController == _navigation_first) {
        if (_preNav == _navigation_first) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Refreshnavigation_first" object:nil];
        }
    } else if (viewController == _navigation_fourth){
        if (_preNav == _navigation_fourth) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:PIEPrefreshNavigationProceedingFromTabBarNotification
             object:nil];
        }
    }
        _preNav = (DDNavigationController*)viewController;
}



-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == _navigation_third) {
        [self presentBlurViewController];
        return NO;
    } else if (viewController == _navigation_second) {
        [self presentMovie];
        return NO;
    }
    else if (viewController == _navigation_fourth) {
        [self presentShop];
        return NO;
    }

    return YES;
}



- (void)presentBlurViewController {
    PIECameraViewController *pvc = [PIECameraViewController new];
    pvc.blurStyle = UIBlurEffectStyleDark;
    [self presentViewController:pvc animated:YES completion:nil];
}

- (void)presentShop {
    //    PIEMovieViewController *pvc = [PIEMovieViewController new];
    PIEShopViewController *vc = [PIEShopViewController new];
    DDNavigationController *nav = [[DDNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)presentMovie {
//    PIEMovieViewController *pvc = [PIEMovieViewController new];
    PIEMovieViewController *movie = [PIEMovieViewController new];
    DDNavigationController *nav = [[DDNavigationController alloc]initWithRootViewController:movie];
    [self presentViewController:nav animated:YES completion:nil];
}

//- (void)presentRengarViewController
//{
//    if ([DDUserManager currentUser].uid == kPIETouristUID) {
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:PIENetworkCallForFurtherRegistrationNotification
//         object:nil
//         userInfo:nil];
//    }else{
//        RengarViewController *rengarVC = [RengarViewController new];
//        rengarVC.delegate              = self;
//        rengarVC.titleStr              = @"发布动态";
//        
//        DDNavigationController *nav =
//        [[DDNavigationController alloc] initWithRootViewController:rengarVC];
//        
//        [self presentViewController:nav animated:YES completion:nil];
//    }
//    
//}


//- (BOOL)tabBarController:(UITabBarController *)tabBarController
//shouldSelectViewController:(UIViewController *)viewController
//{
//    if (viewController == _navigation_third) {
//        [self presentRengarViewController];
//        return NO;
//    }
//    return YES;
//}

//#pragma mark - <RengarViewControllerDelegate>
//- (void)rengarViewController:(RengarViewController *)rengarViewController
//  didFinishPickingPhotoAsset:(PHAsset *)asset
//           descriptionString:(NSString *)descriptionString
//{
//    // upload 'momonet', a.k.a reply with ask_ID == 0
//    LeesinUploadModel *uploadModel = [LeesinUploadModel new];
//    LeesinUploadManager *manager   = [LeesinUploadManager new];
//    
//    uploadModel.ask_id     = 0;
//    uploadModel.type       = PIEPageTypeReply;
//    uploadModel.content    = descriptionString;
//    uploadModel.imageArray = [NSMutableOrderedSet orderedSetWithObject:asset];
//    
//    manager.model = uploadModel;
//    
//    @weakify(self);
//    [Hud activity:@"正在上传动态..."];
//    [manager uploadMoment:^(CGFloat percentage, BOOL success) {
//        @strongify(self);
//        if (success) {
//            [Hud dismiss];
//            [self setSelectedIndex:0];
//            PIEEliteViewController *eliteViewController = _navigation_first.viewControllers[0];
//            [eliteViewController refreshMoments];
//        }
//    }];
//    
//}





/*
    废弃的代码，当时被Ken坑到的
 */
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
