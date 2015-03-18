//
//  ATOMLogin.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMUser;

@interface ATOMLogin : NSObject

- (AFHTTPRequestOperation *)Login:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(ATOMUser *user, NSError *error))block;
- (void)saveUserInDB:(ATOMUser *)user;
- (ATOMUser *)getUserBy:(NSString *)uid;
- (BOOL)isExistUser:(ATOMUser *)user;

@end
