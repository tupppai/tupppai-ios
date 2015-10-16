//
//  ATOMAccountTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIESettingsTableViewCell.h"

@implementation PIESettingsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.separatorInset = UIEdgeInsetsMake(0, kPadding28, 0, kPadding15);
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        view.image = [UIImage imageNamed:@"pie_next"];
        view.contentMode = UIViewContentModeScaleAspectFit;
        self.accessoryView = view;
    }
    return self;
}





@end
