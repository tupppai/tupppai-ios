//
//  ATOMOtherMessageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMOtherMessageViewModel.h"

@implementation ATOMOtherMessageViewModel

- (instancetype)initWithStyle:(ATOMOtherMessageViewModelType)type {
    self = [super init];
    if (self) {
        if (type == ATOMTopicReplyType) {
            [self setViewModelAsTopicReply];
        } else if (type == ATOMConcernType) {
            [self setViewModelAsConcern];
        } else if (type == ATOmInviteType){
            [self setViewModelAsInvite];
        }
    }
    return self;
}

- (void)setViewModelAsTopicReply {
    _userName = @"atom";
    _userSex = @"man";
    _contentContent = @"处理了你的图片";
    _contentTime = @"10月12号 11:00";
}

- (void)setViewModelAsConcern {
    _userName = @"波多野结衣";
    _userSex = @"woman";
    _contentContent = @"关注了你";
    _contentTime = @"10月12号 11:00";
}

- (void)setViewModelAsInvite {
    _userName = @"atom";
    _userSex = @"man";
    _contentContent = @"邀请你帮忙P图";
    _contentTime = @"10月12号 11:00";
}


































@end
