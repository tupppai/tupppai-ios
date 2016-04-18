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
                                                                           @"activity": @(PIECategoryTypeActivity),
                                                                           @"tutorial": @(PIECategoryTypeTutorial),
                                                                           }];
}

+ (NSValueTransformer *)threadsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIEPageModel class]];
}


/*
    2016-3-22： 这是服务器的锅，在最新求P区里不应该出现“男神活动”的页面。
               所以在测试服里一点开最新求P区就会马上崩溃，因为type为nil。
               这里为type字段设置一个默认的值，APP不会崩溃，但是后台担心
               这样可能会给用户机会去污染后台数据。所以现在前端先这样修改着。
 
 */
- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"type"]) {
        self.type = PIECategoryTypeChannel;
    }else{
        [super setNilValueForKey:key];
    }
}
@end

