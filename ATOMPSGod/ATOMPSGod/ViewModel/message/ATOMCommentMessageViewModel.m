//
//  ATOMCommentMessageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentMessageViewModel.h"
#import "ATOMCommentMessage.h"
#import "ATOMHomeImage.h"
#import "DDAskPageVM.h"

@implementation ATOMCommentMessageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _homepageViewModel = [DDAskPageVM new];
    }
    return self;
}

- (void)setViewModelData:(ATOMCommentMessage *)commentMessage {
    _uid = commentMessage.uid;
    _userName = commentMessage.nickname;
    _theme = (commentMessage.type == 0) ? @"评论你" : @"回复你";
    _avatarURL = commentMessage.avatar;
    _userSex = commentMessage.sex ? @"man" : @"woman";
    _content = commentMessage.content;
    _imageURL = commentMessage.homeImage.imageURL;
    _type = commentMessage.commentType;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:commentMessage.createTime];
    _publishTime = [df stringFromDate:publishDate];
    [_homepageViewModel setViewModelData:commentMessage.homeImage];
}

@end
