//
//  ATOMHomeImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//


#import  "PIEModelImage.h"
#import  "PIECommentModel.h"
#import "PIECategoryModel.h"

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
             @"collected" : @"collected",
             @"type" : @"type",
             @"models_image":@"ask_uploads",
             @"models_comment":@"hot_comments",
             @"followed":@"is_follow",
             @"isMyFan" : @"is_fan",
             @"imageRatio":@"image_ratio",
             @"models_category":@"categories",
             @"isV":@"is_star",
             @"loveStatus":@"love_count",
             @"channelID":@"category_id",
             };
}


+ (NSValueTransformer*)models_imageJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIEModelImage class]];
}
+ (NSValueTransformer*)models_commentJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIECommentModel class]];
}
+ (NSValueTransformer*)models_categoryJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIECategoryModel class]];
}



+ (NSValueTransformer *)loveStatusJSONTransformer {
    
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @0: @(PIEPageLoveStatus0),
                                                                           @1: @(PIEPageLoveStatus1),
                                                                           @2: @(PIEPageLoveStatus2),
                                                                           @3: @(PIEPageLoveStatus3),
                                                                           }];
}


+ (NSValueTransformer *)typeJSONTransformer {
    
    return [MTLValueTransformer transformerWithBlock:^id(NSNumber* type) {
        if ([type integerValue] == 1) {
            return @(PIEPageTypeAsk);
        } else {
            return @(PIEPageTypeReply);
        }
    }];
}

@end
