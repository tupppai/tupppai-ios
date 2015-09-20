//
//  ATOMAskPageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDPageVM.h"

#import "ATOMAskPage.h"

#import "ATOMImageTipLabel.h"
#import "DDTipLabelVM.h"
#import "ATOMReplier.h"
#import "ATOMReplierViewModel.h"
#import "DDBaseService.h"
#import "PIEEliteEntity.h"


@interface DDPageVM ()

@end

@implementation DDPageVM

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = 1;
        _ID = 0;
        _userID = [DDUserManager currentUser].uid;
        _username = [DDUserManager currentUser].username;
        _avatarURL = [DDUserManager currentUser].avatar;
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"MM月dd日 HH时mm分"];
        NSDate *publishDate = [NSDate date];
        _publishTime = [df stringFromDate:publishDate];
        _likeCount = @"0";
        _shareCount = @"0";
        _commentNumber = @"0";
        _totalPSNumber = @"0";
        _labelArray = [NSMutableArray new];
        _replierArray = [NSMutableArray new];
        _liked = NO;
        _collected = NO;
    }
    return self;
}
//- (instancetype)initWithHomePage:(ATOMAskPage *)homeImage {
//    self = [super init];
//    if (self) {
//        _ID = homeImage.askID;
//        _userID = homeImage.uid;
//        _username = homeImage.nickname;
//        _imageURL = homeImage.imageURL;
//        _avatarURL = homeImage.avatar;
//        _liked = homeImage.liked;
//        _collected = homeImage.collected;
//        _width = homeImage.imageWidth;
//        _height = homeImage.imageHeight;
//        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:homeImage.uploadTime];
//        _publishTime = [Util formatPublishTime:publishDate];
//        
//        if (homeImage.totalPraiseNumber>999999) {
//            _likeCount = kfcMaxNumberString;
//        } else {
//            _likeCount = [NSString stringWithFormat:@"%zd",homeImage.totalPraiseNumber];
//        }
//        if (homeImage.totalShareNumber>999999) {
//            _shareCount = kfcMaxNumberString;
//        } else {
//            _shareCount = [NSString stringWithFormat:@"%zd",homeImage.totalShareNumber];
//        }
//        if (homeImage.totalCommentNumber>999999) {
//            _commentNumber = kfcMaxNumberString;
//        } else {
//            _commentNumber = [NSString stringWithFormat:@"%zd",homeImage.totalCommentNumber];
//        }
//        if (homeImage.totalWorkNumber>999999) {
//            _totalPSNumber = kfcMaxNumberString;
//        } else {
//            _totalPSNumber = [NSString stringWithFormat:@"%zd",homeImage.totalWorkNumber];
//        }
//        
//        for (ATOMImageTipLabel *tipLabel in homeImage.tipLabelArray) {
//            DDTipLabelVM *model = [DDTipLabelVM new];
//            [model setViewModelData:tipLabel];
//            [_labelArray addObject:model];
//        }
//        for (ATOMReplier *replier in homeImage.replierArray) {
//            ATOMReplierViewModel *model = [ATOMReplierViewModel new];
//            [model setViewModelData:replier];
//            [_replierArray addObject:model];
//        }
//    }
//    return self;
//}
//- (instancetype)initWithDetailPage:(ATOMDetailPage*)page {
//    self = [super init];
//    if (self) {
//        _collected = page.collected;
//        _type = page.type;
//        _ID = page.detailID;
//        _userID = page.uid;
//        _username = page.nickname;
//        _imageURL = page.imageURL;
//        _avatarURL = page.avatar;
//        _likeCount = [NSString stringWithFormat:@"%d",(int)page.totalPraiseNumber];
//        _shareCount = [NSString stringWithFormat:@"%d",(int)page.totalShareNumber];
//        _commentNumber = [NSString stringWithFormat:@"%d",(int)page.totalCommentNumber];
//        _liked = page.liked;
//        _width = page.imageWidth;
//        _height = page.imageHeight;
//        
//        NSDateFormatter *df = [NSDateFormatter new];
//        [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
//        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:page.replyTime];
//        _publishTime = [Util formatPublishTime:publishDate];
//    }
//    return self;
//}

- (void)setViewModelData:(ATOMAskPage *)homeImage {
    _ID = homeImage.askID;
    _userID = homeImage.uid;
    _username = homeImage.nickname;
    _imageURL = homeImage.imageURL;
    _avatarURL = homeImage.avatar;
    _liked = homeImage.liked;
    _collected = homeImage.collected;
    _imageWidth = homeImage.imageWidth;
    _imageHeight = homeImage.imageHeight;
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:homeImage.uploadTime];
    _publishTime = [Util formatPublishTime:publishDate];

    if (homeImage.totalPraiseNumber>999999) {
        _likeCount = kfcMaxNumberString;
    } else {
        _likeCount = [NSString stringWithFormat:@"%zd",homeImage.totalPraiseNumber];
    }
    if (homeImage.totalShareNumber>999999) {
        _shareCount = kfcMaxNumberString;
    } else {
        _shareCount = [NSString stringWithFormat:@"%zd",homeImage.totalShareNumber];
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

    for (ATOMImageTipLabel *tipLabel in homeImage.tipLabelArray) {
        DDTipLabelVM *model = [DDTipLabelVM new];
        [model setViewModelData:tipLabel];
        [_labelArray addObject:model];
    }
    for (ATOMReplier *replier in homeImage.replierArray) {
        ATOMReplierViewModel *model = [ATOMReplierViewModel new];
        [model setViewModelData:replier];
        [_replierArray addObject:model];
    }
}


- (instancetype)initWithFollowEntity:(PIEEliteEntity *)entity {
    self = [self init];
    if (self) {
        _ID = entity.imageID;
        _ID = entity.askID;
        _type = entity.type;
        _userID = entity.uid;
        _username = entity.nickname;
        _userSex = (entity.sex == 1) ? @"man" : @"woman";
        _imageURL = entity.imageURL;
        _avatarURL = entity.avatar;
        
        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:entity.uploadTime];
        _publishTime = [Util formatPublishTime:publishDate];
        
        _likeCount = [NSString stringWithFormat:@"%d",(int)entity.totalPraiseNumber];
        _shareCount = [NSString stringWithFormat:@"%d",(int)entity.totalShareNumber];
        _commentNumber = [NSString stringWithFormat:@"%d",(int)entity.totalCommentNumber];
        _totalPSNumber = [NSString stringWithFormat:@"%d",(int)entity.totalWorkNumber];
        _imageWidth = entity.imageWidth;
        _imageHeight = entity.imageHeight;
        _liked = entity.liked;
        _collected = entity.collected;
    }
    return self;
}

- (void)setViewModelDataWithDetailPage:(ATOMDetailPage *)page {
    _collected = page.collected;
    _type = page.type;
    _ID = page.detailID;
    _userID = page.uid;
    _username = page.nickname;
    _imageURL = page.imageURL;
    _avatarURL = page.avatar;
    _likeCount = [NSString stringWithFormat:@"%d",(int)page.totalPraiseNumber];
    _shareCount = [NSString stringWithFormat:@"%d",(int)page.totalShareNumber];
    _commentNumber = [NSString stringWithFormat:@"%d",(int)page.totalCommentNumber];
    _liked = page.liked;
    _imageWidth = page.imageWidth;
    _imageHeight = page.imageHeight;
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:page.replyTime];
    _publishTime = [Util formatPublishTime:publishDate];

//    NSDateFormatter *df = [NSDateFormatter new];
//    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
//    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:page.replyTime];
//    _publishTime = [Util formatPublishTime:publishDate];
}


-(DDCommentPageVM*)generatepageDetailViewModel {
    DDCommentPageVM* commonViewModel = [DDCommentPageVM new];
    commonViewModel.pageID = _ID;
    commonViewModel.type = ATOMPageTypeAsk;
    commonViewModel.pageImageURL = _imageURL;
    commonViewModel.avatarURL = _avatarURL;
    commonViewModel.likeNumber = _likeCount;
    commonViewModel.shareNumber = _shareCount;
    commonViewModel.commentNumber = _commentNumber;
    commonViewModel.width = _imageWidth;
    commonViewModel.height = _imageHeight;
    commonViewModel.userName = _username;
    commonViewModel.uid = _userID;
    return commonViewModel;
}

-(void)setViewModelWithCommon:(DDCommentPageVM*)commonViewModel {
    _ID = commonViewModel.pageID;
    _imageURL = commonViewModel.pageImageURL;
    _avatarURL = commonViewModel.avatarURL;
    _likeCount = commonViewModel.likeNumber;
    _shareCount = commonViewModel.shareNumber;
    _commentNumber = commonViewModel.commentNumber;
    _imageWidth = commonViewModel.width;
    _imageHeight = commonViewModel.height;
    _username = commonViewModel.userName;
}

- (void)toggleLike {
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSInteger status = _liked? 0:1;
    NSInteger one = _liked? -1:1;
    _liked = !_liked;
    [param setValue:@(status) forKey:@"status"];
    [DDBaseService toggleLike:param withPageType:ATOMPageTypeAsk withID:_ID withBlock:^(NSError *error) {
        if (!error) {
            NSInteger number = [_likeCount integerValue]+one;
            [self setLikeCount:[NSString stringWithFormat:@"%ld",(long)number]];
        }
    }];
}



@end
