//
//  Util.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/18/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "Util.h"

@implementation Util
+(void)TextHud:(NSString*)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}
+(void)TextHud:(NSString*)message inView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

+(void)loadingHud:(NSString*)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
}
+(void)loadingHud:(NSString*)message inView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
}

+(void)dismissHud {
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}
+(void)dismissHud:(UIView*)view{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}
+(void)successHud:(NSString*)message inView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_checkmark"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:0.8];
}
+(void)showSuccess:(NSString*)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_checkmark"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:0.8];
}

+(void)failureHud:(NSString*)message inView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"???"]];
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:0.8];
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
    }
    return publishTime;
}

@end
