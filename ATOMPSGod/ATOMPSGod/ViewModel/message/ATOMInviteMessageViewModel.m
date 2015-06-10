//
//  ATOMInviteMessageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteMessageViewModel.h"
#import "ATOMInviteMessage.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMHomeImage.h"

@implementation ATOMInviteMessageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _homepageViewModel = [ATOMAskPageViewModel new];
    }
    return self;
}

- (void)setViewModelData:(ATOMInviteMessage *)inviteMessage {
    _uid = inviteMessage.uid;
    _userName = inviteMessage.nickname;
    _avatarURL = inviteMessage.avatar;
    _userSex = inviteMessage.sex ? @"man" : @"woman";
    _imageURL = inviteMessage.homeImage.imageURL;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:inviteMessage.createTime];
    _publishTime = [df stringFromDate:publishDate];
    [_homepageViewModel setViewModelData:inviteMessage.homeImage];
}

@end
