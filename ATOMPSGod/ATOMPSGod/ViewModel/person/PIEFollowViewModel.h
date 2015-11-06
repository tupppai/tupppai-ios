//
//  ATOMConcernViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PIEEntityFollow;

@interface PIEFollowViewModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *fansCount;
@property (nonatomic, copy) NSString *askCount;
@property (nonatomic, copy) NSString *replyCount;
@property (nonatomic, assign) NSInteger concernStatus;

- (void)setViewModelData:(PIEEntityFollow *)concern;

@end
