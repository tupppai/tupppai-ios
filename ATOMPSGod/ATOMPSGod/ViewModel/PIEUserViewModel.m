//
//  PIEUserViewModel.m
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEUserViewModel.h"
@implementation PIEUserViewModel
- (instancetype)initWithEntity:(PIEEntityUser*)user
{
    self = [super init];
    if (self) {
        _uid = user.uid;
        _mobile = user.mobile;
        _username = user.nickname;
        _sex = user.sex;
        _avatar = user.avatar;
        _locationID = user.locationID;
        _attentionNumber = user.attentionNumber;
        _fansNumber = user.fansNumber;
        _likeNumber = user.likeNumber;
        _uploadNumber = user.uploadNumber;
        _replyNumber = user.replyNumber;
        _proceedingNumber = user.proceedingNumber;
        _bindWechat = user.bindWechat;
        _bindWeibo = user.bindWeibo;
        _followed = user.isMyFollow;
        _replies = [NSMutableArray array];
    }
    return self;
}
@end
