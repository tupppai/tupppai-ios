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
    _concernStatus = concern.concernStatus;
}

@end
