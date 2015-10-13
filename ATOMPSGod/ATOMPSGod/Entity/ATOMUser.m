//
//  ATOMUser.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUser.h"

@implementation ATOMUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"backgroundImage" : @"bg_image",
             @"attentionNumber" : @"fellow_count",
             @"fansNumber" : @"fans_count",
             @"likeNumber" : @"uped_count",
             @"uploadNumber" : @"ask_count",
             @"replyNumber" : @"reply_count",
             @"proceedingNumber" : @"inprogress_count",
             @"attentionUploadNumber" : @"focus_count",
             @"attentionWorkNumber" : @"collection_count",
             @"mobile" : @"is_bound_mobile",
             @"bindWeibo" : @"is_bound_weibo",
             @"bindWechat" : @"is_bound_weixin",
//             @"locationID" : @"location",
//             @"cityID" : @"city",
//             @"provinceID" : @"province",
             @"isMyFan":@"is_fan",
             @"isMyFollow":@"is_follow",
             };
}
+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"backgroundImage" : @"backgroundImage",
             @"attentionNumber" : @"attentionNumber",
             @"fansNumber" : @"fansNumber",
             @"likeNumber" : @"likeNumber",
             @"uploadNumber" : @"uploadNumber",
             @"replyNumber" : @"replyNumber",
             @"proceedingNumber" : @"proceedingNumber",
             @"attentionUploadNumber" : @"attentionUploadNumber",
             @"attentionWorkNumber" : @"attentionWorkNumber",
             @"mobile" : @"mobile",
             @"bindWeibo" : @"bindWeibo",
             @"bindWechat" : @"bindWechat",
             @"locationID" : @"locationID",
             @"cityID" : @"cityID",
             @"provinceID" : @"provinceID",
             @"isMyFan":@"isMyFan",
             @"isMyFollow":@"isMyFan",
             };
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"uid"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMUser";
}

-(void)NSLogSelf {
    NSArray* array = [NSArray arrayWithObjects:_nickname,_avatar, nil];
    NSLog(@"ATOMUser description -> \n %@",array);
}

@end