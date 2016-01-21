//
//  ATOMAskPageViewModel.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDCollectManager.h"
#import "PIECommentManager.h"

@interface PIEPageVM ()

@end

@implementation PIEPageVM

- (instancetype)init {
    self = [super init];
    if (self) {
        _commentViewModelArray = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc {
    [_model removeObserver:self forKeyPath:@"loveStatus"];
    [_model removeObserver:self forKeyPath:@"totalPraiseNumber"];
    [_model removeObserver:self forKeyPath:@"followed"];
    [_model removeObserver:self forKeyPath:@"collected"];
    [_model removeObserver:self forKeyPath:@"collectCount"];
    [_model removeObserver:self forKeyPath:@"totalShareNumber"];
    [_model removeObserver:self forKeyPath:@"totalCommentNumber"];
}

- (instancetype)initWithPageEntity:(PIEPageModel *)entity {
    self = [self init];
    if (self) {
        _model = entity;
        
        [_model addObserver:self forKeyPath:@"loveStatus" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"totalPraiseNumber" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"followed" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"collected" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"collectCount" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"totalShareNumber" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"totalCommentNumber" options:NSKeyValueObservingOptionNew context:NULL];


        NSDate *publishDate    = [NSDate dateWithTimeIntervalSince1970:entity.uploadTime];
        _publishTime           = [Util formatPublishTime:publishDate];
        
        _likeCount = [self transfromRawToViewData:entity.totalPraiseNumber];
        _shareCount = [self transfromRawToViewData:entity.totalShareNumber];
        _commentCount = [self transfromRawToViewData:entity.totalCommentNumber];
        _replyCount = [self transfromRawToViewData:entity.totalWorkNumber];
        _collectCount = [self transfromRawToViewData:entity.collectCount];
    }
    return self;
}


- (instancetype)initWithUserModel:(PIEUserModel *)model {
    self = [self init];
    if (self) {
        _model = [PIEPageModel new];
        
        [_model addObserver:self forKeyPath:@"loveStatus" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"totalPraiseNumber" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"followed" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"collected" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"collectCount" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"totalShareNumber" options:NSKeyValueObservingOptionNew context:NULL];
        [_model addObserver:self forKeyPath:@"totalCommentNumber" options:NSKeyValueObservingOptionNew context:NULL];

        
        _model.uid = model.uid;
        _model.avatar = model.avatar;
        _model.nickname = model.nickname;
        _model.isV = model.isV;
        _model.totalPraiseNumber = model.likedCount;
        _likeCount = [self transfromRawToViewData:model.likedCount];
        _replyCount = [self transfromRawToViewData:model.uploadNumber];
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

- (void)collect:(void(^)(BOOL success))block
{
    
    self.model.collected = !self.model.collected;
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    if (!self.model.collected) {
        //取消收藏
        [param setObject:@(0) forKey:@"status"];
    } else {
        //反之，收藏
        [param setObject:@(1) forKey:@"status"];
    }
    
    [DDCollectManager
     toggleCollect:param
     withPageType:self.type
     withID:self.ID withBlock:^(NSError *error) {
         if (error == nil) {
             
             if (self.model.collected) {
                 [Hud text:@"收藏成功" backgroundColor:[UIColor colorWithHex:0x00000 andAlpha:0.3] margin:16 cornerRadius:8];
                 self.model.collectCount++;
             } else {
                 [Hud text:@"取消收藏成功" backgroundColor:[UIColor colorWithHex:0x00000 andAlpha:0.3] margin:16 cornerRadius:8];
                 self.model.collectCount--;
             }
             
             if (block) {
                 block(YES);
             }
         } else {
             
             self.model.collected = !self.model.collected;
             if (block) {
                 block(NO);
             }
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
-(NSString *)imageURL {
    return self.model.imageURL;
}
-(NSString *)avatarURL {
    return self.model.avatar;
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
-(NSMutableArray<PIECommentModel *> *)models_comment {
    return self.model.models_comment;
}
-(NSArray<PIECategoryModel *> *)models_catogory{
    return self.model.models_category;
}

-(PIEPageLoveStatus)loveStatus {
    return self.model.loveStatus;
}

-(NSString *)content {
    return self.model.userDescription;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loveStatus"]) {
        NSInteger newLoveStatus = [[change objectForKey:@"new"]integerValue];
        self.loveStatus = newLoveStatus;
    } else     if ([keyPath isEqualToString:@"totalPraiseNumber"]) {
        NSInteger newLikeCount = [[change objectForKey:@"new"]integerValue];
        self.likeCount = [self transfromRawToViewData:newLikeCount];
    }  else     if ([keyPath isEqualToString:@"collectCount"]) {
        NSInteger value = [[change objectForKey:@"new"]integerValue];
        self.collectCount = [self transfromRawToViewData:value];
    } else     if ([keyPath isEqualToString:@"collected"]) {
        BOOL value = [[change objectForKey:@"new"]boolValue];
        self.collected = value;
    } else     if ([keyPath isEqualToString:@"totalShareNumber"]) {
        NSInteger value = [[change objectForKey:@"new"]integerValue];
        self.shareCount = [self transfromRawToViewData:value];
    } else     if ([keyPath isEqualToString:@"totalCommentNumber"]) {
        NSInteger value = [[change objectForKey:@"new"]integerValue];
        self.commentCount = [self transfromRawToViewData:value];
    } else     if ([keyPath isEqualToString:@"followed"]) {
        BOOL value = [[change objectForKey:@"new"]boolValue];
        self.followed = value;
    }
}




- (NSString*)transfromRawToViewData:(NSInteger)count {
    NSString* countStringTransformed;
    if (count<=999999) {
        countStringTransformed    = [NSString stringWithFormat:@"%zd",count];
    } else {
        countStringTransformed    = @"1000k+";
    }
    return countStringTransformed;
}

@end
