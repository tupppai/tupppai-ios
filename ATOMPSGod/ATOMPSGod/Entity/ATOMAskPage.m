//
//  ATOMHomeImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAskPage.h"

@implementation ATOMAskPage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"imageID" : @"id",
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
             @"imageWidth" : @"image_width",
             @"imageHeight" : @"image_height",
             @"liked" :@"uped",
             @"collected" : @"collected",
             @"homePageType" :  @"homePageType",
             @"type" : @"type",
             @"askImageModelArray":@"uploads"
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"imageID" : @"imageID",
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
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"imageID"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMAskPage";
}

@end
