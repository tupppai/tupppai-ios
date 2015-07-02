//
//  ATOMDetailImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMDetailImage.h"

@implementation ATOMDetailImage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"detailID" : @"id",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"replyTime" : @"reply_created",
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
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"detailID" : @"detailID",
             @"imageID" : @"imageID",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
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
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"detailID"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMDetailImage";
}

@end
