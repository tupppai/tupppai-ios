//
//  ATOMDetailImageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMDetailImageViewModel.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMDetailImage.h"
#import "ATOMImageTipLabel.h"
#import "ATOMImageTipLabelViewModel.h"
#import "ATOMComment.h"
#import "ATOMCommentViewModel.h"

@implementation ATOMDetailImageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _commentArray = [NSMutableArray array];
        _labelArray = [NSMutableArray array];
    }
    return self;
}

- (void)setViewModelDataWithHomeImage:(ATOMHomePageViewModel *)homePageViewModel {
    _userName = homePageViewModel.userName;
    _userSex = homePageViewModel.userSex;
    _userImageURL = homePageViewModel.userImageURL;
    _avatarURL = homePageViewModel.avatarURL;
    _publishTime = homePageViewModel.publishTime;
    _praiseNumber = homePageViewModel.praiseNumber;
    _shareNumber = homePageViewModel.shareNumber;
    _commentNumber = homePageViewModel.commentNumber;
    _width = homePageViewModel.width;
    _height = homePageViewModel.height;
    _labelArray = [homePageViewModel.labelArray mutableCopy];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSString stringWithFormat:@"%@/HomePage", PATH_OF_DOCUMENT] stringByAppendingPathComponent:[NSString stringWithFormat:@"ATOMIMAGE-%d.jpg", (int)homePageViewModel.imageID]];
    BOOL flag;
    if ([fileManager fileExistsAtPath:path isDirectory:&flag]) {
        _image = [UIImage imageWithContentsOfFile:path];
    } else {
        NSLog(@"image not exist in %@", path);
    }
}

- (void)setViewModelDataWithDetailImage:(ATOMDetailImage *)detailImage {
    _userName = detailImage.nickname;
    _userSex = (detailImage.sex == 1) ? @"man" : @"woman";
    _userImageURL = detailImage.imageURL;
    _avatarURL = detailImage.avatar;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:detailImage.replyTime];
    _publishTime = [df stringFromDate:publishDate];
    _praiseNumber = [NSString stringWithFormat:@"%d",(int)detailImage.totalPraiseNumber];
    _shareNumber = [NSString stringWithFormat:@"%d",(int)detailImage.totalShareNumber];
    _commentNumber = [NSString stringWithFormat:@"%d",(int)detailImage.totalCommentNumber];
    _width = detailImage.imageWidth;
    _height = detailImage.imageHeight;
    for (ATOMComment *comment in detailImage.hotCommentArray) {
        ATOMCommentViewModel *model = [ATOMCommentViewModel new];
        [model setViewModelData:comment];
        [_commentArray addObject:model];
    }
}

























@end
