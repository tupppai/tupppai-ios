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
#import "ATOMShowDetailOfComment.h"
@implementation ATOMCommentDetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setViewModelData:(ATOMComment *)comment {
    _uid = comment.uid;
    _nickname = comment.nickname;
    _comment_id = comment.cid;
    _userSex = (comment.sex == 1) ? @"man" : @"woman";
    _likeNumber = [NSString stringWithFormat:@"%ld", (long)comment.praiseNumber];
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
    _liked = comment.liked;
}

- (void)setDataWithAtModel:(ATOMCommentDetailViewModel *)viewModel andContent:(NSString *)content{
    _uid = [ATOMCurrentUser currentUser].uid;
    _nickname = [ATOMCurrentUser currentUser].nickname;
    _userSex = ([ATOMCurrentUser currentUser].sex == 1) ? @"man" : @"woman";
    _likeNumber = @"0";
    _avatar = [ATOMCurrentUser currentUser].avatar;
    if (viewModel) {
        _content = [NSString stringWithFormat:@"%@//@%@:%@", content, viewModel.nickname, viewModel.content];
    } else {
        _content = content;
    }
//    _liked = NO;
}

- (void)increasePraiseNumber {
    _liked = YES;
    NSInteger likeNumber = [_likeNumber integerValue];
    likeNumber++;
    _likeNumber = [NSString stringWithFormat:@"%d", (int)likeNumber];
}

- (void)toggleLike {
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSInteger status = _liked? 0:1;
    NSInteger one = _liked? -1:1;
    _liked = !_liked;
    [param setValue:@(status) forKey:@"status"];
    
    ATOMShowDetailOfComment * showCommentDetail = [ATOMShowDetailOfComment new];
    [showCommentDetail toggleLike:param withID:self.comment_id withBlock:^(NSError *error) {
        if (!error) {
            NSLog(@"Server成功toggle like");
            NSInteger number = [_likeNumber integerValue]+one;
            [self setLikeNumber:[NSString stringWithFormat:@"%ld",(long)number]];
        } else {
            NSLog(@"Server失败 toggle like");
        }
        
    }];
    
}








@end
