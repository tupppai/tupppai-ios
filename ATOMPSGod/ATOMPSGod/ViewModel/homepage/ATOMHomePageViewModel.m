//
//  ATOMHomePageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomePageViewModel.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"
#import "ATOMImageTipLabelViewModel.h"

@interface ATOMHomePageViewModel ()



@end

@implementation ATOMHomePageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _labelArray = [NSMutableArray new];
    }
    return self;
}

- (void)setViewModelData:(ATOMHomeImage *)homeImage {
    _imageID = homeImage.imageID;
    _userName = homeImage.nickname;
    _userSex = (homeImage.sex == 1) ? @"man" : @"woman";
    _userImageURL = homeImage.imageURL;
    _avatarURL = homeImage.avatar;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:homeImage.uploadTime];
    _publishTime = [df stringFromDate:publishDate];
    _praiseNumber = [NSString stringWithFormat:@"%d",(int)homeImage.totalPraiseNumber];
    _shareNumber = [NSString stringWithFormat:@"%d",(int)homeImage.totalShareNumber];
    _commentNumber = [NSString stringWithFormat:@"%d",(int)homeImage.totalCommentNumber];
    _totalPSNumber = [NSString stringWithFormat:@"%d",(int)homeImage.totalWorkNumber];
    _width = homeImage.imageWidth;
    _height = homeImage.imageHeight;
    for (ATOMImageTipLabel *tipLabel in homeImage.tipLabelArray) {
        ATOMImageTipLabelViewModel *model = [ATOMImageTipLabelViewModel new];
        [model setViewModelData:tipLabel];
        [_labelArray addObject:model];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSString stringWithFormat:@"%@/HomePage", PATH_OF_DOCUMENT] stringByAppendingPathComponent:[NSString stringWithFormat:@"ATOMIMAGE-%d.jpg", (int)homeImage.imageID]];
    BOOL flag;
    if ([fileManager fileExistsAtPath:path isDirectory:&flag]) {
        _image = [UIImage imageWithContentsOfFile:path];
    } else {
        NSLog(@"image not exist in %@", path);
    }
    
}























@end
