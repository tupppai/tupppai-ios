//
//  ATOMAskPageViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIEPageEntity.h"

@interface PIEPageVM : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger askID;
@property (nonatomic, assign) PIEPageType type;

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;


@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL collected;

@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *likeCount;
@property (nonatomic, copy) NSString *shareCount;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *replyCount;
@property (nonatomic, copy) NSString *collectCount;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageURL;

@property (nonatomic, strong) UIImage *image;
//求p 的图片对象数组
@property (nonatomic, strong) NSArray *models_ask;
@property (nonatomic, strong) NSArray *models_comment;
@property (nonatomic, strong) NSArray *models_catogory;

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, assign) BOOL followed;
@property (nonatomic, assign) BOOL isMyFan;
@property (nonatomic, assign) BOOL isV;
@property (nonatomic, assign) NSInteger lovedCount;

- (instancetype)initWithPageEntity:(PIEPageEntity *)entity ;


@end

