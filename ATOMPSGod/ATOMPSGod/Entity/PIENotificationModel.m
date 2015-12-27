//
//  PIENotificationEntity.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationModel.h"

@implementation PIENotificationModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"avatarUrl" : @"avatar",
             @"commentId" : @"comment_id",
             @"content" : @"content",
             @"ID" : @"id",
             @"username" : @"nickname",
             @"imageUrl" : @"pic_url",
//             @"receiverID" : @"receiver",
             @"senderID" : @"sender",
//             @"genderIsMan" : @"sex",
             @"targetID" : @"target_id",
             @"targetType" : @"target_type",
             @"type" : @"type",
             @"time" : @"update_time",
             @"askID" : @"target_ask_id",
             @"replyID" : @"reply_id",
             };
}

@end
