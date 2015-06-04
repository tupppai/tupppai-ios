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
#import "ATOMReplier.h"
#import "ATOMReplierViewModel.h"

@interface ATOMHomePageViewModel ()



@end

@implementation ATOMHomePageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageID = 0;
        _userID = [ATOMCurrentUser currentUser].uid;
        _userName = [ATOMCurrentUser currentUser].nickname;
        _userSex = ([ATOMCurrentUser currentUser].sex == 0) ? @"woman" : @"man";
        _avatarURL = [ATOMCurrentUser currentUser].avatar;
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"MM月dd日 HH时mm分"];
        NSDate *publishDate = [NSDate date];
        _publishTime = [df stringFromDate:publishDate];
        _praiseNumber = @"0";
        _shareNumber = @"0";
        _commentNumber = @"0";
        _totalPSNumber = @"0";
        _labelArray = [NSMutableArray new];
        _replierArray = [NSMutableArray new];
    }
    return self;
}

- (void)setViewModelData:(ATOMHomeImage *)homeImage {
    _imageID = homeImage.imageID;
    _userID = homeImage.uid;
    _userName = homeImage.nickname;
    _userSex = (homeImage.sex == 1) ? @"man" : @"woman";
    _userImageURL = homeImage.imageURL;
    _avatarURL = homeImage.avatar;
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:homeImage.uploadTime];
    [self updatePublishTime:publishDate];
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
    for (ATOMReplier *replier in homeImage.replierArray) {
        ATOMReplierViewModel *model = [ATOMReplierViewModel new];
        [model setViewModelData:replier];
        [_replierArray addObject:model];
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


-(void)updatePublishTime:(NSDate*)date {
    
    NSDateFormatter *df = [NSDateFormatter new];
    NSTimeInterval timeInterval = - ([date timeIntervalSinceNow]);
    float dayDif = timeInterval/3600/24;
    int result = 0;
    if (dayDif > 7) {
        [df setDateFormat:@"MM月dd日 HH:mm"];
        _publishTime = [df stringFromDate:date];
    } else if (dayDif <= 7) {
        result = (int)roundf(dayDif);
        _publishTime = [NSString stringWithFormat:@"%d天前",result];
    } else if (dayDif < 1) {
        if (dayDif >= 1/24.0) {
            result = (int)roundf(dayDif*24.0);
            _publishTime = [NSString stringWithFormat:@"%d小时前",result];
        } else {
            result = (int)roundf(dayDif*24.0*60);
            _publishTime = [NSString stringWithFormat:@"%d分前",result];
        }
    }
    
//    NSLog(@"时间间隔%f,天%f",dif,dif2);
}



















@end
