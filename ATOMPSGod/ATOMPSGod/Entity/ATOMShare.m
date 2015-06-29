//
//  ATOMShare.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/26/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMShare.h"

@implementation ATOMShare
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"desc" : @"desc",
             @"title" : @"title",
             @"type" : @"type",
             @"url" : @"url",
             @"imageUrl" : @"image"
             };
}
@end
