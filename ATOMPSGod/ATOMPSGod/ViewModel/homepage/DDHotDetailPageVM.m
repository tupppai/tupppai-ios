//
//  ATOMHotDetailPageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDHotDetailPageVM.h"
#import "DDPageVM.h"
#import "ATOMDetailPage.h"
#import "ATOMImageTipLabel.h"
#import "DDTipLabelVM.h"
#import "ATOMComment.h"
#import "DDCommentVM.h"
#import "DDBaseService.h"
@implementation DDHotDetailPageVM

- (instancetype)init {
    self = [super init];
    if (self) {
        _commentArray = [NSMutableArray array];
        _labelArray = [NSMutableArray array];
        _collected = NO;
    }
    return self;
}

- (void)setViewModelDataWithHomeImage:(DDPageVM *)askPageViewModel {
    _type = 1;
    _ID = askPageViewModel.ID;
    _askID = askPageViewModel.ID;
    _uid = askPageViewModel.userID;
    _userName = askPageViewModel.username;
    _userSex = askPageViewModel.userSex;
    _userImageURL = askPageViewModel.imageURL;
    _avatarURL = askPageViewModel.avatarURL;
    _publishTime = askPageViewModel.publishTime;
    _likeNumber = askPageViewModel.likeCount;
    _shareNumber = askPageViewModel.shareCount;
    _commentNumber = askPageViewModel.commentNumber;
    _width = askPageViewModel.imageWidth;
    _height = askPageViewModel.imageHeight;
    _labelArray = [askPageViewModel.labelArray mutableCopy];
    _liked = askPageViewModel.liked;
    _collected = askPageViewModel.collected;
}

- (void)setViewModelDataWithDetailImage:(ATOMDetailPage *)detailImage {
    _collected = detailImage.collected;
    _type = detailImage.type;
    _ID = detailImage.detailID;
    _askID = detailImage.askID;
    _uid = detailImage.uid;
    _userName = detailImage.nickname;
    _userImageURL = detailImage.imageURL;
    _avatarURL = detailImage.avatar;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:detailImage.replyTime];
    _publishTime = [Util formatPublishTime:publishDate];
    _likeNumber = [NSString stringWithFormat:@"%d",(int)detailImage.totalPraiseNumber];
    _shareNumber = [NSString stringWithFormat:@"%d",(int)detailImage.totalShareNumber];
    _commentNumber = [NSString stringWithFormat:@"%d",(int)detailImage.totalCommentNumber];
    _liked = detailImage.liked;
    _width = detailImage.imageWidth;
    _height = detailImage.imageHeight;
    for (ATOMImageTipLabel *tipLabel in detailImage.tipLabelArray) {
        DDTipLabelVM *model = [DDTipLabelVM new];
        [model setViewModelData:tipLabel];
        [_labelArray addObject:model];
    }
    for (ATOMComment *comment in detailImage.hotCommentArray) {
        DDCommentVM *model = [DDCommentVM new];
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
    [DDBaseService toggleLike:param withPageType:_type withID:_ID withBlock:^(NSError *error) {
        if (!error) {
            NSInteger number = [_likeNumber integerValue]+one;
            [self setLikeNumber:[NSString stringWithFormat:@"%ld",(long)number]];
        }
    }];
}


@end
