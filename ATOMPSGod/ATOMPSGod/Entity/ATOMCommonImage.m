//
//  ATOMCommonImage.m
//  ATOMPSGod
//
//  Created by atom on 15/5/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommonImage.h"

@implementation ATOMCommonImage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"imageID" : @"id",
             @"askID" : @"ask_id",
             @"type" : @"type",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"uploadTime" : @"create_time",
             @"imageURL" : @"image_url",
             @"userDescription" : @"desc",
             @"isDownload" : @"is_download",
             @"totalPraiseNumber" : @"up_count",
             @"totalCommentNumber" : @"comment_count",
             @"totalShareNumber" : @"share_count",
             @"totalWXShareNumber" : @"weixin_share_count",
             @"totalWorkNumber" : @"reply_count",
             @"imageWidth" : @"image_width",
             @"imageHeight" : @"image_height",
             @"liked" : @"uped"
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"imageID" : @"imageID",
             @"type" : @"type",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
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
             @"tipLabelArray" :@"tipLabelArray",
             @"replierArray" : @"replierArray",
             @"hotCommentArray" : @"hotCommentArray",
             @"liked" : @"liked"
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"imageID"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMCommonImage";
}

@end
