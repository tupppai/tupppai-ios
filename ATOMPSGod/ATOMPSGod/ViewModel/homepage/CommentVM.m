//
//  CommentVM.m
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "CommentVM.h"
#import "ATOMComment.h"
#import "ATOMAtComment.h"
#import "ATOMShowDetailOfComment.h"
@implementation CommentVM

- (instancetype)init {
    self = [super init];
    if (self) {
        _likeNumber = @"0";
        _username = @"visitor";
        _liked = NO;
    }
    return self;
}

- (void)setViewModelData:(ATOMComment *)comment {
    _uid = comment.uid;
    _username = comment.nickname;
    _ID = comment.cid;
//    _userSex = (comment.sex == 1) ? @"man" : @"woman";
    _likeNumber = [NSString stringWithFormat:@"%ld", (long)comment.likeNumber];
    _avatar = comment.avatar;
    if (comment.atCommentArray && comment.atCommentArray.count > 0) {
        NSString *content = comment.content;
        for (ATOMAtComment *atComment in comment.atCommentArray) {
            content = [NSString stringWithFormat:@"%@//@%@:%@", content, atComment.nick, atComment.content];
        }
        _text = content;
    } else {
        _text = comment.content;
    }
    _liked = comment.liked;
}

- (void)setDataWithAtModel:(CommentVM *)viewModel andContent:(NSString *)text{
    _uid = [ATOMCurrentUser currentUser].uid;
    _username = [ATOMCurrentUser currentUser].username;
//    _userSex = ([ATOMCurrentUser currentUser].sex == 1) ? @"man" : @"woman";
    _likeNumber = @"0";
    _avatar = [ATOMCurrentUser currentUser].avatar;
    if (viewModel) {
        _text = [NSString stringWithFormat:@"%@//@%@:%@", text, viewModel.username, viewModel.text];
    } else {
        _text = text;
    }
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
    [showCommentDetail toggleLike:param withID:self.ID withBlock:^(NSError *error) {
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
