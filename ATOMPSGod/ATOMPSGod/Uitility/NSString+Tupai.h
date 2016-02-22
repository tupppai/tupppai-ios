//
//  NSString+ATOMValidate.h
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tupai)

- (BOOL)isMobileNumber;
- (BOOL)isPassword;
- (NSString *)sha1;
- (NSString*) trimToImageWidth :(int)width ;
- (NSString *)md5;
@end
