//
//  ATOMComment.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMComment.h"

@implementation ATOMComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cid" : @"comment_id",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
//             @"sex" : @"sex",
             @"avatar" : @"avatar",
             @"content" : @"content",
             @"commentTime" : @"created_time",
             @"praiseNumber" : @"up_count",
             @"liked": @"uped"
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"cid" : @"cid",
             @"imageID" : @"imageID",
             @"detailID" : @"detailID",
             @"commentType" : @"commentType",
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"sex" : @"sex",
             @"avatar" : @"avatar",
             @"content" : @"content",
             @"commentTime" : @"commentTime",
             @"praiseNumber" : @"praiseNumber",
             @"atCommentArray" : @"atCommentArray",
             @"liked": @"liked"
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"cid"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMComment";
}

@end
