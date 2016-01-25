//
//  ATOMUser.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEUserModel.h"

@implementation PIEUserModel
-(instancetype)init {
    self = [super init];
    if (self) {
        _avatar = @"";
        _mobile = @"";
        _nickname = @"";
        _token = @"";
        _blocked = NO;
        _balance = 0.0;
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid" : @"uid",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"backgroundImage" : @"bg_image",
             @"attentionNumber" : @"fellow_count",
             @"fansNumber" : @"fans_count",
             @"likedCount" : @"uped_count",
             @"uploadNumber" : @"ask_count",
             @"replyNumber" : @"reply_count",
             @"proceedingNumber" : @"inprogress_count",
             @"attentionUploadNumber" : @"focus_count",
             @"attentionWorkNumber" : @"collection_count",
             @"mobile" : @"phone",
             @"bindWeibo" : @"is_bound_weibo",
             @"bindWechat" : @"is_bound_weixin",
             @"bindQQ":@"is_bound_qq",
             @"isMyFan":@"is_fan",
             @"isMyFollow":@"is_follow",
             @"token":@"token",
             @"blocked": @"is_block",
             @"isV":@"is_star",
             @"balance":@"balance",
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
             @"uploadNumber" : @"uploadNumber",
             @"replyNumber" : @"replyNumber",
             @"proceedingNumber" : @"proceedingNumber",
             @"attentionUploadNumber" : @"attentionUploadNumber",
             @"attentionWorkNumber" : @"attentionWorkNumber",
             @"mobile" : @"mobile",
             @"bindWeibo" : @"bindWeibo",
             @"bindWechat" : @"bindWechat",
             @"bindQQ":@"bindQQ",
             @"locationID" : @"locationID",
             @"cityID" : @"cityID",
             @"provinceID" : @"provinceID",
             @"isMyFan":@"isMyFan",
             @"isMyFollow":@"isMyFan",
             @"token":@"token",
             @"likedCount":@"likedCount",
             @"blocked":@"blocked",
             @"isV":@"isV",
             @"balance":@"balance",
             };
}

-(instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        for (NSString *fieldName in dictionary) {
            id value = [dictionary objectForKey:fieldName];
            if (value == [NSNull null]) {
                continue;
            }
            [self setValue:value forKey:fieldName];
        }
    }
    return self;
    
}
+ (NSArray *)FMDBPrimaryKeys {
    return @[@"uid"];
}

+ (NSString *)FMDBTableName {
    return @"PIEUserTable";
}





@end