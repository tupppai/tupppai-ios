//
//  BaseViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMShare.h"
#import "ATOMShareModel.h"
typedef enum {
    ATOMTakingPhoto = 0,
    ATOMChangingHeaderImage,
    ATOMChangingBackGroundImage
}ATOMClickUserHeaderEventType;

typedef enum {
    ATOMUploadWorType = 0,
    ATOMAskType,
    ATOMTakePhotoType
}ATOMPSEventType;

typedef enum {
    ATOMCommentMessageType = 0,
    ATOMInviteMessageType,
    ATOMTopicReplyMessageType,
    ATOMMyUploadType,
    ATOMMyWorkType,
    ATOMProceedingType,
    ATOMMyCollectionType,
    ATOMInviteType,
    ATOMShareType
} ATOMDetailPushType;

typedef enum {
    ATOMHomepageHotType = 0,
    ATOMHomepageAskType
}ATOMHomepageViewType;

typedef enum {
    ATOMPageTypeAsk = 1,
    ATOMPageTypeReply = 2
}ATOMPageType;

typedef enum {
    ATOMShareTypeWechatMoments = 0,
    ATOMShareTypeWechatFriends ,
    ATOMShareTypeSinaWeibo
}ATOMSocialShareType;

@interface ATOMBaseViewController : UIViewController

@property (nonatomic, strong) UIBarButtonItem *negativeSpacer;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popCurrentController;
//- (void)postWechatShareMoments:(ATOMShare*)share;
//- (void)postWechatShareFriends:(ATOMShare*)share;
//- (void)postSinaWeiboShare:(ATOMShare*)share;
-(void)postSinaWeiboShareAskPage:(NSInteger)id;
-(void)postWechatShareMomentAskPage:(NSInteger)id;
-(void)postWechatShareFriendsAskPage:(NSInteger)id;
-(void)postSocialShare:(NSInteger)id withSocialShareType:(ATOMSocialShareType)shareType withPageType:(ATOMPageType)pageType;
@end
