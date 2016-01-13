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
        _type         = PIEPageTypeAsk;
        _ID           = 0;
        _askID        = 0;
        _publishTime  = @"0";
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
        if (![self.likeCount isEqualToString:kfcMaxNumberString]) {
            self.likeCount = [NSString stringWithFormat:@"%zd",[_likeCount integerValue] - 3];
        }
    } else {
        self.lovedCount++;
        if (![self.likeCount isEqualToString:kfcMaxNumberString]) {
            self.likeCount = [NSString stringWithFormat:@"%zd",[_likeCount integerValue] + 1];
        }
    }
}
- (void)decreaseLoveStatus {
    if (_lovedCount && _lovedCount == 0) {
        self.lovedCount = 3;
        if (![self.likeCount isEqualToString:kfcMaxNumberString]) {
            self.likeCount = [NSString stringWithFormat:@"%zd",[_likeCount integerValue] + 3];
        }
    } else {
        self.lovedCount--;
        if (![self.likeCount isEqualToString:kfcMaxNumberString]) {
            self.likeCount = [NSString stringWithFormat:@"%zd",[_likeCount integerValue] - 1];
        }
    }
}

- (void)revertStatus {
    if (![self.likeCount isEqualToString:kfcMaxNumberString]) {
        self.likeCount = [NSString stringWithFormat:@"%zd",[_likeCount integerValue] - self.lovedCount];
    }
    self.lovedCount = 0;
}



/** Cell点击 － 点赞 */
-(void)love:(BOOL)revert {
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    if (revert || self.lovedCount == 3) {
        [param setObject:@"0" forKey:@"status"];
    }
    
    if (revert) {
        [self revertStatus];
    } else {
        [self increaseLoveStatus];
    }
    
    [DDService loveReply:param ID:self.ID withBlock:^(BOOL succeed) {
        if (!succeed) {
            [self decreaseLoveStatus];
        }
    }];
}
-(void)follow {
    
    self.followed = !self.followed;

    NSMutableDictionary *param = [NSMutableDictionary new];
    NSNumber *followStatus = self.followed ? @1:@0;
    [param setObject:followStatus forKey:@"status"];
    [param setObject:@(self.userID) forKey:@"uid"];

    [DDService follow:param withBlock:^(BOOL success) {
        if (success) {
            if (self.followed) {
                [Hud text:@"关注成功" backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.3] margin:15 cornerRadius:7];
            } else {
                [Hud text:@"已取消关注" backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.3] margin:15 cornerRadius:7];
            }
        } else {
            self.followed = !self.followed;
        }
    }];
    
}


@end
