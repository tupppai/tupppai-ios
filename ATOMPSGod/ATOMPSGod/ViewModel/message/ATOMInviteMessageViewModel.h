//
//  ATOMInviteMessageViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/4/14.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMInviteMessage;
@class ATOMHomePageViewModel;

@interface ATOMInviteMessageViewModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, strong) ATOMHomePageViewModel *homepageViewModel;

- (void)setViewModelData:(ATOMInviteMessage *)inviteMessage;

@end
