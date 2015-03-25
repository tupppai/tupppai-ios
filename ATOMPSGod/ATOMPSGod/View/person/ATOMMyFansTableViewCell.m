//
//  ATOMMyFansTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyFansTableViewCell.h"

@implementation ATOMMyFansTableViewCell

static int padding10 = 10;
static float commenWidth;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake(padding10, 6, 45, 45)];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.backgroundColor = [UIColor greenColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - SEXRADIUS, CGRectGetMaxY(_userHeaderButton.frame) - SEXRADIUS, SEXRADIUS, SEXRADIUS)];
    _userSexImageView.image = [UIImage imageNamed:@"woman"];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, 0, 80, 30)];
    _userNameLabel.text = @"atom";
    [self addSubview:_userNameLabel];
    
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - padding10 - 22, 17, 22, 23)];
    _attentionButton.userInteractionEnabled = NO;
    [_attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_attention"] forState:UIControlStateNormal];
    [_attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_addattention"] forState:UIControlStateSelected];
    [self addSubview:_attentionButton];
    
    commenWidth = (CGOriginX(_attentionButton.frame) - CGRectGetMaxX(_userHeaderButton.frame) - padding10 * 2) / 3;
    
    _fansNumberButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userNameLabel.frame), commenWidth, 15)];
    [self setCommonButton:_fansNumberButton WithImage:[UIImage imageNamed:@"fans_num"]];
    _uploadNumberButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_fansNumberButton.frame), CGRectGetMaxY(_userNameLabel.frame), commenWidth, 15)];
    [self setCommonButton:_uploadNumberButton WithImage:[UIImage imageNamed:@"psask_num"]];
    _workNumberButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_uploadNumberButton.frame), CGRectGetMaxY(_userNameLabel.frame), commenWidth, 15)];
    [self setCommonButton:_workNumberButton WithImage:[UIImage imageNamed:@"pswork_num"]];
    
}

- (void)setCommonButton:(UIButton *)button WithImage:(UIImage *)image {
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
    [button setTitle:@"1000" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    button.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [button setTitleColor:[UIColor colorWithHex:0x7a7a7a] forState:UIControlStateNormal];
    [self addSubview:button];
}





















@end
