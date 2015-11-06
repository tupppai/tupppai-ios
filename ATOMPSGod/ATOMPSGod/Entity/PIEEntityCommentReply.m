//
//  ATOMAtComment.m
//  ATOMPSGod
//
//  Created by atom on 15/3/31.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEEntityCommentReply.h"

@implementation PIEEntityCommentReply

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"ID" : @"comment_id",
             @"uid" : @"uid",
             @"username" : @"nickname",
             @"text" : @"content"
             };
}

@end
