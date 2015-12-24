//
//  PIEImageEntity.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/21/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEModelImage.h"

@implementation PIEModelImage
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"height" : @"image_height",
             @"width" : @"image_width",
             @"url" : @"image_url"
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"ID" : @"ID",
             @"height" : @"height",
             @"width" : @"width",
             @"url" : @"url",
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"ID"];
}

+ (NSString *)FMDBTableName {
    return @"PIEModelImage";
}

@end
