//
//  ATOMConcernViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMConcernViewModel.h"
#import "ATOMConcern.h"

@implementation ATOMConcernViewModel

- (void)setViewModelData:(ATOMConcern *)concern {
    _uid = concern.uid;
    _userName = concern.nickname;
    _userSex = concern.sex ? @"man" : @"woman";
    _avatarURL = concern.avatar;
    _totalFansNumber = [NSString stringWithFormat:@"%d", (int)concern.totalFansNumber];
    _totalAskNumber = [NSString stringWithFormat:@"%d", (int)concern.totalAskNumber];
    _totalReplyNumber = [NSString stringWithFormat:@"%d", (int)concern.totalReplyNumber];
    if (concern.isMyFollow == YES && concern.isMyFan == YES) {
        _concernStatus = 2;
    } else if(concern.isMyFollow == YES){
        _concernStatus = 1;
    } else if (concern.isMyFollow == NO) {
        _concernStatus = 0;
    }
}

@end
