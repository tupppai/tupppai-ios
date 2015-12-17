//
//  ATOMMainTabBarController.m
//  ATOMPSGod
//
//  Created by atom on 1padding/3/3.
//  Copyright (c) 201padding年 ATOM. All rights reserved.
//

#import "PIETabBarController.h"
#import "PIEChannelViewController.h"
#import "PIEEliteViewController.h"
#import "DDNavigationController.h"
#import "DDService.h"
#import "PIEMeViewController.h"
#import "PIECameraViewController.h"
#import "PIEProceedingViewController.h"
#import "AppDelegate.h"
#import "DDLoginNavigationController.h"
#import "ATOMUserDAO.h"
#import "PIEUploadManager.h"
#import "UIImage+Colors.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoUploadJob:) name:@"UploadCall" object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadCall"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkSignOutCall"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkErrorCall" object:nil];
}
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
- (void) DoUploadJob:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    PIEEliteViewController* vc = (PIEEliteViewController*)((DDNavigationController*)[self.viewControllers objectAtIndex:0]).topViewController;
    PIEUploadManager* manager = [PIEUploadManager new];
    manager.uploadInfo = info;
    [manager upload:^(CGFloat percentage,BOOL success) {
        [vc.progressView setProgress:percentage animated:YES];
        if (success) {
            if ([manager.type isEqualToString:@"ask"]) {
                
            } else if ([manager.type isEqualToString:@"reply"]) {

            }
        }
    }];
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
                              self.navigationController.viewControllers = @[];
                              PIELaunchViewController *lvc = [[PIELaunchViewController alloc] init];
                              [AppDelegate APP].window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
}


- (void)configureTabBarController {
    
    PIEChannelViewController *channelVc = [PIEChannelViewController new];
    PIEEliteViewController *myAttentionViewController = [PIEEliteViewController new];
    PIEProceedingViewController *proceedingViewController = [PIEProceedingViewController new];
    
    PIEMeViewController *aboutMeVC = (PIEMeViewController *)[[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier: @"PIEME"];

    
    myAttentionViewController.title = @"首页";
    channelVc.title                 = @"图派";
    proceedingViewController.title  = @"进行中";
    aboutMeVC.title                 = @"我";
    
    
    
    _navigation_new = [[DDNavigationController alloc] initWithRootViewController:channelVc];
    _navigation_elite = [[DDNavigationController alloc] initWithRootViewController:myAttentionViewController];
    _navigation_proceeding = [[DDNavigationController alloc] initWithRootViewController:proceedingViewController];
    _navigation_me = [[DDNavigationController alloc] initWithRootViewController:aboutMeVC];
//    _centerNav = [[DDNavigationController alloc] initWithRootViewController:takePhotoVC];
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
//        [_centerNav.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    self.viewControllers = [NSArray arrayWithObjects:_navigation_elite, _navigation_new,_navigation_proceeding, _navigation_me, nil];
}


- (void)updateTabbarAvatar {
    [DDService downloadImage:[DDUserManager currentUser].avatar withBlock:^(UIImage *image) {
        if (image) {
            UIImage* scaledImage = [Util imageWithImage:image scaledToSize:CGSizeMake(28, 28) circlize:YES];
            _avatarImage = scaledImage;
            _navigation_me.tabBarItem.image = [_avatarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            _navigation_me.tabBarItem.selectedImage = [[self retimage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }];
}

- (UIImage*)retimage {
    // Start the image context
    
    UIImage* circleImage = [UIImage imageNamed:@"pie_tab_mask"];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(28, 28), NO, 0.0);
    UIImage *resultImage = nil;
    
    // Get the graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGRect rectB = CGRectMake(0, 0, 30, 30);

    CGMutablePathRef path = CGPathCreateMutable();
    //    [[UIColor redColor] setFill];
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddArc(path, NULL, 14, 14, 10, -M_PI, M_PI_2, NO);
    CGPathCloseSubpath(path);
    
    [[UIColor greenColor] setStroke];
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
    
    // Draw the first image
    [circleImage drawInRect:CGRectMake(0, 0, 28, 28)];
    UIImage* user = _avatarImage;
    
    // Get the frame of the second image
    CGRect rect = CGRectMake(0, 0, 28, 28);
    
    // Add the path of an ellipse to the context
    // If the rect is a square the shape will be a circle
    CGContextAddEllipseInRect(context, rect);
    // Clip the context to that path
    CGContextClip(context);
    
    // Do the second image which will be clipped to that circle
    CGRect rect2 = CGRectMake(0.5,0.5, 27, 27);
    [user drawInRect:rect2];
    


    // Get the result
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the image context
    UIGraphicsEndImageContext();
    return resultImage;
    
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == _navigation_new) {
        if (_preNav == _navigation_new) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNavigation_New" object:nil];
        }
    } else if (viewController == _navigation_elite) {
        if (_preNav == _navigation_elite) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNavigation_Elite" object:nil];
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


@end
