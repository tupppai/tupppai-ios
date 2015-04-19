//
//  ATOMHomeImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomeImage.h"

@implementation ATOMHomeImage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"imageID" : @"id",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"uploadTime" : @"ask_created",
             @"imageURL" : @"image_url",
             @"userDescription" : @"desc",
             @"isDownload" : @"is_download",
             @"totalPraiseNumber" : @"up_count",
             @"totalCommentNumber" : @"comment_count",
             @"totalShareNumber" : @"share_count",
             @"totalWXShareNumber" : @"weixin_share_count",
             @"totalWorkNumber" : @"reply_count",
             @"imageWidth" : @"image_width",
             @"imageHeight" : @"image_height"
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"imageID" : @"imageID",
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
             @"replierArray" : @"replierArray"
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"imageID"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMHomeImage";
}

@end
