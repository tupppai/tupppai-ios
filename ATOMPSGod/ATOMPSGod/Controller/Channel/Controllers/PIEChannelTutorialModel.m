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
             @"ask_id":@"ask_id",
             @"userName":@"nickname",
             @"avatarUrl":@"avatar",
             @"publishTime": @"create_time",
             @"title": @"title",
             @"subTitle":@"description",
             @"love_count":@"love_count",
             @"click_count":@"click_count",
             @"reply_count":@"reply_count",
             @"tutorial_images":@"ask_uploads",
             @"coverImageUrl":@"image_url",
             @"hasBought":@"has_bought"
             };
}

+ (NSValueTransformer *)tutorial_imagesJSONTransformer{
    return
    [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIEChannelTutorialImageModel class]];
}

/** 暗度陈仓： 使用胖model，在model这里设置日期 */
- (NSString *)publishTime{
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:[_publishTime doubleValue]];
    
    return  [Util formatPublishTime:publishDate];
}

@end
