//
//  ATOMAtComment.m
//  ATOMPSGod
//
//  Created by atom on 15/3/31.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAtComment.h"

@implementation ATOMAtComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cid" : @"cid",
             @"uid" : @"uid",
             @"nick" : @"nick",
             @"content" : @"content"
             };
}

@end
