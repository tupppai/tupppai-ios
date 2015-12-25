//
//  PIEProceedingViewController.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface PIEProceedingViewController : DDBaseVC
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
- (void)navToToHelp;
@end
