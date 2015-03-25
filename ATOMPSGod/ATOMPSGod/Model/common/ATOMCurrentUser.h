//
//  ATOMCurrentUser.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMUser;

@interface ATOMCurrentUser : NSObject

/**
 *  用户唯一ID
 */
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger locationID;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
/**
 *  man:1 woman:0
 */
@property (nonatomic, assign) NSInteger sex;
/**
 *  背景图url
 */
@property (nonatomic, copy) NSString *backgroundImage;
/**
 *  被关注注数
 */
@property (nonatomic, assign) NSInteger attentionNumber;
/**
 *  粉丝数
 */
@property (nonatomic, assign) NSInteger fansNumber;
/**
 *  被点赞数
 */
@property (nonatomic, assign) NSInteger praiseNumber;
/**
 *  求P数
 */
@property (nonatomic, assign) NSInteger uploadNumber;
/**
 *  回复作品数
 */
@property (nonatomic, assign) NSInteger replyNumber;
/**
 *  进行中数
 */
@property (nonatomic, assign) NSInteger proceedingNumber;
/**
 *  关注求P数
 */
@property (nonatomic, assign) NSInteger attentionUploadNumber;
/**
 *  关注作品数
 */
@property (nonatomic, assign) NSInteger attentionWorkNumber;

@property (nonatomic, assign) NSInteger avatarID;

+ (ATOMCurrentUser *)currentUser;

- (NSMutableDictionary *)dictionaryFromModel;

- (void)setCurrentUser:(ATOMUser *)user;

@end
