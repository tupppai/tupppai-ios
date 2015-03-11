//
//  ATOMConcernMessageTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMConcernMessageTableViewCell.h"

@implementation ATOMConcernMessageTableViewCell

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
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake(padding10, padding10, 45, 45)];
    _userHeaderButton.backgroundColor = [UIColor redColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 17, CGRectGetMaxY(_userHeaderButton.frame) - 17, 17, 17)];
    _userSexImageView.image = [UIImage imageNamed:@"man"];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, padding10, SCREEN_WIDTH - 2 * padding10 - 45, 30)];
    NSRange range = {0,5};
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.f], NSFontAttributeName, [UIColor colorWithHex:0x797979], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"波多野结衣 关注了你" attributes:attributeDict];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x00adef] range:range];
    _userNameLabel.attributedText = attributeStr;
    [self addSubview:_userNameLabel];
    
    _concernTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userNameLabel.frame), 120, 15)];
    _concernTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _concernTimeLabel.textColor = [UIColor colorWithHex:0x797979];
    _concernTimeLabel.text = @"10月12号";
    [self addSubview:_concernTimeLabel];
}








































@end
