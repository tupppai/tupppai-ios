//
//  ATOMAccountBindingTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEAccountBindingTableViewCell.h"

@implementation PIEAccountBindingTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return self;
}
-(void)addSwitch {
     _bindSwitch = [UISwitch new];
    _bindSwitch.onTintColor = [UIColor colorWithHex:PIEColorHex];
    self.accessoryView = _bindSwitch;
}


- (void)setPhoneNumber:(NSString *)phoneNumber {
    NSRange range = {3,4};
    if (phoneNumber.length >= 5) {
        _phoneNumber = [phoneNumber stringByReplacingCharactersInRange:range withString:@"****"];
    }
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 7.5;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0], NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_phoneNumber] attributes:attributeDict];

    UILabel* phoneLabel = [UILabel new];
    phoneLabel.attributedText = attributeStr;
    [self addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).with.offset(80);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
}






@end
