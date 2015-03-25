//
//  ATOMImageTipLabel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMImageTipLabel.h"

@implementation ATOMImageTipLabel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"labelID" : @"id",
             @"content" : @"content",
             @"x" : @"x",
             @"y" : @"y",
             @"labelDirection" : @"direction"
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"imageID" : @"imageID",
             @"labelID" : @"labelID",
             @"content" : @"content",
             @"x" : @"x",
             @"y" : @"y",
             @"labelDirection" : @"labelDirection"
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"labelID"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMImageTipLabel";
}


@end
