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
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0x727272], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, 19)];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [backButton addTarget:self action:@selector(popCurrentController) forControlEvents:UIControlEventTouchUpInside];
    _negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    _negativeSpacer.width = -5;
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

- (void)wxShare {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"jpg"];
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [ShareSDK clientShareContent:publishContent //内容对象
                            type:ShareTypeWeixiTimeline //平台类型
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
                              [SVProgressHUD dismiss];
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

- (void)wxFriendShare {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"jpg"];
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [ShareSDK clientShareContent:publishContent //内容对象
                            type:ShareTypeWeixiSession //平台类型
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
                              [SVProgressHUD dismiss];
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
