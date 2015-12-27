//
//  PIECategoryModel.m
//  TUPAI
//
//  Created by chenpeiwei on 12/24/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECategoryModel.h"

@implementation PIECategoryModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{

             @"ID":@"id",
             @"imageUrl":@"app_pic",
             @"post_btn":@"post_btn",
             @"banner_pic":@"banner_pic",
             @"iconUrl":@"icon",
             @"title":@"display_name",
             @"content":@"description",
             @"url":@"url",
             @"askID":@"ask_id",
             @"type":@"category_type",
             @"threads":@"threads",
             };
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"channel": @(PIECategoryTypeChannel),
                                                                           @"activity": @(PIECategoryTypeActivity)
                                                                           }];
}

+ (NSValueTransformer *)threadsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIEPageModel class]];
}
@end
