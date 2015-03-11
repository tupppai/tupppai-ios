//
//  ATOMPersonView.h
//  ATOMPSGod
//
//  Created by atom on 15/3/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@interface ATOMPersonView : ATOMBaseView

@property (nonatomic, strong) UIImageView *topBackGroundImageView;
@property (nonatomic, strong) UIButton *userHeaderButton;
@property (nonatomic, strong) UIImageView *userSexImageView;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *praiseLabel;

@property (nonatomic, strong) UITableView *personTableView;

@end
