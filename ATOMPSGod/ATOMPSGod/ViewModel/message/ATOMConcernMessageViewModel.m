//
//  ATOMConcernMessageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMConcernMessageViewModel.h"
#import "ATOMConcernMessage.h"

@implementation ATOMConcernMessageViewModel

- (void)setViewModelData:(ATOMConcernMessage *)concernMessage {
    _uid = concernMessage.uid;
    _userName = concernMessage.nickname;
    _userSex = concernMessage.sex ? @"man" : @"woman";
    _avatarURL = concernMessage.avatar;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:concernMessage.createTime];
    _publishTime = [df stringFromDate:publishDate];
}

@end
