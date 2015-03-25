//
//  ATOMHotDetailViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
@class ATOMHomePageViewModel;

typedef enum {
    ATOMCommentMessageType = 0,
    ATOMInviteMessageType,
    ATOMTopicReplyMessageType,
    ATOMMyUploadType,
    ATOMMyWorkType,
    ATOMProceedingType,
    ATOMMyCollectionType,
    ATOMInviteType
} ATOMHotDetailPushType;

@interface ATOMHotDetailViewController : ATOMBaseViewController

@property (nonatomic, assign) ATOMHotDetailPushType pushType;
@property (nonatomic, strong) ATOMHomePageViewModel *homePageViewModel;

@end
