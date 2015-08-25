//
//  CommentVM.m
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDCommentVM.h"
#import "ATOMComment.h"
#import "DDCommentReplyVM.h"
#import "ATOMShowDetailOfComment.h"
@implementation DDCommentVM

- (instancetype)init {
    self = [super init];
    if (self) {
        _likeNumber = @"0";
        _username = @"visitor";
        _liked = NO;
        _replyArray = [NSMutableArray array];
    }
    return self;
}

- (void)setViewModelData:(ATOMComment *)comment {
    _originText = comment.content;
    _uid = comment.uid;
    _username = comment.nickname;
    _ID = comment.cid;
    _likeNumber = [NSString stringWithFormat:@"%zd", comment.likeNumber];
    _avatar = comment.avatar;
    if (comment.atCommentArray && comment.atCommentArray.count > 0) {
        NSString *content = comment.content;
        for (NSDictionary* dic in comment.atCommentArray) {
            DDCommentReplyVM *reply = [MTLJSONAdapter modelOfClass:[DDCommentReplyVM class] fromJSONDictionary:dic error:NULL];
            [_replyArray addObject:reply];
            if (_replyArray.count>2) {
                break;
            }
            content = [NSString stringWithFormat:@"%@//@%@:%@", content, reply.username, reply.text];
        }
        _text = content;
    } else {
        _text = comment.content;
    }
    _liked = comment.liked;
}

- (void)setDataWithAtModel:(DDCommentVM *)viewModel andContent:(NSString *)text{
    _originText = viewModel.originText;
    _replyArray = viewModel.replyArray;
    _uid = [ATOMCurrentUser currentUser].uid;
    _username = [ATOMCurrentUser currentUser].username;
    _likeNumber = @"0";
    _avatar = [ATOMCurrentUser currentUser].avatar;
    if (viewModel) {
        _text = [NSString stringWithFormat:@"%@//@%@:%@", text, viewModel.username, viewModel.text];
    } else {
        _text = text;
    }
}



- (void)toggleLike {
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSInteger status = _liked? 0:1;
    NSInteger one = _liked? -1:1;
    _liked = !_liked;
    [param setValue:@(status) forKey:@"status"];
    
    ATOMShowDetailOfComment * showCommentDetail = [ATOMShowDetailOfComment new];
    [showCommentDetail toggleLike:param withID:self.ID withBlock:^(NSError *error) {
        if (!error) {
            NSInteger number = [_likeNumber integerValue]+one;
            [self setLikeNumber:[NSString stringWithFormat:@"%ld",(long)number]];
        }
    }];
    
}








@end
