//
//  ATOMAskPageViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDCommentPageVM.h"
@class ATOMHomeImage;
@class DDCommentPageVM;
@interface DDAskPageVM : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, strong) NSString *userImageURL;
@property (nonatomic, copy) NSString *likeNumber;
@property (nonatomic, copy) NSString *shareNumber;
@property (nonatomic, copy) NSString *commentNumber;
@property (nonatomic, copy) NSString *totalPSNumber;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *replierArray;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, assign) int type;

- (void)setViewModelData:(ATOMHomeImage *)homeImage;
-(void)setViewModelWithCommon:(DDCommentPageVM*)commonViewModel;
- (void)toggleLike;
-(DDCommentPageVM*)generatepageDetailViewModel;
@end

