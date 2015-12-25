//
//  ATOMConcernViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEFollowViewModel.h"
#import "PIEEntityFollow.h"

@implementation PIEFollowViewModel

- (void)setViewModelData:(PIEEntityFollow *)concern {
    _model = concern;
    _uid        = concern.uid;
    _userName   = concern.nickname;
    
    //refactor this shit
    _userSex    = concern.sex ? @"man" : @"woman";
    _avatarURL  = concern.avatar;
    _fansCount  = [NSString stringWithFormat:@"%zd", concern.fansCount];
    _askCount   = [NSString stringWithFormat:@"%zd", concern.askCount];
    _replyCount = [NSString stringWithFormat:@"%zd", concern.replyCount];
    _isMyFan = concern.isMyFan;
    _isMyFollow = concern.isMyFollow;
}

@end
