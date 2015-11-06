//
//  ATOMAccountBindingTableViewCell.h
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseView.h"

@interface PIEAccountBindingTableViewCell : UITableViewCell
@property (nonatomic, strong) UISwitch *bindSwitch;
@property (nonatomic, strong) NSString *phoneNumber;
-(void)addSwitch;
//- (void)setFootCell;

@end
