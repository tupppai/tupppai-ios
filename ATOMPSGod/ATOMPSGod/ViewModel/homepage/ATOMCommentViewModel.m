//
//  DDCommentVM.m
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentViewModel.h"
#import "PIECommentEntity.h"

@implementation ATOMCommentViewModel

- (void)setViewModelData:(PIECommentEntity *)comment {
    _nickname = comment.nickname;
    _content = comment.content;
}

@end
