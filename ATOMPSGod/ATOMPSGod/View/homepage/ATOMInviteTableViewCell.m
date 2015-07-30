//
//  ATOMInviteTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/12.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMInviteTableViewCell.h"

@interface ATOMInviteTableViewCell ()

@property (nonatomic, strong) UIView *dotView1;
@property (nonatomic, strong) UIView *dotView2;

@end

@implementation ATOMInviteTableViewCell

static CGFloat cellHeight = 70;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _userHeaderButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding15, (cellHeight - kUserHeaderButtonWidth) / 2, kUserHeaderButtonWidth, kUserHeaderButtonWidth)];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.layer.cornerRadius = kUserHeaderButtonWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    [_userHeaderButton setBackgroundImage:[UIImage imageNamed:@"head_portrait"] forState:UIControlStateNormal];
    [self addSubview:_userHeaderButton];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, CGRectGetMinY(_userHeaderButton.frame), kUserNameLabelWidth, kFont14+2)];
    _userNameLabel.text = @"PSGOD";
    _userNameLabel.font = [UIFont systemFontOfSize:kFont14];
    [self addSubview:_userNameLabel];
    
    _inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kPadding15 - 55, 20, 55, 30)];
    _inviteButton.userInteractionEnabled = NO;
    _inviteButton.layer.cornerRadius = 5;
    _inviteButton.backgroundColor = [UIColor colorWithHex:0x74c3ff];
    [_inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_inviteButton setTitle:@"邀请" forState:UIControlStateNormal];
    _inviteButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:_inviteButton];
    
    _fansNumberLabel = [UILabel new];
    _fansNumberLabel.textColor = [UIColor colorWithHex:0xc5cdd3];
    _fansNumberLabel.font = [UIFont systemFontOfSize:kFont10];
    [self addSubview:_fansNumberLabel];
    _dotView1 = [self littleCircleView];
    [self addSubview:_dotView1];
    _uploadNumberLabel = [UILabel new];
    _uploadNumberLabel.textColor = [UIColor colorWithHex:0xc5cdd3];
    _uploadNumberLabel.font = [UIFont systemFontOfSize:kFont10];
    [self addSubview:_uploadNumberLabel];
    _dotView2 = [self littleCircleView];
    [self addSubview:_dotView2];
    _workNumberLabel = [UILabel new];
    _workNumberLabel.textColor = [UIColor colorWithHex:0xc5cdd3];
    _workNumberLabel.font = [UIFont systemFontOfSize:kFont10];
    [self addSubview:_workNumberLabel];
    
}

- (UIView *)littleCircleView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:0xc5cdd3];
    view.layer.cornerRadius = 2.5;
    return view;
}

- (void)toggleInviteButtonAppearance {
    if (!_inviteButton.selected) {
        _inviteButton.selected = !_inviteButton.selected;
            _inviteButton.backgroundColor = [UIColor colorWithHex:0xc5cdd3];
            [_inviteButton setTitle:@"已邀请" forState:UIControlStateNormal];
        _inviteButton.enabled = NO;
    }
}

-(void)setViewModel:(ATOMInviteCellViewModel *)viewModel {
    _inviteButton.selected = viewModel.invited;
    _inviteButton.tag = viewModel.uid;
    _userNameLabel.text = viewModel.nickname;
    NSURL* url = [NSURL URLWithString:viewModel.avatarUrl];
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:url placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _fansNumberLabel.text = viewModel.fansDesc;
    _uploadNumberLabel.text = viewModel.askDesc;
    _workNumberLabel.text = viewModel.replyDesc;
    CGFloat labelOriginY = CGRectGetMaxY(_userNameLabel.frame) + kPadding5;
    _fansNumberLabel.frame = CGRectMake(kPadding15 + CGRectGetMaxX(_userHeaderButton.frame), labelOriginY, kFont10 * (_fansNumberLabel.text.length), kFont10);
    _dotView1.frame = CGRectMake(CGRectGetMaxX(_fansNumberLabel.frame) + kPadding5, labelOriginY + 2.5, 5, 5);
    _uploadNumberLabel.frame = CGRectMake(CGRectGetMaxX(_dotView1.frame) + kPadding5, labelOriginY, kFont10 * (_uploadNumberLabel.text.length ), kFont10);
    _dotView2.frame = CGRectMake(CGRectGetMaxX(_uploadNumberLabel.frame) + kPadding5, labelOriginY + 2.5, 5, 5);
    _workNumberLabel.frame = CGRectMake(CGRectGetMaxX(_dotView2.frame) + kPadding5, labelOriginY, kFont10 * (_workNumberLabel.text.length), kFont10);
}



@end
