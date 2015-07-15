//
//  ATOMReplierViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/19.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMReplierViewModel.h"
#import "ATOMReplier.h"

@implementation ATOMReplierViewModel

- (void)setViewModelData:(ATOMReplier *)replier {
    _avatarURL = replier.avatar;
    _uid = replier.uid;
}

@end
