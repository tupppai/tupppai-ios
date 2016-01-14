//
//  ATOMAskPageViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIEPageModel.h"
@interface PIEPageVM : NSObject

@property (nonatomic, strong) PIEPageModel *model;

@property (nonatomic, assign) CGFloat imageWidth DEPRECATED_MSG_ATTRIBUTE("Use imageRatio instead.");
@property (nonatomic, assign) CGFloat imageHeight DEPRECATED_MSG_ATTRIBUTE("Use imageRatio instead.");

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger askID;
@property (nonatomic, assign) NSInteger userID;

//have to be strong since username is reference to model.nickname,syncedwith model.nickname
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) PIEPageType type;
@property (nonatomic, assign) CGFloat imageRatio;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, assign) BOOL followed;
@property (nonatomic, assign) BOOL isMyFan;
@property (nonatomic, assign) BOOL isV;
@property (nonatomic, strong) NSArray <PIEModelImage*> *models_image;
@property (nonatomic, strong) NSArray <PIECommentModel*> *models_comment;
@property (nonatomic, strong) NSArray <PIECategoryModel*> *models_catogory;


@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *likeCount;
@property (nonatomic, copy) NSString *shareCount;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *replyCount;
@property (nonatomic, copy) NSString *collectCount;
@property (nonatomic, assign) PIEPageLoveStatus loveStatus;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *avatarURL;


@property (nonatomic, strong) UIImage *image;
//求p 的图片对象数组


- (instancetype)initWithPageEntity:(PIEPageModel *)entity ;
- (void)increaseLoveStatus;
- (void)decreaseLoveStatus;
- (void)revertStatus ;
-(void)love:(BOOL)revert;
-(void)follow;

@end

