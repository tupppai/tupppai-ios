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
        _ID = 0;
        _userID = [ATOMCurrentUser currentUser].uid;
        _userName = [ATOMCurrentUser currentUser].username;
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
    _ID = homeImage.askID;
    _userID = homeImage.uid;
    _userName = homeImage.nickname;
    _userImageURL = homeImage.imageURL;
    _avatarURL = homeImage.avatar;
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:homeImage.uploadTime];
    _publishTime = [Util formatPublishTime:publishDate];

    if (homeImage.totalPraiseNumber>999999) {
        _likeNumber = kfcMaxNumberString;
    } else {
        _likeNumber = [NSString stringWithFormat:@"%zd",homeImage.totalPraiseNumber];
    }
    if (homeImage.totalShareNumber>999999) {
        _shareNumber = kfcMaxNumberString;
    } else {
        _shareNumber = [NSString stringWithFormat:@"%zd",homeImage.totalShareNumber];
    }
    if (homeImage.totalCommentNumber>999999) {
        _commentNumber = kfcMaxNumberString;
    } else {
        _commentNumber = [NSString stringWithFormat:@"%zd",homeImage.totalCommentNumber];
    }
    if (homeImage.totalWorkNumber>999999) {
        _totalPSNumber = kfcMaxNumberString;
    } else {
        _totalPSNumber = [NSString stringWithFormat:@"%zd",homeImage.totalWorkNumber];
    }
    _liked = homeImage.liked;
    _collected = homeImage.collected;
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
}


-(kfcPageVM*)generatepageDetailViewModel {
    kfcPageVM* commonViewModel = [kfcPageVM new];
    commonViewModel.pageID = _ID;
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
    commonViewModel.uid = _userID;
    return commonViewModel;
}

-(void)setViewModelWithCommon:(kfcPageVM*)commonViewModel {
    _ID = commonViewModel.pageID;
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
    [baseRequest toggleLike:param withUrl:@"ask/upask" withID:_ID withBlock:^(NSError *error) {
        if (!error) {
            NSLog(@"Server成功toggle like");
            NSInteger number = [_likeNumber integerValue]+one;
            [self setLikeNumber:[NSString stringWithFormat:@"%ld",(long)number]];            } else {
                NSLog(@"Server失败 toggle like");
            }
    }];
}





@end
