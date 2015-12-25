//
//  ATOMImage.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEModelImageInfo.h"

@implementation PIEModelImageInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"imageID" : @"data.id",
             @"imageURL" : @"data.url",
             @"imageName" : @"data.name"
             };
}

@end
