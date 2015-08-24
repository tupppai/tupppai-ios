//
//  Util.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/18/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "Util.h"
#import "ATOMCommonModel.h"


@implementation Util


NSString* deviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
+(void)text:(NSString*)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}
+(void)text:(NSString*)message inView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

+(void)activity:(NSString*)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
}
+(void)activity:(NSString*)message inView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
}

+(void)dismiss {
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}
+(void)dismiss:(UIView*)view{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}
+(void)success:(NSString*)message inView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_checkmark"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:0.8];
}
+(void)Success:(NSString*)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_checkmark"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:0.8];
}

+(void)error:(NSString*)message inView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotificationBackgroundErrorIcon"]];
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:0.8];
}
+(void)error:(NSString*)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotificationBackgroundErrorIcon"]];
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
        if (result == 0) {
            publishTime = @"刚刚";
        }
    }
    return publishTime;
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
    SIAlertView* alertView = [[SIAlertView alloc]initWithTitle:@"敬请期待" andMessage:@"产品爷正在催程序狗正在写代码"];
    [alertView addButtonWithTitle:@"我知道了" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
        [alertView dismissAnimated:YES];
    }];
    [alertView show];
}

@end

#import "WXApi.h"
@implementation Share
+ (void) sendLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"专访张小龙：产品之上的世界观";
    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

@end
