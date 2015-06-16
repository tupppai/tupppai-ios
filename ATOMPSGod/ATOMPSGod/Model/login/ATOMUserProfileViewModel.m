//
//  ATOMUserProfileViewModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/15/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMUserProfileViewModel.h"

@implementation ATOMUserProfileViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)setViewModel:(ATOMUserProfileViewModel*)viewModel {
    _nickName = viewModel.nickName;
    _city = viewModel.gender;
    _avatarURL = viewModel.avatarURL;
    _phone = viewModel.phone;
    _gender = viewModel.gender;
}

@end
