//
//  ATOMAskPageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAskPageViewModel.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"
#import "ATOMImageTipLabelViewModel.h"
#import "ATOMReplier.h"
#import "ATOMReplierViewModel.h"
#import "ATOMBaseRequest.h"
@interface ATOMAskPageViewModel ()


@end

@implementation ATOMAskPageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = 1;
        _imageID = 0;
        _userID = [ATOMCurrentUser currentUser].uid;
        _userName = [ATOMCurrentUser currentUser].nickname;
        _userSex = ([ATOMCurrentUser currentUser].sex == 0) ? @"woman" : @"man";
        _avatarURL = [ATOMCurrentUser currentUser].avatar;
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"MM月dd日 HH时mm分"];
        NSDate *publishDate = [NSDate date];
        _publishTime = [df stringFromDate:publishDate];
        _likeNumber = @"0";
        _shareNumber = @"0";
        _commentNumber = @"0";
        _totalPSNumber = @"0";
        _labelArray = [NSMutableArray new];
        _replierArray = [NSMutableArray new];
        _liked = NO;
        _collected = NO;
    }
    return self;
}

- (void)setViewModelData:(ATOMHomeImage *)homeImage {
//    _imageID = homeImage.imageID;
    _imageID = homeImage.askID;
    _askID = homeImage.askID;
    _userID = homeImage.uid;
    _userName = homeImage.nickname;
    _userSex = (homeImage.sex == 1) ? @"man" : @"woman";
    _userImageURL = homeImage.imageURL;
    _avatarURL = homeImage.avatar;
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:homeImage.uploadTime];
    [self updatePublishTime:publishDate];
    _likeNumber = [NSString stringWithFormat:@"%d",(int)homeImage.totalPraiseNumber];
    _liked = homeImage.liked;
    _collected = homeImage.collected;
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
    } else if (dayDif >= 1) {
        result = (int)roundf(dayDif);
        _publishTime = [NSString stringWithFormat:@"%d天前",result];
    } else if (dayDif >= 1/24.0) {
        result = (int)roundf(dayDif*24.0);
        _publishTime = [NSString stringWithFormat:@"%d小时前",result];
    } else {
            result = (int)roundf(dayDif*24.0*60);
            _publishTime = [NSString stringWithFormat:@"%d分钟前",result];
        }
}

-(PWPageDetailViewModel*)generatepageDetailViewModel {
    PWPageDetailViewModel* commonViewModel = [PWPageDetailViewModel new];
    commonViewModel.pageID = _imageID;
    commonViewModel.type = ATOMPageTypeAsk;
    commonViewModel.pageImageURL = _userImageURL;
    commonViewModel.pageImage = _image;
    commonViewModel.avatarURL = _avatarURL;
    commonViewModel.likeNumber = _likeNumber;
    commonViewModel.shareNumber = _shareNumber;
    commonViewModel.commentNumber = _commentNumber;
    commonViewModel.width = _width;
    commonViewModel.height = _height;
    commonViewModel.userName = _userName;
    return commonViewModel;
}

-(void)setViewModelWithCommon:(PWPageDetailViewModel*)commonViewModel {
    _imageID = commonViewModel.pageID;
    _userImageURL = commonViewModel.pageImageURL;
    _image = commonViewModel.pageImage;
    _avatarURL = commonViewModel.avatarURL;
    _likeNumber = commonViewModel.likeNumber;
    _shareNumber = commonViewModel.shareNumber;
    _commentNumber = commonViewModel.commentNumber;
    _width = commonViewModel.width;
    _height = commonViewModel.height;
    _userName = commonViewModel.userName;
}

- (void)toggleLike {
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSInteger status = _liked? 0:1;
    NSInteger one = _liked? -1:1;
    _liked = !_liked;
    [param setValue:@(status) forKey:@"status"];
    ATOMBaseRequest* baseRequest = [ATOMBaseRequest new];
    [baseRequest toggleLike:param withUrl:@"ask/upask" withID:_imageID withBlock:^(NSError *error) {
        if (!error) {
            NSLog(@"Server成功toggle like");
            NSInteger number = [_likeNumber integerValue]+one;
            [self setLikeNumber:[NSString stringWithFormat:@"%ld",(long)number]];            } else {
                NSLog(@"Server失败 toggle like");
            }
    }];
}





@end
