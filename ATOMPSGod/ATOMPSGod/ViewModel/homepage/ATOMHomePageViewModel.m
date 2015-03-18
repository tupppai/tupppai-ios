//
//  ATOMHomePageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomePageViewModel.h"

@implementation ATOMHomePageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _userName = @"atom";
        _userSex = @"woman";
        _praiseNumber = @"1K";
        _shareNumber = @"1K";
        _commentNumber = @"1K";
        _totalPSNumber = @"100";
        _publishTime = @"3小时前";
    }
    return self;
}

- (CGSize)calculateImageViewSize {

    CGFloat maxWidth = SCREEN_WIDTH;
    CGFloat maxHeight = SCREEN_HEIGHT - NAV_HEIGHT - 76;
    CGFloat imageScale;
    CGSize size = CGSizeMake(_userImage.size.width, _userImage.size.height);
    if ((int)size.width <= maxWidth && (int)size.height <= maxHeight) {
        return size;
    }
    
    imageScale = maxWidth / size.width;
    size = CGSizeMake(size.width * imageScale, size.height * imageScale);
    if ((int)size.width <= maxWidth && (int)size.height <= maxHeight) {
        return size;
    }
    
    imageScale = maxHeight / size.height;
    size = CGSizeMake(size.width * imageScale, size.height * imageScale);
    return size;
    
}


@end
