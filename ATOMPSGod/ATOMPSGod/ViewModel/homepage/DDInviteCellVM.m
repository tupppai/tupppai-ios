//
//  ATOMInviteCellViewModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/29/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "DDInviteCellVM.h"

@implementation DDInviteCellVM
- (void)setViewModelData:(DDFollow *)concern {
    if (concern.fansCount<10000) {
        _fansDesc = [NSString stringWithFormat:@"%zd粉丝",concern.fansCount];
    } else {
        _fansDesc = [NSString stringWithFormat:@"%zd万粉丝",concern.fansCount/10000];
    }
    if (concern.askCount<10000) {
        _askDesc = [NSString stringWithFormat:@"%zd求P",concern.askCount];
    } else {
        _askDesc = [NSString stringWithFormat:@"%zd万求P",concern.askCount/10000];
    }
    if (concern.replyCount<10000) {
        _replyDesc = [NSString stringWithFormat:@"%zd作品",concern.replyCount];
    } else {
        _replyDesc = [NSString stringWithFormat:@"%zd万作品",concern.replyCount/10000];
    }
    _avatarUrl = concern.avatar;
    _nickname = concern.nickname;
    _invited = concern.invited;
    _uid = concern.uid;
    _isFan = concern.isMyFan;
    _isFollow = concern.isMyFollow;
}
@end
