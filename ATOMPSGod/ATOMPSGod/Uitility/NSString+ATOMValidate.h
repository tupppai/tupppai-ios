//
//  NSString+ATOMValidate.h
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ATOMValidate)

- (BOOL)isMobileNumber;
- (BOOL)isPassword;
- (NSString *)sha1;

@end
