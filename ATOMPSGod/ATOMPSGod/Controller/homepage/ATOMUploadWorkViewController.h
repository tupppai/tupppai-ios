//
//  ATOMUploadWorkViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
@class ATOMAskPageViewModel;

@interface ATOMUploadWorkViewController : ATOMBaseViewController

@property (nonatomic, strong) ATOMAskPageViewModel *askPageViewModel;
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *workImage;

@end
