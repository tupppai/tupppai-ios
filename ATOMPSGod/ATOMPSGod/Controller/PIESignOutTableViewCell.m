//
//  PIESignOutTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/16/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESignOutTableViewCell.h"

@implementation PIESignOutTableViewCell

- (void)awakeFromNib {
    _label.backgroundColor = [UIColor colorWithHex:0xFEEF04];
    _label.text = @"退出当前帐号";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
