//
//  ATOMHeaderImageCropperViewController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/13.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"

@protocol ATOMCropHeaderImageCompleteProtocol <NSObject>

- (void)cropHeaderImageCompleteWith:(UIImage *)image;
   
@end


@interface ATOMHeaderImageCropperViewController : ATOMBaseViewController

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, weak) id <ATOMCropHeaderImageCompleteProtocol> delegate;

@end
