//
//  ATOMCommentDetailViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMComment;

@interface ATOMCommentDetailViewModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *praiseNumber;
@property (nonatomic, assign) NSInteger comment_id;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) BOOL isPraise;

- (void)setViewModelData:(ATOMComment *)comment;
- (void)setDataWithAtModel:(ATOMCommentDetailViewModel *)viewModel andContent:(NSString *)content;
- (void)increasePraiseNumber;

@end
