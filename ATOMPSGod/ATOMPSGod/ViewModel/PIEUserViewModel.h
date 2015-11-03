//
//  PIEUserViewModel.h
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATOMUser.h"

@interface PIEUserViewModel : NSObject
/**
 *  省份provinceName,provinceID,城市cityName,cityID
 */

@property (nonatomic, strong) NSMutableArray *replies;

@property (nonatomic, strong) NSMutableDictionary *region;
/**
 *  通过第三方平台可能获取到的数据
 */
/**
 *  注册类型 weixin = 0 ,weibo = 1 ,mobile = 3
 */
@property (nonatomic, assign) ATOMSignUpType signUpType;
/**
 *  用户唯一ID
 */
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger locationID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
/**
 *  man:1 woman:0
 */
@property (nonatomic, assign) BOOL sex;

@property (nonatomic, assign) NSInteger attentionNumber;
/**
 *  粉丝数
 */
@property (nonatomic, assign) NSInteger fansNumber;
/**
 *  被点赞数
 */
@property (nonatomic, assign) NSInteger likeNumber;
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

@property (nonatomic, assign) bool bindWechat;
@property (nonatomic, assign) bool bindWeibo;
@property (nonatomic, assign) bool bindQQ;
- (instancetype)initWithEntity:(ATOMUser*)user;
@end
