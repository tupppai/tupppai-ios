//
//  ATOMInviteCellViewModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/29/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMInviteCellViewModel.h"

@implementation ATOMInviteCellViewModel
- (void)setViewModelData:(ATOMRecommendUser *)recommendUser {
    if (recommendUser.fansCount<10000) {
        _fansDesc = [NSString stringWithFormat:@"%ld粉丝",(long)recommendUser.fansCount];
    } else {
        _fansDesc = [NSString stringWithFormat:@"%ld万粉丝",(long)recommendUser.fansCount/10000];
    }
    if (recommendUser.askCount<10000) {
        _askDesc = [NSString stringWithFormat:@"%ld求P",(long)recommendUser.askCount];
    } else {
        _askDesc = [NSString stringWithFormat:@"%ld万求P",(long)recommendUser.askCount/10000];
    }
    if (recommendUser.replyCount<10000) {
        _replyDesc = [NSString stringWithFormat:@"%ld作品",(long)recommendUser.replyCount];
    } else {
        _replyDesc = [NSString stringWithFormat:@"%ld万作品",(long)recommendUser.replyCount/10000];
    }
    _avatarUrl = recommendUser.avatarUrl;
    _nickname = recommendUser.nickname;
    _invited = recommendUser.invited;
    _uid = recommendUser.uid;
    //服务器是相对他，此viewModel是相对我。
    _isFan = recommendUser.isFollow;
    _isFollow = recommendUser.isFan;
}
@end
