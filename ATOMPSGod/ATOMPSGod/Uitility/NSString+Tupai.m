//
//  NSString+ATOMValidate.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "NSString+Tupai.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Tupai)

- (BOOL)isMobileNumber {
    return [self rangeOfString:@"^1[345789]{1}[0-9]{9}$" options:NSRegularExpressionSearch].location != NSNotFound;
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

- (NSString*) trimToImageWidth :(int)width {
    //先去掉问号以及问号之后所有内容，再补上?imageView2/2/w/width
    
    NSRange range = [self rangeOfString:@"?"];
    NSString *result = nil;
    
    if (range.location != NSNotFound)
    {
        result = [self substringToIndex:range.location];
    } else {
        result = self;
    }
    
    NSString* suffixString = [NSString stringWithFormat:@"?imageView2/2/w/%d",width];
    result = [result stringByAppendingString:suffixString];
    return result;
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

@end
