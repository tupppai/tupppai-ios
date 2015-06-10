//
//  ATOMCommentMessageViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMCommentMessage;
@class ATOMAskPageViewModel;

@interface ATOMCommentMessageViewModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *theme;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *imageURL;
/**
 *  1(ask) 2(reply)
 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) ATOMAskPageViewModel *homepageViewModel;

- (void)setViewModelData:(ATOMCommentMessage *)commentMessage;

@end
