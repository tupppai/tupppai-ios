//
//  ATOMUserProfileViewModel.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/15/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMUserProfileViewModel : NSObject

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *phone;

@end
