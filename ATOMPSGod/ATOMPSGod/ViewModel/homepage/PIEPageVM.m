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
    }
    return self;
}

-(void)dealloc {
    [_model removeObserver:self forKeyPath:@"loveStatus"];
    [_model removeObserver:self forKeyPath:@"totalPraiseNumber"];
    [_model removeObserver:self forKeyPath:@"followed"];

}
- (instancetype)initWithPageEntity:(PIEPageModel *)entity {
    self = [self init];
    if (self) {
        _model = entity;
        
        
        [_model addObserver:self forKeyPath:@"loveStatus" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"totalPraiseNumber" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"followed" options:NSKeyValueObservingOptionNew context:NULL];

        
        _imageURL    = entity.imageURL;
        _avatarURL   = entity.avatar;
        
        NSDate *publishDate    = [NSDate dateWithTimeIntervalSince1970:entity.uploadTime];
        _publishTime           = [Util formatPublishTime:publishDate];
        
        _likeCount = [self dataTransform:entity.totalPraiseNumber];
        _shareCount = [self dataTransform:entity.totalShareNumber];
        _commentCount = [self dataTransform:entity.totalCommentNumber];
        _replyCount = [self dataTransform:entity.totalWorkNumber];
        _collectCount = [self dataTransform:entity.collectCount];
    }
    return self;
}

- (void)increaseLoveStatus {
    if (self.model.loveStatus == PIEPageLoveStatus3) {
        [Hud text:@"你已经点满了超级赞,长按取消点赞" backgroundColor:[UIColor colorWithHex:0x000000 andAlpha:0.4] margin:14 cornerRadius:7];
    } else {
        self.model.loveStatus++;
        self.model.totalPraiseNumber++;
        [DDService loveReply:nil ID:self.ID withBlock:^(BOOL succeed) {
            if (!succeed) {
                [self decreaseLoveStatus];
            }
        }];
    }
    


}
- (void)decreaseLoveStatus {
    if (self.loveStatus == PIEPageLoveStatus0) {
        self.model.loveStatus = 3;
        self.model.totalPraiseNumber -= 3;
    } else {
        self.model.loveStatus--;
        self.model.totalPraiseNumber -= 1;
    }
}

- (void)revertStatus {
    
    NSInteger previousLoveCount = self.model.loveStatus;
    
    self.model.totalPraiseNumber -= self.model.loveStatus;
    self.model.loveStatus = 0;
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"0" forKey:@"status"];
    [DDService loveReply:param ID:self.ID withBlock:^(BOOL succeed) {
        if (!succeed) {
            self.model.loveStatus = previousLoveCount;
            self.model.totalPraiseNumber += previousLoveCount;
        }
    }];
}



/** Cell点击 － 点赞 */
-(void)love:(BOOL)revert {
    
    if (revert) {
        [self revertStatus];
    }
    
    else {
        [self increaseLoveStatus];
    }
}

-(void)follow {
    
    self.model.followed = !self.model.followed;

    NSMutableDictionary *param = [NSMutableDictionary new];
    NSNumber *followStatus = self.followed ? @1:@0;
    [param setObject:followStatus forKey:@"status"];
    [param setObject:@(self.userID) forKey:@"uid"];

    [DDService follow:param withBlock:^(BOOL success) {
        if (!success) {
            self.model.followed = !self.model.followed;
        }
    }];
}

#pragma -- convinience getters
-(NSInteger)ID {
    return self.model.ID;
}

-(NSInteger)askID {
    return self.model.askID;
}

-(NSInteger)userID {
    return self.model.uid;
}

-(NSString *)username {
    return self.model.nickname;
}

-(PIEPageType)type {
    return self.model.type;
}

-(CGFloat)imageRatio {
    return self.model.imageRatio;
}

-(BOOL)collected {
    return self.model.collected;
}
-(BOOL)followed {
    return self.model.followed;
}
-(BOOL)isMyFan {
    return self.model.isMyFan;
}
-(BOOL)isV {
    return self.model.isV;
}
-(NSArray<PIEModelImage *> *)models_image {
    return self.model.models_image;
}
-(NSArray<PIECommentModel *> *)models_comment {
    return self.model.models_comment;
}
-(NSArray<PIECategoryModel *> *)models_catogory{
    return self.model.models_category;
}

-(PIEPageLoveStatus)loveStatus {
    return self.model.loveStatus;
}

//declare as strong
-(NSString *)content {
    return self.model.userDescription;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loveStatus"]) {
        NSInteger newLoveStatus = [[change objectForKey:@"new"]integerValue];
        self.loveStatus = newLoveStatus;
    } else     if ([keyPath isEqualToString:@"totalPraiseNumber"]) {
        NSInteger newLikeCount = [[change objectForKey:@"new"]integerValue];
        self.likeCount = [self dataTransform:newLikeCount];
    } else     if ([keyPath isEqualToString:@"followed"]) {
        BOOL follow = [[change objectForKey:@"new"]boolValue];
        self.followed = follow;
    }
}


- (NSString*)dataTransform:(NSInteger)count {
    NSString* countStringTransformed;
    if (count<=999999) {
        countStringTransformed    = [NSString stringWithFormat:@"%zd",count];
    } else {
        countStringTransformed    = @"1000k+";
    }
    return countStringTransformed;
}

@end
