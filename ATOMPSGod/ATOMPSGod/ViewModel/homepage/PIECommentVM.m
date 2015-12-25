//
//  CommentVM.m
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIECommentVM.h"
#import "PIECommentEntity.h"
#import "PIEEntityCommentReply.h"
#import "PIECommentManager.h"
@implementation PIECommentVM

- (instancetype)init {
    self = [super init];
    if (self) {
        _likeNumber = @"0";
        _username   = @"-";
        _liked      = NO;
        _replyArray = [NSMutableArray array];
    }
    return self;
}

- (void)setViewModelData:(PIECommentEntity *)comment {
    _model = comment;
    _originText  = comment.content;
    _uid         = comment.uid;
    _username    = comment.nickname;
    _ID          = comment.cid;
    _avatar      = comment.avatar;
    _likeNumber  = [NSString stringWithFormat:@"%zd", comment.likeNumber];

    NSDate* date = [NSDate dateWithTimeIntervalSince1970:comment.commentTime];
    _time        = [Util formatPublishTime:date];
    
//    if (comment.atCommentArray && comment.atCommentArray.count > 0) {
//        NSString *content = comment.content;
//        for (NSDictionary* dic in comment.atCommentArray) {
//            PIEEntityCommentReply *reply = [MTLJSONAdapter modelOfClass:[PIEEntityCommentReply class] fromJSONDictionary:dic error:NULL];
//            if (reply) {
//                [_replyArray addObject:reply];
//            }
//            if (_replyArray.count>2) {
//                break;
//            }
//            content = [NSString stringWithFormat:@"%@//@%@:%@", content, reply.username, reply.text];
//        }
//        _text = content;
//    }
    if (comment.atCommentArray && comment.atCommentArray.count > 0) {
        NSDictionary* dic = [comment.atCommentArray objectAtIndex:0];
        PIEEntityCommentReply *reply = [MTLJSONAdapter modelOfClass:[PIEEntityCommentReply class] fromJSONDictionary:dic error:NULL];
        [_replyArray addObject:reply];
    }
    _text = comment.content;
    _liked = comment.liked;
}













@end
