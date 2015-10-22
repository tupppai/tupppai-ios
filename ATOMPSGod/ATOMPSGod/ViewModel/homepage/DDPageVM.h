//
//  ATOMAskPageViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDCommentPageVM.h"
#import "ATOMDetailPage.h"

@class PIEPageEntity;
@class DDCommentPageVM;



@interface DDPageVM : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger askID;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *likeCount;
@property (nonatomic, copy) NSString *shareCount;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *totalPSNumber;
@property (nonatomic, copy) NSString *collectCount;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *replierArray;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, assign) BOOL followed;


//求p 的图片对象数组
@property (nonatomic, copy) NSArray *askImageModelArray;

@property (nonatomic, strong) NSString *imageURL1;
@property (nonatomic, strong) NSString *imageURL2;


-(DDCommentPageVM*)generatepageDetailViewModel;
- (instancetype)initWithPageEntity:(PIEPageEntity *)entity ;
- (instancetype)initWithFollowEntity:(PIEEliteEntity *)entity;

- (void)toggleLike:(void (^)(BOOL success))block ;
@end

