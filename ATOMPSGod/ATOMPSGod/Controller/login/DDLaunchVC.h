//
//  ATOMLaunchViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDLoginBaseVC.h"

typedef enum {
    ATOMSignUpWechat = 0,
    ATOMSignUpWeibo,
    ATOMSignUpMobile
}ATOMSignUpType;

#import <UIKit/UIKit.h>
#import "DDBaseVC.h"
@interface DDLaunchVC : DDLoginBaseVC

@end
