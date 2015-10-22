//
//  DDCommentVM.h
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PIECommentEntity;

@interface ATOMCommentViewModel : NSObject

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *content;
- (void)setViewModelData:(PIECommentEntity *)comment;

@end
