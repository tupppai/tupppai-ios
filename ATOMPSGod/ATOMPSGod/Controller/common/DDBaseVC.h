//
//  BaseViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMShare.h"
#import "DDShareManager.h"


typedef NS_ENUM(NSInteger, PIEHomeType) {
    PIEHomeTypeHot = 0,
    PIEHomeTypeAsk
};




@interface DDBaseVC : UIViewController

@property (nonatomic, strong) UIBarButtonItem *negativeSpacer;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popCurrentController;
@end
