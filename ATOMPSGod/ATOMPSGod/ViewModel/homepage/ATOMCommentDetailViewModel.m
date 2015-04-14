//
//  ATOMCommentDetailViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentDetailViewModel.h"
#import "ATOMComment.h"
#import "ATOMAtComment.h"

@implementation ATOMCommentDetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setViewModelData:(ATOMComment *)comment {
    _nickname = comment.nickname;
    
    _comment_id = comment.cid;
    _userSex = (comment.sex == 1) ? @"man" : @"woman";
    _praiseNumber = [NSString stringWithFormat:@"%d", (int)comment.praiseNumber];
    _avatar = comment.avatar;
    if (comment.atCommentArray && comment.atCommentArray.count > 0) {
        NSString *content = comment.content;
        for (ATOMAtComment *atComment in comment.atCommentArray) {
            content = [NSString stringWithFormat:@"%@//@%@:%@", content, atComment.nick, atComment.content];
        }
        _content = content;
    } else {
        _content = comment.content;
    }
    _isPraise = NO;
}

- (void)setDataWithAtModel:(ATOMCommentDetailViewModel *)viewModel andContent:(NSString *)content{
    _nickname = [ATOMCurrentUser currentUser].nickname;
    _userSex = ([ATOMCurrentUser currentUser].sex == 1) ? @"man" : @"woman";
    _praiseNumber = @"0";
    _avatar = [ATOMCurrentUser currentUser].avatar;
    if (viewModel) {
        _content = [NSString stringWithFormat:@"%@//@%@:%@", content, viewModel.nickname, viewModel.content];
    } else {
        _content = content;
    }
    _isPraise = NO;
}

- (void)increasePraiseNumber {
    _isPraise = YES;
    NSInteger praiseNumber = [_praiseNumber integerValue];
    praiseNumber++;
    _praiseNumber = [NSString stringWithFormat:@"%d", (int)praiseNumber];
}










@end
