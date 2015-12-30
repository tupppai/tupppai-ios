//
//  PIEUserViewModel.m
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEUserViewModel.h"
@implementation PIEUserViewModel
- (instancetype)initWithEntity:(PIEUserModel*)user
{
    self = [super init];
    if (self) {
        _model = user;
        _username         = user.nickname;
        _avatar           = user.avatar;
        _followCount  =  [NSString stringWithFormat:@"%zd",user.attentionNumber];
        _fansCount       = [NSString stringWithFormat:@"%zd",user.fansNumber];
        _likedCount       = [NSString stringWithFormat:@"%zd",user.likedCount];
        _askCount     = [NSString stringWithFormat:@"%zd",user.uploadNumber];
        _replyCount      = [NSString stringWithFormat:@"%zd",user.replyNumber];
        _replyPages          = [NSMutableArray array];
    }
    return self;
}
@end
