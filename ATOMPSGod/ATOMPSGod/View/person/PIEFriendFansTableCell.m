//
//  ATOMMyFansTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIEFriendFansTableCell.h"
#import "ATOMFansViewModel.h"

@interface PIEFriendFansTableCell ()

@property (nonatomic, strong) UIView *dotView1;
@property (nonatomic, strong) UIView *dotView2;

@end
@implementation PIEFriendFansTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    
    [self.contentView addSubview:self.userHeaderButton];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.fansNumberLabel];
    [self.contentView addSubview:self.dotView1];
    [self.contentView addSubview:self.uploadNumberLabel];
    [self.contentView addSubview:self.dotView2];
    [self.contentView addSubview:self.workNumberLabel];
    [self.contentView addSubview:self.attentionButton];
    
    [self layoutMyViews];
}



- (void)layoutMyViews {
    [self.userHeaderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kfcAvatarWidth));
        make.height.equalTo(@(kfcAvatarWidth));
        make.left.equalTo(self.contentView).with.offset(kPadding15);
        make.centerY.equalTo(self.contentView);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userHeaderButton).with.offset(-2);
        make.left.equalTo(self.userHeaderButton.mas_right).with.offset(5);
    }];
    [self.fansNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLabel);
        make.bottom.equalTo(_userHeaderButton.mas_bottom).with.offset(2);
    }];
    [self.dotView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fansNumberLabel.mas_right).with.offset(5);
        make.centerY.equalTo(_fansNumberLabel);
        make.width.equalTo(@(5));
        make.height.equalTo(@(5));
    }];
    [self.uploadNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dotView1.mas_right).with.offset(5);
        make.centerY.equalTo(_fansNumberLabel);
    }];
    [self.dotView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_uploadNumberLabel.mas_right).with.offset(5);
        make.centerY.equalTo(_fansNumberLabel);
        make.width.equalTo(@(5));
        make.height.equalTo(@(5));
    }];
    [self.workNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dotView2.mas_right).with.offset(5);
        make.centerY.equalTo(_fansNumberLabel);
    }];
    [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(43));
        make.height.equalTo(@(27));
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setViewModel:(ATOMFansViewModel *)viewModel {
    
    _viewModel = viewModel;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    _userNameLabel.text = viewModel.userName;
    _fansNumberLabel.text = [NSString stringWithFormat:@"%@粉丝", viewModel.fansCount];
    _uploadNumberLabel.text = [NSString stringWithFormat:@"%@求P", viewModel.askCount];
    _workNumberLabel.text = [NSString stringWithFormat:@"%@作品", viewModel.replyCount];

    if (viewModel.isFollow) {
        //已关注
        _attentionButton.selected = YES;
    } else  {
        _attentionButton.selected = NO;
    }
}


-(UIButton*)userHeaderButton {
    if (!_userHeaderButton) {
        _userHeaderButton = [UIButton new];
        _userHeaderButton.userInteractionEnabled = NO;
        _userHeaderButton.layer.cornerRadius = kfcAvatarWidth / 2;
        _userHeaderButton.layer.masksToBounds = YES;
        [_userHeaderButton setBackgroundImage:[UIImage imageNamed:@"head_portrait"] forState:UIControlStateNormal];
    }
    return _userHeaderButton;
}
-(UIButton*)attentionButton {
    if (!_attentionButton) {
        _attentionButton = [UIButton new];
        _attentionButton.userInteractionEnabled = NO;
        [_attentionButton setImage:[UIImage imageNamed:@"new_reply_follow"] forState:UIControlStateNormal];
        [_attentionButton setImage:[UIImage imageNamed:@"new_reply_followed"] forState:UIControlStateSelected];
        _attentionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _attentionButton;
}

-(UILabel*)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [UILabel new];
        _userNameLabel.text = @"**";
        _userNameLabel.font = [UIFont systemFontOfSize:kFont14];
    }
    return _userNameLabel;
}
-(UILabel*)fansNumberLabel {
    if (!_fansNumberLabel) {
        _fansNumberLabel = [UILabel new];
        _fansNumberLabel.textColor = [UIColor colorWithHex:0xc5cdd3];
        _fansNumberLabel.font = [UIFont systemFontOfSize:11];
    }
    return _fansNumberLabel;
}
-(UILabel*)workNumberLabel {
    if (!_workNumberLabel) {
        _workNumberLabel = [UILabel new];
        _workNumberLabel.textColor = [UIColor colorWithHex:0xc5cdd3];
        _workNumberLabel.font = [UIFont systemFontOfSize:11];
    }
    return _workNumberLabel;
}
-(UILabel*)uploadNumberLabel {
    if (!_uploadNumberLabel) {
        _uploadNumberLabel = [UILabel new];
        _uploadNumberLabel.textColor = [UIColor colorWithHex:0xc5cdd3];
        _uploadNumberLabel.font = [UIFont systemFontOfSize:11];
    }
    return _uploadNumberLabel;
}
- (UIView *)dotView1 {
    if (!_dotView1) {
        _dotView1 = [UIView new];
        _dotView1.backgroundColor = [UIColor colorWithHex:0xc5cdd3];
        _dotView1.layer.cornerRadius = 2.5;
    }
    return _dotView1;
}
- (UIView *)dotView2 {
    if (!_dotView2) {
        _dotView2 = [UIView new];
        _dotView2.backgroundColor = [UIColor colorWithHex:0xc5cdd3];
        _dotView2.layer.cornerRadius = 2.5;
    }
    return _dotView2;
}


@end
