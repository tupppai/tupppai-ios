//
//  NSString+ATOMValidate.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "NSString+ATOMValidate.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ATOMValidate)

- (BOOL)isMobileNumber {
//    return [self rangeOfString:@"^1[34578]{1}[0-9]{9}$" options:NSRegularExpressionSearch].location != NSNotFound;
    return YES;
}

- (BOOL)isPassword {
    return [self rangeOfString:@"^[\\-_a-zA-Z0-9]{6,16}$" options:NSRegularExpressionSearch].location != NSNotFound;
}

- (NSString *)sha1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
