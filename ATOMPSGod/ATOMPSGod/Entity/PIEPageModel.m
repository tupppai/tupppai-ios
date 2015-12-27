//
//  ATOMHomeImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//


#import  "PIEModelImage.h"
#import  "PIECommentEntity.h"
#import "PIEModelCatogory.h"

@implementation PIEPageModel

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
             @"totalWorkNumber" : @"reply_count",
             @"collectCount" : @"collect_count",
             @"imageWidth" : @"image_width",
             @"imageHeight" : @"image_height",
             @"liked" :@"uped",
             @"collected" : @"collected",
             @"type" : @"type",
             @"models_image":@"ask_uploads",
             @"models_comment":@"hot_comments",
             @"followed":@"is_follow",
             @"isMyFan" : @"is_fan",
             @"imageRatio":@"image_ratio",
             @"models_category":@"categories",
             @"isV":@"is_star",
             @"lovedCount":@"love_count",
             };
}


+ (NSValueTransformer*)models_imageJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIEModelImage class]];
}
+ (NSValueTransformer*)models_commentJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIECommentEntity class]];
}
+ (NSValueTransformer*)models_categoryJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIEModelCatogory class]];
}

@end
