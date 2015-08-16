//
//  CommentVM.h
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMComment;

@interface CommentVM : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *likeNumber;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) BOOL liked;

- (void)setViewModelData:(ATOMComment *)comment;
- (void)setDataWithAtModel:(CommentVM *)viewModel andContent:(NSString *)content;
- (void)increasePraiseNumber;
- (void)toggleLike;

@end
