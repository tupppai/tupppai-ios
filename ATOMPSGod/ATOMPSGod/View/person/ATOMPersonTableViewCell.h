//
//  ATOMPersonTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATOMPersonTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *themeImageView;
@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

- (void)addTopLine;
- (void)addBottomLine;

@end
