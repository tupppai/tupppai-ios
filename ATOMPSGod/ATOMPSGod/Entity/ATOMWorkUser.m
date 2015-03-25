//
//  ATOMWorkUser.m
//  ATOMPSGod
//
//  Created by atom on 15/3/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMWorkUser.h"

@implementation ATOMWorkUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar"
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"imageID" : @"imageID",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar"
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"uid"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMWorkUser";
}

@end
