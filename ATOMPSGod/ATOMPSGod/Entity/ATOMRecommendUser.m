//
//  ATOMRecommendUser.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/29/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMRecommendUser.h"

@implementation ATOMRecommendUser
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"askCount" : @"ask_count",
             @"avatarUrl" : @"avatar",
             @"fansCount" : @"fans_count",
             @"fellowCount" : @"fellow_count",
             @"invited" : @"has_invited",
             @"isFan" : @"is_fans",
             @"isFellow" : @"is_fellow",
             @"nickname" : @"nickname",
             @"replyCount" : @"reply_count",
             @"sex" : @"sex",
             @"uid" : @"uid",
             @"username" : @"username"
             };
}
@end
