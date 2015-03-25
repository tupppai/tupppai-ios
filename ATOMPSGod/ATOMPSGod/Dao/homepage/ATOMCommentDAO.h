//
//  ATOMCommentDAO.h
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseDAO.h"
@class ATOMComment;

@interface ATOMCommentDAO : ATOMBaseDAO

- (void)insertComment:(ATOMComment *)comment;
- (void)updateComment:(ATOMComment *)comment;
- (ATOMComment *)selectCommentByCommentID:(NSInteger)commentID;
- (NSMutableArray *)selectCommentsByDetailImageID:(NSInteger)detailImageID;
- (NSMutableArray *)selectCommentsByHomeImageID:(NSInteger)homeImageID;
- (BOOL)isExistComment:(ATOMComment *)comment;
- (void)clearCommentsByDetailImageID:(NSInteger)detailImageID;

@end
