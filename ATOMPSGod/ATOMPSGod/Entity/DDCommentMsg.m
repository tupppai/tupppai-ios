//
//  ATOMCommentMessage.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDCommentMsg.h"

@implementation DDCommentMsg

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"ID" : @"id",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"createTime" : @"create_time",
             @"content" : @"content",
             @"commentType" : @"type"
             };
}

@end