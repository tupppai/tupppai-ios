//
//  ATOMUser.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEBaseModel.h"
#import "MTLFMDBAdapter.h"

typedef enum {
    ATOMSignUpWechat = 0,
    ATOMSignUpWeibo,
    ATOMSignUpMobile,
    ATOMSignUpQQ
}ATOMSignUpType;



@interface PIEUserModel : PIEBaseModel <MTLFMDBSerializing>

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
/**
 *  用户唯一ID
 */
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) BOOL bindWeibo;
@property (nonatomic, assign) BOOL bindWechat;
@property (nonatomic, assign) BOOL bindQQ;
@property (nonatomic, assign) BOOL blocked;
@property (nonatomic, assign) BOOL isV;

/**
 *  此用户是否我的粉丝
 */
@property (nonatomic, assign) BOOL isMyFan;
/**
 *  此用户是否我的关注
 */
@property (nonatomic, assign) BOOL isMyFollow;
@property (nonatomic, assign) NSInteger cityID;
@property (nonatomic, assign) NSInteger provinceID;
@property (nonatomic, assign) NSInteger locationID;

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString* token;

/**
 *  背景图url
 */
@property (nonatomic, copy) NSString *backgroundImage;
/**
 *  man:1 woman:0
 */
@property (nonatomic, assign) NSInteger sex;

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

@property (nonatomic, assign) NSInteger likedCount;
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

@property (nonatomic, assign) CGFloat balance;

@end
