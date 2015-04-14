//
//  ATOMFansViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMFans;

@interface ATOMFansViewModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *totalFansNumber;
@property (nonatomic, copy) NSString *totalAskNumber;
@property (nonatomic, copy) NSString *totalReplyNumber;
@property (nonatomic, assign) BOOL isFellow;

- (void)setViewModelData:(ATOMFans *)fans;

@end
