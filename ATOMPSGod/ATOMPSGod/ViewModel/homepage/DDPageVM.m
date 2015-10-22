//
//  ATOMAskPageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//





#import "ATOMImageTipLabel.h"
#import "DDTipLabelVM.h"
#import "ATOMReplier.h"
#import "ATOMReplierViewModel.h"
#import "DDBaseService.h"
#import "PIEEliteEntity.h"
#import "PIEImageEntity.h"


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
        _publishTime = @"刚刚";
        _likeCount = @"0";
        _shareCount = @"0";
        _commentCount = @"0";
        _totalPSNumber = @"0";
        _labelArray = [NSMutableArray new];
        _replierArray = [NSMutableArray new];
        _askImageModelArray = [NSMutableArray new];
        _liked = NO;
        _collected = NO;
    }
    return self;
}


- (void)setViewModelData:(PIEPageEntity *)entity {
    _ID = entity.ID;
    _askID =entity.askID;
    _userID = entity.uid;
    _username = entity.nickname;
    _imageURL = entity.imageURL;
    _avatarURL = entity.avatar;
    _liked = entity.liked;
    _collected = entity.collected;
    _followed = entity.followed;
    _imageWidth = entity.imageWidth;
    _imageHeight = entity.imageHeight;
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:entity.uploadTime];
    _publishTime = [Util formatPublishTime:publishDate];
    _content = entity.userDescription;
    _type = entity.type;
    _askImageModelArray = entity.askImageModelArray;

    if (entity.totalPraiseNumber>999999) {
        _likeCount = kfcMaxNumberString;
    } else {
        _likeCount = [NSString stringWithFormat:@"%zd",entity.totalPraiseNumber];
    }
    if (entity.totalShareNumber>999999) {
        _shareCount = kfcMaxNumberString;
    } else {
        _shareCount = [NSString stringWithFormat:@"%zd",entity.totalShareNumber];
    }
    if (entity.totalCommentNumber>999999) {
        _commentCount = kfcMaxNumberString;
    } else {
        _commentCount = [NSString stringWithFormat:@"%zd",entity.totalCommentNumber];
    }
    if (entity.totalWorkNumber>999999) {
        _totalPSNumber = kfcMaxNumberString;
    } else {
        _totalPSNumber = [NSString stringWithFormat:@"%zd",entity.totalWorkNumber];
    }
    if (entity.collectCount>999999) {
        _collectCount = kfcMaxNumberString;
    } else {
        _collectCount = [NSString stringWithFormat:@"%zd",entity.collectCount];
    }

}
- (instancetype)initWithPageEntity:(PIEPageEntity *)entity {
    self = [self init];
    if (self) {
        _ID = entity.ID;
        _askID =entity.askID;
        _userID = entity.uid;
        _username = entity.nickname;
        _imageURL = entity.imageURL;
        _avatarURL = entity.avatar;
        _liked = entity.liked;
        _collected = entity.collected;
        _imageWidth = entity.imageWidth;
        _imageHeight = entity.imageHeight;
        _followed = entity.followed;

        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:entity.uploadTime];
        _publishTime = [Util formatPublishTime:publishDate];
        _content = entity.userDescription;
        _type = entity.type;
        _askImageModelArray = entity.askImageModelArray;
        if (entity.totalPraiseNumber>999999) {
            _likeCount = kfcMaxNumberString;
        } else {
            _likeCount = [NSString stringWithFormat:@"%zd",entity.totalPraiseNumber];
        }
        if (entity.totalShareNumber>999999) {
            _shareCount = kfcMaxNumberString;
        } else {
            _shareCount = [NSString stringWithFormat:@"%zd",entity.totalShareNumber];
        }
        if (entity.totalCommentNumber>999999) {
            _commentCount = kfcMaxNumberString;
        } else {
            _commentCount = [NSString stringWithFormat:@"%zd",entity.totalCommentNumber];
        }
        if (entity.totalWorkNumber>999999) {
            _totalPSNumber = kfcMaxNumberString;
        } else {
            _totalPSNumber = [NSString stringWithFormat:@"%zd",entity.totalWorkNumber];
        }
        
        if (entity.collectCount>999999) {
            _collectCount = kfcMaxNumberString;
        } else {
            _collectCount = [NSString stringWithFormat:@"%zd",entity.collectCount];
        }

    }
    return self;
}

- (instancetype)initWithFollowEntity:(PIEEliteEntity *)entity {
    self = [self init];
    if (self) {
        _ID = entity.ID;
        _ID = entity.askID;
        _type = entity.type;
        _userID = entity.uid;
        _username = entity.nickname;
        _userSex = (entity.sex == 1) ? @"man" : @"woman";
        _imageURL = entity.imageURL;
        _avatarURL = entity.avatar;
        
        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:entity.uploadTime];
        _publishTime = [Util formatPublishTime:publishDate];
        _content = entity.userDescription;
        _likeCount = [NSString stringWithFormat:@"%zd",entity.totalPraiseNumber];
        _shareCount = [NSString stringWithFormat:@"%zd",entity.totalShareNumber];
        _commentCount = [NSString stringWithFormat:@"%zd",entity.totalCommentNumber];
        _totalPSNumber = [NSString stringWithFormat:@"%zd",entity.totalWorkNumber];
        _imageWidth = entity.imageWidth;
        _imageHeight = entity.imageHeight;
        _liked = entity.liked;
        _collected = entity.collected;
    }
    return self;
}


-(DDCommentPageVM*)generatepageDetailViewModel {
    DDCommentPageVM* commonViewModel = [DDCommentPageVM new];
    commonViewModel.pageID = _ID;
    commonViewModel.type = PIEPageTypeAsk;
    commonViewModel.pageImageURL = _imageURL;
    commonViewModel.avatarURL = _avatarURL;
    commonViewModel.likeNumber = _likeCount;
    commonViewModel.shareNumber = _shareCount;
    commonViewModel.commentNumber = _commentCount;
    commonViewModel.width = _imageWidth;
    commonViewModel.height = _imageHeight;
    commonViewModel.userName = _username;
    commonViewModel.uid = _userID;
    return commonViewModel;
}


- (void)toggleLike:(void (^)(BOOL success))block  {
    NSMutableDictionary *param = [NSMutableDictionary new];
    _liked = !_liked;
    if (_liked) {
        _likeCount = [NSString stringWithFormat:@"%zd", _likeCount.integerValue+1];
        [param setObject:@(1) forKey:@"status"];
    } else {
        _likeCount = [NSString stringWithFormat:@"%zd", _likeCount.integerValue-1];
        [param setObject:@(0) forKey:@"status"];
    }
    [DDService toggleLike:_liked ID:self.ID type:self.type  withBlock:^(BOOL success) {
        if (success) {
        } else {
            if (_liked) {
                _likeCount = [NSString stringWithFormat:@"%zd", _likeCount.integerValue-1];
            } else {
                _likeCount = [NSString stringWithFormat:@"%zd", _likeCount.integerValue+1];
            }
            _liked = !_liked;
        }
    }];

}



@end
