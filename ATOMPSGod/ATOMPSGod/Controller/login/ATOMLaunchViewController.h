//
//  ATOMLaunchViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMLoginBaseViewController.h"

typedef enum {
    ATOMSignUpWeixin = 0,
    ATOMSignUpWeibo,
    ATOMSignUpMobile
}ATOMSignUpType;

#import <UIKit/UIKit.h>
#import "ATOMBaseViewController.h"
@interface ATOMLaunchViewController : ATOMLoginBaseViewController

@end
