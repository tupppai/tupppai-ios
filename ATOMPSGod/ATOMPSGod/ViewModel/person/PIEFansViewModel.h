//
//  ATOMFansViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PIEEntityFan;

@interface PIEFansViewModel : NSObject

@property (nonatomic, strong) PIEEntityFan *model;

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy  ) NSString  *userName;
@property (nonatomic, copy  ) NSString  *userSex;
@property (nonatomic, copy  ) NSString  *avatarURL;
@property (nonatomic, copy  ) NSString  *fansCount;
@property (nonatomic, copy  ) NSString  *askCount;
@property (nonatomic, copy  ) NSString  *replyCount;
@property (nonatomic, assign) BOOL      isFollow;
@property (nonatomic, assign) BOOL      isMyFan;

//@property (nonatomic, assign) NSInteger followStatus;

- (void)setViewModelData:(PIEEntityFan *)fans;

@end
