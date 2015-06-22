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
    [hud hide:YES afterDelay:2];
}
+(void)loadingHud:(NSString*)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
}
+(void)dismissHud {
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}
//class func showSuccessProgress(labelText: String?, view: UIView, complete: (()->())?) {
//    dismissMBProgressHUD(view)
//    let progressHud = MBProgressHUD.showHUDAddedTo(view, animated: true)
//    progressHud.customView = UIImageView(image: UIImage(named: "ic-checked-filled"))
//    progressHud.mode = MBProgressHUDModeCustomView
//    progressHud.labelText = labelText
//    progressHud.hide(true, afterDelay: 0.6)
//    
//    if let complete = complete {
//        let completeTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.6))
//        dispatch_after(completeTime, dispatch_get_main_queue(), complete)
//    }
//}
//
//class func showErrorProgress(labelText: String?, view: UIView, complete: (()->())?) {
//    dismissMBProgressHUD(view)
//    
//    let progressHud = MBProgressHUD.showHUDAddedTo(view, animated: true)
//    progressHud.customView = UIImageView(image: UIImage(named: "ic-cancel-filled"))
//    progressHud.mode = MBProgressHUDModeCustomView
//    progressHud.labelText = labelText
//    progressHud.hide(true, afterDelay: 0.6)
//    
//    if let complete = complete {
//        let completeTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.6))
//        dispatch_after(completeTime, dispatch_get_main_queue(), complete)
//    }
//}
//
//class func showLoadingProgress(labelText: String?, view: UIView) {
//    dismissMBProgressHUD(view)
//    let progressHud = MBProgressHUD.showHUDAddedTo(view, animated: true)
//    progressHud.mode = MBProgressHUDModeIndeterminate
//    progressHud.labelText = labelText
//}
//
//class func showLoadingProgressColored(labelText: String?, view: UIView, backgroundColor: UIColor?) {
//    dismissMBProgressHUD(view)
//    let progressHud = MBProgressHUD.showHUDAddedTo(view, animated: true)
//    progressHud.mode = MBProgressHUDModeIndeterminate
//    progressHud.labelText = labelText
//    progressHud.color = backgroundColor
//}
//class func showTextOnlyProgress(labelText: String?, view: UIView, backgroundColor: UIColor?,removeFromSuperViewOnHide:Bool,delayToHide:NSTimeInterval) {
//    dismissMBProgressHUD(view)
//    let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
//    hud.mode = MBProgressHUDModeText
//    hud.labelText = labelText
//    hud.color = backgroundColor
//    hud.margin = 10
//    hud.removeFromSuperViewOnHide = removeFromSuperViewOnHide
//    hud.hide(true, afterDelay: delayToHide)
//}
//class func dismissMBProgressHUD(view: UIView) {
//    MBProgressHUD.hideHUDForView(view, animated: true)
//}
@end
