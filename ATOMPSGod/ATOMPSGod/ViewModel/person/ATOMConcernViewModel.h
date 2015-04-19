//
//  ATOMConcernViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/4/15.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMConcern;

@interface ATOMConcernViewModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *totalFansNumber;
@property (nonatomic, copy) NSString *totalAskNumber;
@property (nonatomic, copy) NSString *totalReplyNumber;
@property (nonatomic, assign) NSInteger concernStatus;

- (void)setViewModelData:(ATOMConcern *)concern;

@end
