//
//  ATOMAskPageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDCollectManager.h"


@interface PIEPageVM ()

@end

@implementation PIEPageVM

- (instancetype)init {
    self = [super init];
    if (self) {
        _type         = 1;
        _ID           = 0;
        _publishTime  = @"-";
        _likeCount    = @"0";
        _shareCount   = @"0";
        _commentCount = @"0";
        _replyCount   = @"0";
        _liked        = NO;
        _collected    = NO;
    }
    return self;
}

- (instancetype)initWithPageEntity:(PIEPageModel *)entity {
    self = [self init];
    if (self) {
        
        _model = entity;
        _ID          = entity.ID;
        _askID       = entity.askID;
        _userID      = entity.uid;
        _username    = entity.nickname;
        _imageURL    = entity.imageURL;
        _avatarURL   = entity.avatar;
        _liked       = entity.liked;
        _collected   = entity.collected;
        _imageWidth  = entity.imageWidth;
        _imageHeight = entity.imageHeight;
        _followed    = entity.followed;
        _isMyFan        = entity.isMyFan;
        _models_catogory = entity.models_category;
        _content               = entity.userDescription;
        _type                  = entity.type;
        _models_image      = entity.models_image;
        _models_comment = entity.models_comment;
        _isV = entity.isV;
        _lovedCount = entity.lovedCount;
        
        
        NSDate *publishDate    = [NSDate dateWithTimeIntervalSince1970:entity.uploadTime];
        _publishTime           = [Util formatPublishTime:publishDate];

        if (entity.totalPraiseNumber>999999) {
            _likeCount    = kfcMaxNumberString;
        } else {
            _likeCount    = [NSString stringWithFormat:@"%zd",entity.totalPraiseNumber];
        }
        if (entity.totalShareNumber>999999) {
            _shareCount   = kfcMaxNumberString;
        } else {
            _shareCount   = [NSString stringWithFormat:@"%zd",entity.totalShareNumber];
        }
        if (entity.totalCommentNumber>999999) {
            _commentCount = kfcMaxNumberString;
        } else {
            _commentCount = [NSString stringWithFormat:@"%zd",entity.totalCommentNumber];
        }
        if (entity.totalWorkNumber>999999) {
            _replyCount   = kfcMaxNumberString;
        } else {
            _replyCount   = [NSString stringWithFormat:@"%zd",entity.totalWorkNumber];
        }

        if (entity.collectCount>999999) {
            _collectCount = kfcMaxNumberString;
        } else {
            _collectCount = [NSString stringWithFormat:@"%zd",entity.collectCount];
        }
    }
    return self;
}

- (void)increaseLoveStatus {
    if (_lovedCount && _lovedCount == 3) {
        self.lovedCount = 0;
        self.likeCount = [NSString stringWithFormat:@"%zd",[_likeCount integerValue] - 3];
    } else {
        self.lovedCount++;
        self.likeCount = [NSString stringWithFormat:@"%zd",[_likeCount integerValue] + 1];
    }
}

- (void)revertStatus {
    self.likeCount = [NSString stringWithFormat:@"%zd",[_likeCount integerValue] - _lovedCount];
    self.lovedCount = 0;
}

@end
