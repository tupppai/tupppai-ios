//
//  ATOMHotDetailPageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHotDetailPageViewModel.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMDetailImage.h"
#import "ATOMImageTipLabel.h"
#import "ATOMImageTipLabelViewModel.h"
#import "ATOMComment.h"
#import "ATOMCommentViewModel.h"
#import "ATOMBaseRequest.h"
@implementation ATOMHotDetailPageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _commentArray = [NSMutableArray array];
        _labelArray = [NSMutableArray array];
        _collected = NO;
    }
    return self;
}

- (void)setViewModelDataWithHomeImage:(ATOMAskPageViewModel *)askPageViewModel {
    _type = 1;
    _ID = askPageViewModel.imageID;
    _uid = askPageViewModel.userID;
    _userName = askPageViewModel.userName;
    _userSex = askPageViewModel.userSex;
    _userImageURL = askPageViewModel.userImageURL;
    _avatarURL = askPageViewModel.avatarURL;
    _publishTime = askPageViewModel.publishTime;
    _likeNumber = askPageViewModel.likeNumber;
    _shareNumber = askPageViewModel.shareNumber;
    _commentNumber = askPageViewModel.commentNumber;
    _width = askPageViewModel.width;
    _height = askPageViewModel.height;
    _labelArray = [askPageViewModel.labelArray mutableCopy];
    _liked = askPageViewModel.liked;
    _collected = askPageViewModel.collected;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSString stringWithFormat:@"%@/HomePage", PATH_OF_DOCUMENT] stringByAppendingPathComponent:[NSString stringWithFormat:@"ATOMIMAGE-%d.jpg", (int)askPageViewModel.imageID]];
    BOOL flag;
    if ([fileManager fileExistsAtPath:path isDirectory:&flag]) {
        _image = [UIImage imageWithContentsOfFile:path];
    } else {
        NSLog(@"image not exist in %@", path);
    }
}

- (void)setViewModelDataWithDetailImage:(ATOMDetailImage *)detailImage {
    _collected = detailImage.collected;
    _type = detailImage.type;
    _ID = detailImage.detailID;
    _uid = detailImage.uid;
    _userName = detailImage.nickname;
    _userSex = (detailImage.sex == 1) ? @"man" : @"woman";
    _userImageURL = detailImage.imageURL;
    _avatarURL = detailImage.avatar;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:detailImage.replyTime];
    _publishTime = [df stringFromDate:publishDate];
    _likeNumber = [NSString stringWithFormat:@"%d",(int)detailImage.totalPraiseNumber];
    _shareNumber = [NSString stringWithFormat:@"%d",(int)detailImage.totalShareNumber];
    _commentNumber = [NSString stringWithFormat:@"%d",(int)detailImage.totalCommentNumber];
    _liked = detailImage.liked;
    _width = detailImage.imageWidth;
    _height = detailImage.imageHeight;
    for (ATOMComment *comment in detailImage.hotCommentArray) {
        ATOMCommentViewModel *model = [ATOMCommentViewModel new];
        [model setViewModelData:comment];
        [_commentArray addObject:model];
    }
}

- (void)toggleLike {
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSInteger status = _liked? 0:1;
    NSInteger one = _liked? -1:1;
    _liked = !_liked;
    [param setValue:@(status) forKey:@"status"];
    //每一页的第一张图是HomePage
    [ATOMBaseRequest toggleLike:param withPageType:_type withID:_ID withBlock:^(NSError *error) {
        if (!error) {
            NSLog(@"Server成功toggle like");
            NSInteger number = [_likeNumber integerValue]+one;
            [self setLikeNumber:[NSString stringWithFormat:@"%ld",(long)number]];            } else {
                NSLog(@"Server失败 toggle like");
            }
    }];
}


@end
