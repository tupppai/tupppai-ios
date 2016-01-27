//
//  PIEChannelTutorialModel.m
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialModel.h"
#import "PIEChannelTutorialImageModel.h"

#import "PIEPageVM.h"
#import "PIEPageModel.h"



@implementation PIEChannelTutorialModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"ID":@"id",
             @"ask_id":@"ask_id",
             @"userName":@"nickname",
             @"uid":@"uid",
             @"isV":@"is_star",
             @"avatarUrl":@"avatar",
             @"isMyFan":@"is_fan",
             @"isMyFollow":@"is_follow",
             @"uploadTime": @"create_time",
             @"title": @"title",
             @"subTitle":@"description",
             @"love_count":@"love_count",
             @"click_count":@"click_count",
             @"reply_count":@"reply_count",
             @"comment_count":@"comment_count",
             @"tutorial_images":@"ask_uploads",
             @"coverImageUrl":@"image_url",
             @"hasBought":@"has_bought"
             };
}

+ (NSValueTransformer *)tutorial_imagesJSONTransformer{
    return
    [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PIEChannelTutorialImageModel class]];
}

/** 暗度陈仓： 使用胖model，在model这里设置日期 */
- (NSString *)publishTime{
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:_uploadTime];
    
    return  [Util formatPublishTime:publishDate];
}

- (PIEPageVM *)piePageVM
{
    PIEPageModel *pageModel = [[PIEPageModel alloc] init];
    
    pageModel.ID                 = self.ID;
    pageModel.askID              = self.ask_id;

    /* pageModel.channelID ??*/

    pageModel.type               = PIEPageTypeAsk;
    pageModel.uploadTime         = self.uploadTime;
    pageModel.imageURL           = self.coverImageUrl;
    pageModel.userDescription    = self.subTitle;
    pageModel.totalPraiseNumber  = self.love_count;
    pageModel.totalCommentNumber = self.comment_count;

    pageModel.uid                = self.uid;
    pageModel.nickname           = self.userName;
    pageModel.followed           = self.isMyFollow;
    pageModel.isMyFan            = self.isMyFan;
    pageModel.isV                = self.isV;
   
    PIEPageVM *pageVM = [[PIEPageVM alloc] initWithPageEntity:pageModel];
    
    return pageVM;
}

@end
