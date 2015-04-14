//
//  ATOMFans.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMFans.h"

@implementation ATOMFans

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"fid" : @"fid",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"totalFansNumber" : @"fans_count",
             @"totalAskNumber" : @"ask_count",
             @"totalReplyNumber" : @"reply_count",
             @"isFellow" : @"is_fellow"
             };
}

@end
