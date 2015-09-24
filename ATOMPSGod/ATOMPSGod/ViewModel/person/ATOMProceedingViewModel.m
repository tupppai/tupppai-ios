//
//  ATOMProceedingViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMProceedingViewModel.h"
#import "PIEPageEntity.h"

@implementation ATOMProceedingViewModel

- (void)setViewModelData:(PIEPageEntity *)homeImage {
    _ID = homeImage.ID;
    _userID = homeImage.uid;
    _userName = homeImage.nickname;
//    _userSex = (homeImage.sex == 1) ? @"man" :@"woman";
    _avatarURL = homeImage.avatar;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:homeImage.uploadTime];
    _publishTime = [Util formatPublishTime:publishDate];
    _imageURL = homeImage.imageURL;
    _width = homeImage.imageWidth;
    _height = homeImage.imageHeight;
}



@end
