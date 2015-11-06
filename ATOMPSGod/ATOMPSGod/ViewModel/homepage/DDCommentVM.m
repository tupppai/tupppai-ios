//
//  CommentVM.m
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDCommentVM.h"
#import "PIECommentEntity.h"
#import "PIEEntityCommentReply.h"
#import "DDCommentManager.h"
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

- (void)setViewModelData:(PIECommentEntity *)comment {
    _originText = comment.content;
    _uid = comment.uid;
    _username = comment.nickname;
    _ID = comment.cid;
    _likeNumber = [NSString stringWithFormat:@"%zd", comment.likeNumber];
    _avatar = comment.avatar;
    if (comment.atCommentArray && comment.atCommentArray.count > 0) {
        NSString *content = comment.content;
        for (NSDictionary* dic in comment.atCommentArray) {
            PIEEntityCommentReply *reply = [MTLJSONAdapter modelOfClass:[PIEEntityCommentReply class] fromJSONDictionary:dic error:NULL];
            if (reply) {
                [_replyArray addObject:reply];
            }
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
    _uid = [DDUserManager currentUser].uid;
    _username = [DDUserManager currentUser].username;
    _likeNumber = @"0";
    _avatar = [DDUserManager currentUser].avatar;
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
    
    DDCommentManager * showCommentDetail = [DDCommentManager new];
    [showCommentDetail toggleLike:param withID:self.ID withBlock:^(NSError *error) {
        if (!error) {
            NSInteger number = [_likeNumber integerValue]+one;
            [self setLikeNumber:[NSString stringWithFormat:@"%ld",(long)number]];
        }
    }];
    
}








@end
