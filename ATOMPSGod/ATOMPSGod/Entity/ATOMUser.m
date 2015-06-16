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
             @"uid" : @"data.uid",
             @"nickname" : @"data.nickname",
             @"avatar" : @"data.avatar",
             @"sex" : @"data.sex",
             @"backgroundImage" : @"data.bg_image",
             @"attentionNumber" : @"data.fellow_count",
             @"fansNumber" : @"data.fans_count",
             @"praiseNumber" : @"data.uped_count",
             @"uploadNumber" : @"data.ask_count",
             @"replyNumber" : @"data.reply_count",
             @"proceedingNumber" : @"data.inprogress_count",
             @"attentionUploadNumber" : @"data.focus_count",
             @"attentionWorkNumber" : @"data.collection_count",
             
             
             @"collectionCount" : @"data.collection_count",
             @"boundPhone" : @"data.is_bound_mobile",
             @"boundWeibo" : @"data.is_bound_weibo",
             @"boundWechat" : @"data.is_bound_weixin",
             @"locationID" : @"data.location",
             @"cityID" : @"data.city",
             @"provinceID" : @"data.province",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"uid" : @"uid",
             @"mobile" : @"mobile",
             @"locationID" : @"locationID",
             @"nickname" : @"nickname",
             @"avatar" : @"avatar",
             @"sex" : @"sex",
             @"backgroundImage" : @"backgroundImage",
             @"attentionNumber" : @"attentionNumber",
             @"fansNumber" : @"fansNumber",
             @"praiseNumber" : @"praiseNumber",
             @"uploadNumber" : @"uploadNumber",
             @"replyNumber" : @"replyNumber",
             @"proceedingNumber" : @"proceedingNumber",
             @"attentionUploadNumber" : @"attentionUploadNumber",
 

             };
}

//"ask_count" = 0;
//avatar = "http://wx.qlogo.cn/mmopen/YSF36exBKicMRicuqbXfx5aNONDPOfOickooia1Ah3DCLsBqbzkGQicdt0by5Zeej5n4FO8J4KRgRzA9R3oXannxtRxNL38rAOSvN/0";
//city = 10;
//"collection_count" = 0;
//"fans_count" = 0;
//"fellow_count" = 0;
//"inprogress_count" = 0;
//"is_bound_mobile" = 13128981404;
//"is_bound_qq" = 0;
//"is_bound_weibo" = 0;
//"is_bound_weixin" = 1;
//location = 0;
//nickname = peiwei;
//phone = 13128981404;
//province = 32;
//"reply_count" = 0;
//sex = 1;
//status = 1;
//uid = 232;
//"uped_count" = 0;


+ (NSArray *)FMDBPrimaryKeys {
    return @[@"uid"];
}

+ (NSString *)FMDBTableName {
    return @"ATOMUser";
}

@end