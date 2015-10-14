//
//  ATOMAccountBindingTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAccountBindingTableViewCell.h"

@implementation ATOMAccountBindingTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor darkGrayColor];
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
    _phoneNumber = [phoneNumber stringByReplacingCharactersInRange:range withString:@"****"];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 7.5;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0], NSFontAttributeName, [UIColor colorWithHex:0x797979], NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_phoneNumber] attributes:attributeDict];

    UILabel* phoneLabel = [UILabel new];
    phoneLabel.attributedText = attributeStr;
    [self addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
}






@end
