//
//  ATOMHomeImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEPageEntity.h"

@implementation PIEPageEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"ID" : @"id",
             @"uid" : @"uid",
             @"askID" : @"ask_id",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"uploadTime" : @"create_time",
             @"imageURL" : @"image_url",
             @"userDescription" : @"desc",
             @"isDownload" : @"is_download",
             @"totalPraiseNumber" : @"up_count",
             @"totalCommentNumber" : @"comment_count",
             @"totalShareNumber" : @"share_count",
             @"totalWXShareNumber" : @"weixin_share_count",
             @"totalWorkNumber" : @"reply_count",
             @"collectCount" : @"collect_count",
             @"imageWidth" : @"image_width",
             @"imageHeight" : @"image_height",
             @"liked" :@"uped",
             @"collected" : @"collected",
             @"type" : @"type",
             @"askImageModelArray":@"ask_uploads",
             @"followed":@"followed",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"ID" : @"ID",
             @"askID" : @"askID",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"uploadTime" : @"uploadTime",
             @"imageURL" : @"imageURL",
             @"userDescription" : @"userDescription",
             @"isDownload" : @"isDownload",
             @"totalPraiseNumber" : @"totalPraiseNumber",
             @"totalCommentNumber" : @"totalCommentNumber",
             @"totalShareNumber" : @"totalShareNumber",
             @"totalWXShareNumber" : @"totalWXShareNumber",
             @"totalWorkNumber" : @"totalWorkNumber",
             @"imageWidth" : @"imageWidth",
             @"imageHeight" : @"imageHeight",
             @"homePageType":  @"homePageType",
             @"liked" :@"liked",
             @"collected":@"collected",
             @"type":@"type",
             @"askImageModelArray":@"askImageModelArray",
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"ID"];
}

+ (NSString *)FMDBTableName {
    return @"PIEPageEntity";
}

@end
