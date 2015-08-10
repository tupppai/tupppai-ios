//
//  ATOMRecommendUser.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/29/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ATOMRecommendUser : ATOMBaseModel
@property (nonatomic, assign) NSInteger askCount;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger fellowCount;
@property (nonatomic, assign) BOOL invited;
@property (nonatomic, assign) BOOL isFan;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *username;
@end


