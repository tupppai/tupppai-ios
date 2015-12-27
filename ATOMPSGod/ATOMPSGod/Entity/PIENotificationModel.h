//
//  PIENotificationEntity.h
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBaseModel.h"

@interface PIENotificationModel : PIEBaseModel

@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) NSInteger senderID;
@property (nonatomic, assign) NSInteger targetID;
@property (nonatomic, assign) NSInteger targetType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger askID;
@property (nonatomic, assign) NSInteger replyID;
@property (nonatomic, assign) long long time;

@end
