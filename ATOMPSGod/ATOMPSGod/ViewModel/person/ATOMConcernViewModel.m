//
//  ATOMConcernViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMConcernViewModel.h"
#import "DDFollow.h"

@implementation ATOMConcernViewModel

- (void)setViewModelData:(DDFollow *)concern {
    _uid = concern.uid;
    _userName = concern.nickname;
    _userSex = concern.sex ? @"man" : @"woman";
    _avatarURL = concern.avatar;
    _fansCount = [NSString stringWithFormat:@"%zd", concern.fansCount];
    _askCount = [NSString stringWithFormat:@"%zd", concern.askCount];
    _replyCount = [NSString stringWithFormat:@"%zd", concern.replyCount];
    if (concern.isMyFollow == YES && concern.isMyFan == YES) {
        _concernStatus = 2;
    } else if(concern.isMyFollow == YES){
        _concernStatus = 1;
    } else if (concern.isMyFollow == NO) {
        _concernStatus = 0;
    }
}

@end
