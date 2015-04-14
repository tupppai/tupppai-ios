//
//  ATOMUploadWorkViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
@class ATOMHomePageViewModel;

@interface ATOMUploadWorkViewController : ATOMBaseViewController

@property (nonatomic, strong) ATOMHomePageViewModel *homePageViewModel;
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *workImage;

@end
