//
//  PIENotificationEntity.m
//  TUPAI
//
//  Created by chenpeiwei on 10/14/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationEntity.h"

@implementation PIENotificationEntity
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
             @"genderIsMan" : @"sex",
             @"target_id" : @"target_id",
             @"targetType" : @"target_type",
             @"type" : @"type",
             @"updateTime" : @"update_time",
             @"askID" : @"ask_id",
             @"replyID" : @"reply_id",
             };
}

@end
