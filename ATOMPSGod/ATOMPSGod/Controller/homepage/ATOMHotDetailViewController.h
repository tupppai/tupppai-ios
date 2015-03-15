//
//  ATOMHotDetailViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"

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

@end
