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

@class ATOMAskPage;
@class DDCommentPageVM;


typedef NS_ENUM(NSInteger, PIEPageType) {
    PIEPageTypeAsk = 0,
    PIEPageTypeHot,
    PIEPageTypeFollow
};



@interface DDPageVM : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, copy) NSString *publishTime;

@property (nonatomic, copy) NSString *likeCount;
@property (nonatomic, copy) NSString *shareCount;
@property (nonatomic, copy) NSString *commentNumber;
@property (nonatomic, copy) NSString *totalPSNumber;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *replierArray;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL collected;

- (void)setViewModelData:(ATOMAskPage *)homeImage;
-(void)setViewModelWithCommon:(DDCommentPageVM*)commonViewModel;
- (void)setViewModelDataWithDetailPage:(ATOMDetailPage *)page;
- (void)toggleLike;
-(DDCommentPageVM*)generatepageDetailViewModel;

- (instancetype)initWithFollowEntity:(PIEEliteEntity *)entity;
@end

