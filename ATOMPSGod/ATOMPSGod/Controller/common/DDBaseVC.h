//
//  BaseViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMShare.h"
#import "DDShareManager.h"
typedef NS_ENUM(NSInteger, ATOMNotifyType) {
    ATOMNotifyTypeComment = 0,
    ATOMNotifyTypeReply,
    ATOMNotifyTypeAttention,
    ATOMNotifyTypeInvite,
    ATOMNotifyTypeSystem,
};


typedef NS_ENUM(NSInteger, ATOMHomepageViewType) {
    ATOMHomepageViewTypeHot = 0,
    ATOMHomepageViewTypeAsk
};

typedef NS_ENUM(NSInteger, ATOMPageType) {
    ATOMPageTypeAsk = 1,
    ATOMPageTypeReply = 2
};

typedef NS_ENUM(NSInteger, ATOMShareType) {
    ATOMShareTypeWechatMoments = 0,
    ATOMShareTypeWechatFriends,
    ATOMShareTypeSinaWeibo
};

@interface DDBaseVC : UIViewController

@property (nonatomic, strong) UIBarButtonItem *negativeSpacer;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popCurrentController;
@end
