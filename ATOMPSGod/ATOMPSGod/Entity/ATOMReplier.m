//
//  ATOMReplier.m
//  ATOMPSGod
//
//  Created by atom on 15/4/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMReplier.h"

@implementation ATOMReplier

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"replierID" : @"reply_id",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar"
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"replierID" : @"replierID",
             @"imageID" : @"imageID",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar"
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"replierID"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMReplier";
}





















@end
