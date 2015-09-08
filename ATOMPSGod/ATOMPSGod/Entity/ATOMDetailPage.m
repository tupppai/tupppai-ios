//
//  ATOMDetailImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMDetailPage.h"

@implementation ATOMDetailPage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"detailID" : @"id",
             @"askID":@"ask_id",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"replyTime" : @"create_time",
             @"imageURL" : @"image_url",
             @"replyDescription" : @"desc",
             @"isDownload" : @"is_download",
             @"totalPraiseNumber" : @"up_count",
             @"totalCommentNumber" : @"comment_count",
             @"totalShareNumber" : @"share_count",
             @"totalWXShareNumber" : @"weixin_share_count",
             @"imageWidth" : @"image_width",
             @"imageHeight" : @"image_height",
             @"liked" : @"uped",
             @"collected":@"collected",
             @"type":@"type",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"detailID" : @"detailID",
             @"imageID" : @"imageID",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"replyTime" : @"replyTime",
             @"imageURL" : @"imageURL",
             @"replyDescription" : @"replyDescription",
             @"isDownload" : @"isDownload",
             @"totalPraiseNumber" : @"totalPraiseNumber",
             @"totalCommentNumber" : @"totalCommentNumber",
             @"totalShareNumber" : @"totalShareNumber",
             @"totalWXShareNumber" : @"totalWXShareNumber",
             @"imageWidth" : @"imageWidth",
             @"imageHeight" : @"imageHeight",
             @"clickTime" : @"clickTime",
             @"hotCommentArray" : @"hotCommentArray",
             @"liked" : @"liked",
             @"collected":@"collected",
             @"type":@"type",
             @"askID":@"askID",
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"detailID"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMDetailPage";
}

@end
