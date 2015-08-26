//
//  ATOMCropImageController.h
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDBaseVC.h"
@class DDAskPageVM;
@class DDCommentPageVM;
@interface DDCropImageVC : DDBaseVC
@property (nonatomic, strong) DDAskPageVM *askPageViewModel;
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *workImage;
@end
