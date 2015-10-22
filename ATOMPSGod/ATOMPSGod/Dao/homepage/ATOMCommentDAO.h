//
//  ATOMCommentDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class PIECommentEntity;

@interface ATOMCommentDAO : ATOMBaseDAO

- (void)insertComment:(PIECommentEntity *)comment;
- (void)updateComment:(PIECommentEntity *)comment;
- (PIECommentEntity *)selectCommentByCommentID:(NSInteger)commentID;
- (NSMutableArray *)selectCommentsByDetailImageID:(NSInteger)detailImageID;
- (NSMutableArray *)selectCommentsByHomeImageID:(NSInteger)homeImageID;
- (BOOL)isExistComment:(PIECommentEntity *)comment;
- (void)clearCommentsByDetailImageID:(NSInteger)detailImageID;

@end
