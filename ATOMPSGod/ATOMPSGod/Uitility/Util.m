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
    [hud hide:YES afterDelay:3];
}
@end
