//
//  BaseViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
#import "ATOMHomepageViewController.h"
#import "ATOMPersonViewController.h"
#import "ATOMMyAttentionViewController.h"
#import "ATOMMyMessageViewController.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMBaseViewController ()

@end

@implementation ATOMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHex:0x74c3ff];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, 19)];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [backButton addTarget:self action:@selector(popCurrentController) forControlEvents:UIControlEventTouchUpInside];
    _negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    _negativeSpacer.width = 0;
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectZero]]];
    } else {
        self.navigationItem.leftBarButtonItems = @[_negativeSpacer, barBackButtonItem];
    }
//    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:animated];
    if ([self isKindOfClass:[ATOMHomepageViewController class]]) {
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[ATOMPersonViewController class]]){
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[ATOMMyAttentionViewController class]]) {
        self.hidesBottomBarWhenPushed = NO;
    } else if ([self isKindOfClass:[ATOMMyMessageViewController class]]) {
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)popCurrentController {
    self.navigationItem.leftBarButtonItem.title = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)postWechatShareMoments:(ATOMShare*)share {
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"];
//    NSString* shareUrl;
//    if ([share.type isEqualToString:@"image"]) {
//        shareUrl = share.imageUrl;
//    } else {
//        shareUrl = share.url;
//    }
//    NSString* shareTitle = [NSString stringWithFormat:@"%@%@",@"求PS大神!",share.title];
//    
//    id<ISSContent> publishContent = [ShareSDK content:share.desc
//                                       defaultContent:share.title
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:shareTitle
//                                                  url:shareUrl
//                                          description:share.desc
//                                            mediaType:SSPublishContentMediaTypeNews];
//    [ShareSDK clientShareContent:publishContent //内容对象
//                            type:ShareTypeWeixiTimeline //平台类型
//                   statusBarTips:YES
//                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
//                              if (state == SSPublishContentStateSuccess)
//                              {
//                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
//                              }
//                              else if (state == SSPublishContentStateFail)
//                              {
//                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
//                              }
//                          }];
//}
//
//- (void)postWechatShareFriends:(ATOMShare*)share{
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"];
//    NSString* shareUrl;
//    if ([share.type isEqualToString:@"image"]) {
//        shareUrl = share.imageUrl;
//    } else {
//        shareUrl = share.url;
//    }
//    NSString* shareTitle = [NSString stringWithFormat:@"%@%@",@"求PS大神!",share.title];
//    id<ISSContent> publishContent = [ShareSDK content:share.desc
//                                       defaultContent:share.title
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:shareTitle
//                                                  url:shareUrl
//                                          description:share.desc
//                                            mediaType:SSPublishContentMediaTypeNews];
//    [ShareSDK clientShareContent:publishContent //内容对象
//                            type:ShareTypeWeixiSession //平台类型
//                   statusBarTips:YES
//                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
////                              ////[SVProgressHUD dismiss];
//                              if (state == SSPublishContentStateSuccess)
//                              {
//                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
//                              }
//                              else if (state == SSPublishContentStateFail)
//                              {
//                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
//                              }
//                          }];
//}
//
//- (void)postSinaWeiboShare:(ATOMShare*)share {
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"];
//    NSString* shareUrl;
//    if ([share.type isEqualToString:@"image"]) {
//        shareUrl = share.imageUrl;
//    } else {
//        shareUrl = share.url;
//    }
//    NSString* shareTitle = [NSString stringWithFormat:@"%@!%@,%@",share.title,@"求PS大神!",shareUrl];
//    
//    id<ISSContent> publishContent = [ShareSDK content:shareTitle //微博显示的文字
//                                       defaultContent:share.title
//                                                image:[ShareSDK imageWithUrl:share.imageUrl]
//                                                title:shareTitle
//                                                  url:shareUrl
//                                          description:share.desc
//                                            mediaType:SSPublishContentMediaTypeNews];
//    [ShareSDK clientShareContent:publishContent //内容对象
//                            type:SSCShareTypeSinaWeibo //平台类型
//                   statusBarTips:YES
//                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
//                              if (state == SSPublishContentStateSuccess)
//                              {
//                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
//                              }
//                              else if (state == SSPublishContentStateFail)
//                              {
//                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
//                              }
//                          }];
//}


//
//-(void)postSinaWeiboShareAskPage:(NSInteger)id {
//    ATOMShareModel* shareModel = [ATOMShareModel new];
//    NSMutableDictionary* param = [NSMutableDictionary new];
//    [param setObject:@"weibo" forKey:@"share_type"];
//    [param setObject:@"1" forKey:@"type"];
//    [param setObject:@(id) forKey:@"target_id"];
//    [shareModel getShareInfo:param withBlock:^(ATOMShare *share, NSError *error) {
//        if (share) {
//            [self postSinaWeiboShare:share];
//        }
//    }];
//}
//
//-(void)postWechatShareMomentAskPage:(NSInteger)id {
//    ATOMShareModel* shareModel = [ATOMShareModel new];
//    NSMutableDictionary* param = [NSMutableDictionary new];
//    [param setObject:@"weixin" forKey:@"share_type"];
//    [param setObject:@"1" forKey:@"type"];
//    [param setObject:@(id) forKey:@"target_id"];
//    [shareModel getShareInfo:param withBlock:^(ATOMShare *share, NSError *error) {
//        if (share) {
//            [self postWechatShareMoments:share];
//        }
//    }];
//}
//-(void)postWechatShareFriendsAskPage:(NSInteger)id {
//    ATOMShareModel* shareModel = [ATOMShareModel new];
//    NSMutableDictionary* param = [NSMutableDictionary new];
//    [param setObject:@"weixin" forKey:@"share_type"];
//    [param setObject:@"1" forKey:@"type"];
//    [param setObject:@(id) forKey:@"target_id"];
//    [shareModel getShareInfo:param withBlock:^(ATOMShare *share, NSError *error) {
//        if (share) {
//            [self postWechatShareFriends:share];
//        }
//    }];
//}


-(void)postSocialShare:(NSInteger)id withSocialShareType:(ATOMSocialShareType)shareType withPageType:(ATOMPageType)pageType {
    ATOMShareModel* shareModel = [ATOMShareModel new];
    NSMutableDictionary* param = [NSMutableDictionary new];
    
    NSString* shareTypeToServer;
    
    if (shareType == ATOMShareTypeWechatFriends) {
        shareTypeToServer = @"weixin";
    } else if (shareType == ATOMShareTypeWechatMoments) {
        shareTypeToServer = @"weixin";
    } else if (shareType == ATOMShareTypeSinaWeibo) {
        shareTypeToServer = @"weibo";
    }

    [param setObject:shareTypeToServer forKey:@"share_type"];
    [param setObject:@(pageType) forKey:@"type"];
    [param setObject:@(id) forKey:@"target_id"];
    [shareModel getShareInfo:param withBlock:^(ATOMShare *share, NSError *error) {
        if (share) {
            [self postSocialShareShareSdk:share withShareType:shareType];
        }
    }];
}
- (void)postSocialShareShareSdk:(ATOMShare*)share  withShareType:(ATOMSocialShareType)shareType {
    ShareType type;
    
    if (shareType == ATOMShareTypeWechatFriends) {
        type = ShareTypeWeixiSession;
    } else if (shareType == ATOMShareTypeWechatMoments) {
        type = ShareTypeWeixiTimeline;
    } else if (shareType == ATOMShareTypeSinaWeibo) {
        type = SSCShareTypeSinaWeibo;
    }
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"];
    NSString* shareUrl;
    if ([share.type isEqualToString:@"image"]) {
        shareUrl = share.imageUrl;
    } else {
        shareUrl = share.url;
    }
    NSString* shareTitle = [NSString stringWithFormat:@"%@!%@",share.title,@"小瑞子"];
//    NSString* shareTitle = [NSString stringWithFormat:@"%@!%@,%@",share.title,@"小瑞子",shareUrl];

    id<ISSContent> publishContent = [ShareSDK content:shareTitle //微博显示的文字
                                       defaultContent:share.title
                                                image:[ShareSDK imageWithUrl:share.imageUrl]
                                                title:shareTitle
                                                  url:@"http://ipeiwei.xyz/2015/06/29/xiaoruizi/"
                                          description:share.desc
                                            mediaType:SSPublishContentMediaTypeNews];
    [ShareSDK clientShareContent:publishContent //内容对象
                            type:type //平台类型
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
                              [[KShareManager mascotAnimator]dismiss];
                              if (state == SSPublishContentStateSuccess)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
                              }
                          }];
}
@end
