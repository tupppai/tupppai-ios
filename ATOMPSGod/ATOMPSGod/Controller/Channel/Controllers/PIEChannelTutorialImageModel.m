//
//  PIEChannelTutorialImageModel.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialImageModel.h"

@implementation PIEChannelTutorialImageModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"imageURL": @"image_url",
             @"imageHeight": @"image_height",
             @"imageWidth": @"image_width",
             @"imageRatio": @"image_ratio",
             };
}

@end
