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
#import <AssetsLibrary/AssetsLibrary.h>
#import "DDPageVM.h"

#define ASSET_PHOTO_THUMBNAIL           0
#define ASSET_PHOTO_ASPECT_THUMBNAIL    1
#define ASSET_PHOTO_SCREEN_SIZE         2
#define ASSET_PHOTO_FULL_RESOLUTION     3

@interface Util : NSObject
+ (void)warningBetaTest;
+(NSString*)formatPublishTime:(NSDate*)date;
+(void)ShowTSMessageError:(NSString*)str;
+(void)ShowTSMessageWarn:(NSString*)str;
+(void)ShowTSMessageSuccess:(NSString*)str;
NSString* deviceName();
+(void)showWeAreWorkingOnThisFeature;
+ (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType;
+ (void)copyIntoPasteboard:(NSString*)string;
+ (void) imageWithVm:(DDPageVM*)vm block:(void(^)(UIImage*))block;
@end

@interface Hud : NSObject
+(void)text:(NSString*)message;
+(void)text:(NSString*)message inView:(UIView*)view;
+(void)textWithLightBackground:(NSString*)message;
+(void)customText:(NSString*)message inView:(UIView*)view;
+(void)activity:(NSString*)message;
+(void)activity:(NSString*)message inView:(UIView*)view;
+(void)dismiss;
+(void)dismiss:(UIView*)view;
+(void)success:(NSString*)message inView:(UIView*)view;
+(void)success:(NSString*)message;
+(void)error:(NSString*)message inView:(UIView*)view;
+(void)error:(NSString*)message;

@end


