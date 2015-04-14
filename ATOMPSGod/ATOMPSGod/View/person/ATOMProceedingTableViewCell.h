//
//  ATOMProceedingTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATOMProceedingViewModel;

@interface ATOMProceedingTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *userSexImageView;
@property (nonatomic, strong) UILabel *userPublishTimeLabel;
@property (nonatomic, strong) UIImageView *userUploadImageView;
@property (nonatomic, strong) UIButton *uploadButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) ATOMProceedingViewModel *viewModel;

+ (CGFloat)calculateCellHeight;

@end
