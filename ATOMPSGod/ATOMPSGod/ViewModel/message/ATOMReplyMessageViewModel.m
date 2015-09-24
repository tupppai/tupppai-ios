//
//  ATOMReplyMessageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMReplyMessageViewModel.h"
#import "ATOMReplyMessage.h"
#import "PIEPageEntity.h"
#import "DDPageVM.h"

@implementation ATOMReplyMessageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _homepageViewModel = [DDPageVM new];
    }
    return self;
}

- (void)setViewModelData:(ATOMReplyMessage *)replyMessage {
    _uid = replyMessage.uid;
    _userName = replyMessage.nickname;
    _theme = (replyMessage.type == 0) ? @"处理了你的图片" : @"这位大神也处理了这个图片";
    _avatarURL = replyMessage.avatar;
    _userSex = replyMessage.sex ? @"man" : @"woman";
    _imageURL = replyMessage.homeImage.imageURL;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:replyMessage.createTime];
    _publishTime = [df stringFromDate:publishDate];
   _homepageViewModel = [[DDPageVM alloc]initWithPageEntity:replyMessage.homeImage];
}

@end
