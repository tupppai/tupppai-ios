//
//  ATOMFansViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMFansViewModel.h"
#import "ATOMFans.h"

@implementation ATOMFansViewModel

- (void)setViewModelData:(ATOMFans *)fans {
    _uid = fans.uid;
    _userName = fans.nickname;
    _userSex = fans.sex ? @"man" : @"woman";
    _avatarURL = fans.avatar;
    _totalFansNumber = [NSString stringWithFormat:@"%d", (int)fans.totalFansNumber];
    _totalAskNumber = [NSString stringWithFormat:@"%d", (int)fans.totalAskNumber];
    _totalReplyNumber = [NSString stringWithFormat:@"%d", (int)fans.totalReplyNumber];
    _isFellow = fans.isFellow;
}

@end
