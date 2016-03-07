//
//  OpenshareAuthUser.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 3/7/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenshareAuthUser : NSObject

/** 第三方平台的用户昵称 */
@property (nonatomic, strong) NSString *nickname;

/** 第三方平台的用户头像 */
@property (nonatomic, strong) NSString *icon;

/** openid */
@property (nonatomic, strong) NSString *uid;

/** 原始数据 */
@property (nonatomic, strong) NSDictionary *rawData;

@end
