//
//  ATOMConcernMessageTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMConcernMessageTableViewCell.h"
#import "ATOMConcernMessageViewModel.h"

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
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - SEXRADIUS, CGRectGetMaxY(_userHeaderButton.frame) - SEXRADIUS, SEXRADIUS, SEXRADIUS)];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, padding10, SCREEN_WIDTH - 2 * padding10 - 45, 30)];

    [self addSubview:_userNameLabel];
    
    _concernTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userNameLabel.frame), 150, 15)];
    _concernTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _concernTimeLabel.textColor = [UIColor colorWithHex:0x797979];
    [self addSubview:_concernTimeLabel];
}

- (void)setViewModel:(ATOMConcernMessageViewModel *)viewModel {
    _viewModel = viewModel;
    NSRange range = {0, viewModel.userName.length};
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.f], NSFontAttributeName, [UIColor colorWithHex:0x797979], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 关注了你",viewModel.userName] attributes:attributeDict];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x00adef] range:range];
    _userNameLabel.attributedText = attributeStr;
    _userSexImageView.image = [UIImage imageNamed:viewModel.userSex];
    _concernTimeLabel.text = viewModel.publishTime;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
}





































@end
