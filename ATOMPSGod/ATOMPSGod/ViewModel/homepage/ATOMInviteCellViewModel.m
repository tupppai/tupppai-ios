//
//  ATOMInviteCellViewModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/29/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMInviteCellViewModel.h"

@implementation ATOMInviteCellViewModel
//@property (nonatomic, assign) NSInteger askCount;
//@property (nonatomic, copy) NSString *avatarUrl;
//@property (nonatomic, assign) NSInteger fansCount;
//@property (nonatomic, assign) NSInteger fellowCount;
//@property (nonatomic, assign) BOOL invited;
//@property (nonatomic, assign) BOOL isFan;
//@property (nonatomic, assign) BOOL isFellow;
//@property (nonatomic, copy) NSString *nickname;
//@property (nonatomic, assign) NSInteger replyCount;
//@property (nonatomic, assign) NSInteger sex;
//@property (nonatomic, assign) NSInteger uid;
//@property (nonatomic, copy) NSString *username;
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
}
@end
