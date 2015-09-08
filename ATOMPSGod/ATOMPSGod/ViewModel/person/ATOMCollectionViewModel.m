//
//  ATOMCollectionViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCollectionViewModel.h"
#import "ATOMAskPage.h"

@implementation ATOMCollectionViewModel

- (void)setViewModelData:(ATOMAskPage *)homeImage {
    _type = homeImage.type;
    _uid = homeImage.uid;
    _userName = homeImage.nickname;
//    _userSex = (homeImage.sex == 1) ? @"man" : @"woman";
    _avatarURL = homeImage.avatar;
    _imageURL = homeImage.imageURL;
    _totalPSNumber = homeImage.totalWorkNumber;
}

@end
