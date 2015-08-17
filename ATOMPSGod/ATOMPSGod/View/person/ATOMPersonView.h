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
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *likeLabel;

@property (nonatomic, strong) UITableView *personTableView;

@end
