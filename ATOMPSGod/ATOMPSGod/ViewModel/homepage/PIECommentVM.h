//
//  CommentVM.h
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PIECommentEntity;

@interface PIECommentVM : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *username;
/**
 *  username发布的最新评论，即text显示的评论数组里的第一个。
 */
@property (nonatomic, copy) NSString *originText;
/**
 *  所展示出来的评论内容
 */
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *likeNumber;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, strong) NSMutableArray* replyArray;

- (void)setViewModelData:(PIECommentEntity *)comment;
- (void)setDataWithAtModel:(PIECommentVM *)viewModel andContent:(NSString *)content;
- (void)toggleLike;

@end
