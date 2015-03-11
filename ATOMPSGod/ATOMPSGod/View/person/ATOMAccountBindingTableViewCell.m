//
//  ATOMAccountBindingTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMAccountBindingTableViewCell.h"

@implementation ATOMAccountBindingTableViewCell

static int padding10 = 10;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _themeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding10, 6.5, 41, 40)];
    [self addSubview:_themeImageView];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_themeImageView.frame) + padding10, 6.5, 140, 40)];
    _themeLabel.textColor = [UIColor colorWithHex:0x797979];
    _themeLabel.numberOfLines = 0;
    [self addSubview:_themeLabel];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - padding10 - 57, 11.5, 57, 30)];
    _rightButton.layer.cornerRadius = 5;
    _rightButton.layer.masksToBounds = YES;
    _rightButton.backgroundColor = [UIColor colorWithHex:0xcccccc];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton setTitle:@"绑定" forState:UIControlStateNormal];
    [self addSubview:_rightButton];
}

- (void)setFootCell {
    [_rightButton removeFromSuperview];
    [_themeLabel removeFromSuperview];
    [_themeImageView removeFromSuperview];
    UILabel *footLabel = [[UILabel alloc] initWithFrame:self.bounds];
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.text = @"绑定账号后可以直接用它们登陆求PS大神";
    footLabel.font = [UIFont systemFontOfSize:14.f];
    footLabel.textColor = [UIColor colorWithHex:0x797979];
    [self addSubview:footLabel];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    NSRange range = {3,4};
    _phoneNumber = [phoneNumber stringByReplacingCharactersInRange:range withString:@"****"];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 7.5;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f], NSFontAttributeName, [UIColor colorWithHex:0x797979], NSForegroundColorAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"手机号\n已绑定%@",_phoneNumber] attributes:attributeDict];
    range.location = 0;
    range.length = 3;
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:range];
    range.location = 4;
    range.length = 3;
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xcbcbcb] range:range];
    _themeLabel.attributedText = attributeStr;
    
}






@end
