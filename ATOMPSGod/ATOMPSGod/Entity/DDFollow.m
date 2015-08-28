//
//  ATOMConcern.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDFollow.h"

@implementation DDFollow

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"fid" : @"fid",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"fansCount" : @"fans_count",
             @"askCount" : @"ask_count",
             @"replyCount" : @"reply_count",
             @"isMyFan" : @"is_fan",
             @"isMyFollow":@"is_follow",
             @"invited":@"has_invited",
             };
}

@end
