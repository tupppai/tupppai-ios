//
//  BaseViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ATOMTakingPhoto = 0,
    ATOMChangingHeaderImage,
    ATOMChangingBackGroundImage
}ATOMClickUserHeaderEventType;

typedef enum {
    ATOMUploadWorType = 0,
    ATOMSeekHelpType,
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

@interface ATOMBaseViewController : UIViewController

@property (nonatomic, strong) UIBarButtonItem *negativeSpacer;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popCurrentController;

@end
