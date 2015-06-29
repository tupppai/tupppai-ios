//
//  ATOMInviteCellViewModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/29/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATOMRecommendUser.h"
@interface ATOMInviteCellViewModel : NSObject
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString* askDesc;
@property (nonatomic, copy) NSString* fansDesc;
@property (nonatomic, copy) NSString* fellowDesc;
@property (nonatomic, copy) NSString* replyDesc;
@property (nonatomic, assign) BOOL invited;
@property (nonatomic, assign) BOOL isFan;
@property (nonatomic, assign) BOOL isFellow;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *username;

- (void)setViewModelData:(ATOMRecommendUser *)recommendUser;

@end
