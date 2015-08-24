//
//  Util.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/18/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "TSMessage.h"
#import <sys/utsname.h> // import it in your header or implementation file.

@interface Util : NSObject
+(void)text:(NSString*)message;
+(void)text:(NSString*)message inView:(UIView*)view;
+(void)activity:(NSString*)message;
+(void)activity:(NSString*)message inView:(UIView*)view;
+(void)dismiss;
+(void)dismiss:(UIView*)view;
+(void)success:(NSString*)message inView:(UIView*)view;
+(void)Success:(NSString*)message;
+(void)error:(NSString*)message inView:(UIView*)view;
+(void)error:(NSString*)message;
+(NSString*)formatPublishTime:(NSDate*)date;


+(void)ShowTSMessageError:(NSString*)str;
+(void)ShowTSMessageWarn:(NSString*)str;
+(void)ShowTSMessageSuccess:(NSString*)str;
NSString* deviceName();
+(void)showWeAreWorkingOnThisFeature;
@end
@interface Hud : NSObject
@end

@interface Share : NSObject
+ (void) sendLinkContent;
@end
