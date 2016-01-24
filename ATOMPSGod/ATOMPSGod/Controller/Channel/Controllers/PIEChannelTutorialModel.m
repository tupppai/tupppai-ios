//
//  PIEChannelTutorialModel.m
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialModel.h"

@implementation PIEChannelTutorialModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"ID":@"id",
             @"ask_id": @"ask_id",
             @"publishTime": @"create_time",
             @"title": @"title",
             @"subTitle":@"description",
             @"love_count":@"love_count",
             @"click_count":@"click_count",
             @"reply_count":@"reply_count",
             @"tutorial_images":@"ask_uploads",
             @"hasSharedToWechat":@"has_shared_to_wechat",
             @"paidAmount": @"paid_amount"
             };
}

+ (NSValueTransformer *)tutorial_imagesJSONTransformer{
    return
    [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIEChannelTutorialImageModel class]];
}

@end
