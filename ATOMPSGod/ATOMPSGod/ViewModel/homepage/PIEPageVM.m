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

- (instancetype)initWithPageEntity:(PIEPageEntity *)entity {
    self = [self init];
    if (self) {
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

        NSDate *publishDate    = [NSDate dateWithTimeIntervalSince1970:entity.uploadTime];
        _publishTime           = [Util formatPublishTime:publishDate];
        _content               = entity.userDescription;
        _type                  = entity.type;
        _thumbEntityArray      = entity.thumbEntityArray;
        _hotCommentEntityArray = entity.hotCommentEntityArray;
        
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

-(void)collect {
    NSMutableDictionary *param = [NSMutableDictionary new];
    self.collected = !self.collected;
    if (self.collected) {
        //收藏
        [param setObject:@(1) forKey:@"status"];
    } else {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    }
    [DDCollectManager toggleCollect:param withPageType:self.type withID:self.ID withBlock:^(NSError *error) {
        if (!error) {
            if (  self.collected) {
                [Hud textWithLightBackground:@"收藏成功"];
            } else {
                [Hud textWithLightBackground:@"取消收藏成功"];
            }
        }   else {
            self.collected = !self.collected;
        }
    }];
}


@end
