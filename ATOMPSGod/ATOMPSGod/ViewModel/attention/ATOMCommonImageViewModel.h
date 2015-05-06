//
//  ATOMCommonImageViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/5/6.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMCommonImage;

@interface ATOMCommonImageViewModel : NSObject

@property (nonatomic, assign) NSInteger imageID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, strong) NSString *userImageURL;
@property (nonatomic, copy) NSString *praiseNumber;
@property (nonatomic, copy) NSString *shareNumber;
@property (nonatomic, copy) NSString *commentNumber;
@property (nonatomic, copy) NSString *totalPSNumber;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *replierArray;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) UIImage *image;
- (void)setViewModelData:(ATOMCommonImage *)commonImage;

@end
