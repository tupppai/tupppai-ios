//
//  ATOMDetailImageViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMDetailImage;
@class ATOMHomePageViewModel;

@interface ATOMDetailImageViewModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, strong) NSString *userImageURL;
@property (nonatomic, copy) NSString *praiseNumber;
@property (nonatomic, copy) NSString *shareNumber;
@property (nonatomic, copy) NSString *commentNumber;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) UIImage *image;

- (void)setViewModelDataWithHomeImage:(ATOMHomePageViewModel *)homePageViewModel;
- (void)setViewModelDataWithDetailImage:(ATOMDetailImage *)detailImage;

@end
