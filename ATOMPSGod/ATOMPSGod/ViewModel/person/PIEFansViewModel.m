//
//  ATOMFansViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEFansViewModel.h"
#import "PIEEntityFan.h"

@implementation PIEFansViewModel

- (void)setViewModelData:(PIEEntityFan *)fans {
    _uid        = fans.uid;
    _userName   = fans.nickname;
    _userSex    = fans.sex ? @"man" : @"woman";
    _avatarURL  = fans.avatar;
    _fansCount  = [NSString stringWithFormat:@"%d", (int)fans.fansCount];
    _askCount   = [NSString stringWithFormat:@"%d", (int)fans.askCount];
    _replyCount = [NSString stringWithFormat:@"%d", (int)fans.replyCount];
    _isFollow   = fans.isFollow;
    _isMyFan    = fans.isMyFan;
//    if (fans.isFollow == YES && fans.isMyFan == YES) {
//        _followStatus = 2;
//    } else if(fans.isFollow == YES){
//        _followStatus = 1;
//    } else if (fans.isFollow == NO) {
//        _followStatus = 0;
//    }
}

@end
