//
//  ATOMFollowPageViewModel.h.m
//  ATOMPSGod
//
//  Created by atom on 15/5/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMFollowPageViewModel.h"
#import "ATOMCommonImage.h"
#import "ATOMImageTipLabel.h"
#import "ATOMImageTipLabelViewModel.h"
#import "ATOMReplier.h"
#import "ATOMReplierViewModel.h"
#import "ATOMComment.h"
#import "ATOMCommentViewModel.h"
#import "ATOMBaseRequest.h"
@implementation ATOMFollowPageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageID = 0;
        _userID = [ATOMCurrentUser currentUser].uid;
        _userName = [ATOMCurrentUser currentUser].nickname;
        _userSex = ([ATOMCurrentUser currentUser].sex == 0) ? @"woman" : @"man";
        _avatarURL = [ATOMCurrentUser currentUser].avatar;
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
        NSDate *publishDate = [NSDate date];
        _publishTime = [df stringFromDate:publishDate];
        _likeNumber = @"0";
        _shareNumber = @"0";
        _commentNumber = @"0";
        _totalPSNumber = @"0";
        _collected = NO;
        _labelArray = [NSMutableArray new];
        _replierArray = [NSMutableArray new];
    }
    return self;
}

- (void)setViewModelData:(ATOMCommonImage *)commonImage {
    _collected = commonImage.collected;
    _imageID = commonImage.imageID;
    _askID = commonImage.askID;
    _type = commonImage.type;
    _userID = commonImage.uid;
    _userName = commonImage.nickname;
    _userSex = (commonImage.sex == 1) ? @"man" : @"woman";
    _pageImageURL = commonImage.imageURL;
    _avatarURL = commonImage.avatar;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:commonImage.uploadTime];
    _publishTime = [df stringFromDate:publishDate];
    _likeNumber = [NSString stringWithFormat:@"%d",(int)commonImage.totalPraiseNumber];
    _shareNumber = [NSString stringWithFormat:@"%d",(int)commonImage.totalShareNumber];
    _commentNumber = [NSString stringWithFormat:@"%d",(int)commonImage.totalCommentNumber];
    _totalPSNumber = [NSString stringWithFormat:@"%d",(int)commonImage.totalWorkNumber];
    _width = commonImage.imageWidth;
    _height = commonImage.imageHeight;
    _liked = commonImage.liked;
    for (ATOMImageTipLabel *tipLabel in commonImage.tipLabelArray) {
        ATOMImageTipLabelViewModel *model = [ATOMImageTipLabelViewModel new];
        [model setViewModelData:tipLabel];
        [_labelArray addObject:model];
    }
    for (ATOMReplier *replier in commonImage.replierArray) {
        ATOMReplierViewModel *model = [ATOMReplierViewModel new];
        [model setViewModelData:replier];
        [_replierArray addObject:model];
    }
    for (ATOMComment *comment in commonImage.hotCommentArray) {
        ATOMCommentViewModel *model = [ATOMCommentViewModel new];
        [model setViewModelData:comment];
        [_commentArray addObject:model];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSString stringWithFormat:@"%@/CommonImage", PATH_OF_DOCUMENT] stringByAppendingPathComponent:[NSString stringWithFormat:@"ATOMIMAGE-%d.jpg", (int)commonImage.imageID]];
    BOOL flag;
    if ([fileManager fileExistsAtPath:path isDirectory:&flag]) {
        _image = [UIImage imageWithContentsOfFile:path];
    } else {
        NSLog(@"image not exist in %@", path);
    }
}
- (void)toggleLike{
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSInteger status = _liked? 0:1;
    NSInteger one = _liked? -1:1;
    _liked = !_liked;
    [param setValue:@(status) forKey:@"status"];
    NSString* url = _type == 1? @"ask/upask": @"reply/upreply";
    ATOMBaseRequest* baseRequest = [ATOMBaseRequest new];
    [baseRequest toggleLike:param withUrl:url withID:_imageID withBlock:^(NSError *error) {
        if (!error) {
            NSLog(@"Server成功toggle like");
            NSInteger number = [_likeNumber integerValue]+one;
            [self setLikeNumber:[NSString stringWithFormat:@"%ld",(long)number]];            } else {
                NSLog(@"Server失败 toggle like");
            }
    }];
}
@end
