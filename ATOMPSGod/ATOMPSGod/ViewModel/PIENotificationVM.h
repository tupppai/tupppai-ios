//
//  PIENotificationVM.h
//  TUPAI
//
//  Created by chenpeiwei on 10/15/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIEModelNotification.h"
typedef NS_ENUM(NSInteger, PIENotificationType) {
    PIENotificationTypeSystem  = 0,
    PIENotificationTypeComment = 1,
    PIENotificationTypeReply   = 2,
    PIENotificationTypeFollow  = 3,
    PIENotificationTypeLike    = 5,
};
@interface PIENotificationVM : NSObject
@property (nonatomic, copy  ) NSString  *avatarUrl;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, copy  ) NSString  *content;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy  ) NSString  *username;
@property (nonatomic, copy  ) NSString  *imageUrl;
@property (nonatomic, assign) NSInteger senderID;
@property (nonatomic, assign) NSInteger targetID;
@property (nonatomic, assign) NSInteger targetType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger askID;
@property (nonatomic, assign) NSInteger replyID;
@property (nonatomic, copy  ) NSString  *time;

- (instancetype)initWithEntity:(PIEModelNotification *)entity ;

@end

