//
//  Util.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/18/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "Util.h"
#import "DDBaseService.h"
#import "PIEShareImageView.h"

@implementation Util

+ (void)warningBetaTest {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"亲爱的顶级测试用户" andMessage:@"测试阶段此功能暂不可用，如果你有什么强烈的需求建议，请联系我们\n运营妹妹的邮箱：liuzi@tupppai.com"];
    [alertView addButtonWithTitle:@"朕知道了"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
}

+ (void)copyIntoPasteboard:(NSString*)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    [Hud success:@"成功复制到粘贴板"];
}


+ (void) imageWithVm:(DDPageVM*)vm block:(void(^)(UIImage*))block
{
    
    PIEShareImageView* view = [PIEShareImageView new];
    [view injectSauce:vm withBlock:^(BOOL success) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (block) {
            block(snapshotImage);
        }
    }];
}



NSString* deviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+(NSString*)formatPublishTime:(NSDate*)date {
    NSString* publishTime;
    NSDateFormatter *df = [NSDateFormatter new];
    NSTimeInterval timeInterval = - ([date timeIntervalSinceNow]);
    float dayDif = timeInterval/3600/24;
    int result = 0;
    if (dayDif > 7) {
        [df setDateFormat:@"MM月dd日 HH:mm"];
        publishTime = [df stringFromDate:date];
    } else if (dayDif >= 1) {
        result = (int)roundf(dayDif);
        publishTime = [NSString stringWithFormat:@"%d天前",result];
    } else if (dayDif >= 1/24.0) {
        result = (int)roundf(dayDif*24.0);
        publishTime = [NSString stringWithFormat:@"%d小时前",result];
    } else {
        result = (int)roundf(dayDif*24.0*60);
        publishTime = [NSString stringWithFormat:@"%d分钟前",result];
        if (result == 0) {
            publishTime = @"刚刚";
        }
    }
    return publishTime;
}

+ (void) updateAvaterImage {
    
}

+(void)ShowTSMessageError:(NSString*)str {
    [TSMessage showNotificationWithTitle:str
                                    type:TSMessageNotificationTypeError];
    
}
+(void)ShowTSMessageSuccess:(NSString*)str {
    [TSMessage showNotificationWithTitle:str
                                    type:TSMessageNotificationTypeSuccess];
    
}

+(void)ShowTSMessageWarn:(NSString*)str {
    [TSMessage showNotificationWithTitle:str
                                    type:TSMessageNotificationTypeWarning];
    
}


+(void)showWeAreWorkingOnThisFeature {
    SIAlertView* alertView = [[SIAlertView alloc]initWithTitle:@"敬请期待" andMessage:@"我们正在设计此功能"];
    [alertView addButtonWithTitle:@"朕知道了" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
        [alertView dismissAnimated:YES];
    }];
    [alertView show];
}

+ (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType
{
    CGImageRef iRef = nil;
    
    if (nType == ASSET_PHOTO_THUMBNAIL)
        iRef = [asset thumbnail];
    else if (nType == ASSET_PHOTO_ASPECT_THUMBNAIL)
        iRef = [asset aspectRatioThumbnail];
    else if (nType == ASSET_PHOTO_SCREEN_SIZE)
        iRef = [asset.defaultRepresentation fullScreenImage];
    else if (nType == ASSET_PHOTO_FULL_RESOLUTION)
    {
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]])
        {
            iRef = [asset.defaultRepresentation fullResolutionImage];
            return [UIImage imageWithCGImage:iRef scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        }
        else
        {
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
            
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error) {
                NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            
            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            
            UIImage *iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            return iImage;
        }
    }
    
    return [UIImage imageWithCGImage:iRef];
}
@end

@implementation Hud

+(void)text:(NSString*)message {
    if ([UIApplication sharedApplication].keyWindow) {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 30.f;
    hud.cornerRadius = 4;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    }
}
+(void)textWithLightBackground:(NSString*)message {
    if ([UIApplication sharedApplication].keyWindow) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.color = [UIColor colorWithHex:0xffffff andAlpha:0.5];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        hud.margin = 30.f;
        hud.cornerRadius = 4;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
}

+(void)text:(NSString*)message inView:(UIView*)view {
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        hud.margin = 30.f;
        hud.cornerRadius = 4;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
}
+(void)customText:(NSString*)message inView:(UIView*)view {
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        hud.margin = 30.f;
        hud.cornerRadius = 4;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
}
+(void)activity:(NSString*)message {
    if ([UIApplication sharedApplication].keyWindow) {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.margin = 30;
    hud.cornerRadius = 4;
    hud.color = [UIColor colorWithHex:0x000000 andAlpha:0.2];
    hud.labelText = message;
    }
}
+(void)activity:(NSString*)message inView:(UIView*)view {
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.margin = 30;
        hud.cornerRadius = 4;
        hud.color = [UIColor colorWithHex:0x000000 andAlpha:0.2];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = message;
    }
}

+(void)dismiss {
    if ([UIApplication sharedApplication].keyWindow) {
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }
}
+(void)dismiss:(UIView*)view{
    if (view) {
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }
}
+(void)success:(NSString*)message inView:(UIView*)view {
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_checkmark"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = message;
        [hud show:YES];
        [hud hide:YES afterDelay:0.8];
    }
}
+(void)success:(NSString*)message {
    if ([UIApplication sharedApplication].keyWindow) {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_checkmark"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:0.8];
    }
}

+(void)error:(NSString*)message inView:(UIView*)view {
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotificationBackgroundErrorIcon"]];
        hud.labelText = message;
        [hud show:YES];
        [hud hide:YES afterDelay:0.8];
    }
}
+(void)error:(NSString*)message {
    if ([UIApplication sharedApplication].keyWindow) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotificationBackgroundErrorIcon"]];
        hud.labelText = message;
        [hud show:YES];
        [hud hide:YES afterDelay:0.8];
    }
}

@end

