//
//  ATOMUser.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUser.h"

@implementation ATOMUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid" : @"data.uid",
             @"mobile" : @"data.is_bound_mobile",
//             @"locationID" : @"data.location",r
             @"nickname" : @"data.nickname",
             @"avatar" : @"data.avatar",
             @"sex" : @"data.sex",
             @"backgroundImage" : @"data.bg_image",
             @"attentionNumber" : @"data.fellow_count",
             @"fansNumber" : @"data.fans_count",
             @"praiseNumber" : @"data.uped_count",
             @"uploadNumber" : @"data.ask_count",
             @"replyNumber" : @"data.reply_count",
             @"proceedingNumber" : @"data.inprogress_count",
             @"attentionUploadNumber" : @"data.focus_count",
             @"attentionWorkNumber" : @"data.collection_count"
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"uid" : @"uid",
             @"mobile" : @"mobile",
             @"locationID" : @"locationID",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"backgroundImage" : @"backgroundImage",
             @"attentionNumber" : @"attentionNumber",
             @"fansNumber" : @"fansNumber",
             @"praiseNumber" : @"praiseNumber",
             @"uploadNumber" : @"uploadNumber",
             @"replyNumber" : @"replyNumber",
             @"proceedingNumber" : @"proceedingNumber",
             @"attentionUploadNumber" : @"attentionUploadNumber",
             @"attentionWorkNumber" : @"attentionWorkNumber"
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"uid"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMUser";
}

@end