//
//  BaseViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDBaseVC.h"
#import "DDHomeVC.h"
#import "ATOMPersonViewController.h"
#import "ATOMMyFollowViewController.h"
#import "DDMessageVC.h"
#import "ATOMUserDAO.h"
#import "DDLoginNavigationController.h"
#import "AppDelegate.h"
#import "SIAlertView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface DDBaseVC ()

@end

@implementation DDBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signOutRET) name:@"SignOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorEccuredRET) name:@"ErrorOccurred" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfoRET:) name:@"ShowInfo" object:nil];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [backView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [backButton addTarget:self action:@selector(popCurrentController) forControlEvents:UIControlEventTouchUpInside];
    _negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    _negativeSpacer.width = 0;
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]]];
        self.navigationItem.leftBarButtonItems = nil;
    } else {
        self.navigationItem.leftBarButtonItems = @[_negativeSpacer, barBackButtonItem];
    }
}


-(void) signOutRET {
    SIAlertView *alertView = [KShareManager signOutAlertView];
    [alertView addButtonWithTitle:@"好咯"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              //清空数据库用户表
                              [ATOMUserDAO clearUsers];
                              //清空当前用户
                              [[ATOMCurrentUser currentUser]wipe];
                              self.navigationController.viewControllers = @[];
                              ATOMLaunchViewController *lvc = [[ATOMLaunchViewController alloc] init];
                              [AppDelegate APP].window.rootViewController = [[DDLoginNavigationController alloc] initWithRootViewController:lvc];
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}
-(void) errorEccuredRET {
    [Hud text:@"出现未知错误" inView:self.view];
}
-(void) showInfoRET:(NSNotification *)notification {
    NSString* info = [[notification userInfo] valueForKey:@"info"];
    [Hud text:info inView:self.view];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:animated];
    if ([self isKindOfClass:[DDHomeVC class]]) {
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[ATOMPersonViewController class]]){
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[ATOMMyFollowViewController class]]) {
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[DDMessageVC class]]) {
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)popCurrentController {
    self.navigationItem.leftBarButtonItem.title = @"";
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)postSocialShare:(NSInteger)id withSocialShareType:(ATOMSocialShareType)shareType withPageType:(ATOMPageType)pageType {
//    ATOMShareModel* shareModel = [ATOMShareModel new];
//    NSMutableDictionary* param = [NSMutableDictionary new];
//    NSString* shareTypeToServer;
//    
//    if (shareType == ATOMShareTypeWechatFriends) {
//        shareTypeToServer = @"weixin";
//    } else if (shareType == ATOMShareTypeWechatMoments) {
//        shareTypeToServer = @"weixin";
//    } else if (shareType == ATOMShareTypeSinaWeibo) {
//        shareTypeToServer = @"weibo";
//    }
//
//    [param setObject:shareTypeToServer forKey:@"share_type"];
//    [param setObject:@(pageType) forKey:@"type"];
//    [param setObject:@(id) forKey:@"target_id"];
//    [shareModel getShareInfo:param withBlock:^(ATOMShare *share, NSError *error) {
//        if (share) {
//            [ATOMShareSDKModel postSocialShareShareSdk:share withShareType:shareType];
//        }
//    }];
}
- (void)postSocialShareShareSdk:(ATOMShare*)share  withShareType:(ATOMSocialShareType)shareType {

//    ShareType type;
//    NSString* shareUrl;
//    
//    if ([share.type isEqualToString:@"image"]) {
//        shareUrl = share.imageUrl;
//    } else {
//        shareUrl = share.url;
//    }
//    
//    NSString* shareTitle;
//    
//    if (shareType == ATOMShareTypeWechatFriends) {
//        type = ShareTypeWeixiSession;
//        shareTitle = [NSString stringWithFormat:@"%@",share.title];
//    } else if (shareType == ATOMShareTypeWechatMoments) {
//        type = ShareTypeWeixiTimeline;
//        shareTitle = [NSString stringWithFormat:@"%@",share.title];
//    } else if (shareType == ATOMShareTypeSinaWeibo) {
//        type = SSCShareTypeSinaWeibo;
//        shareTitle = [NSString stringWithFormat:@"#求PS大神#%@!点击链接%@",share.title,shareUrl];
//    }
//    NSString *str=[[NSBundle mainBundle] pathForResource:@"0" ofType:@"jpg"];
//    NSData *fileData = [NSData dataWithContentsOfFile:str];
//    
//    id<ISSContent> publishContent = [ShareSDK content:shareTitle //微博显示的文字
//                                       defaultContent:share.title
//                                                image:[ShareSDK imageWithData:fileData fileName:@"image" mimeType:@"Application/Image"]
//                                                title:shareTitle
//                                                  url:shareUrl
//                                          description:share.desc
//                                            mediaType:SSPublishContentMediaTypeImage];
//    [ShareSDK clientShareContent:publishContent //内容对象
//                            type:type //平台类型
//                   statusBarTips:NO
//                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
//                              [[KShareManager mascotAnimator]dismiss];
//                              if (state == SSPublishContentStateSuccess)
//                              {
//                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
//                              }
//                              else if (state == SSPublishContentStateFail)
//                              {
//                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
//                              }
//                          }];
}


@end
