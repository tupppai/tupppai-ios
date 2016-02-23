//
//  PIEPageCommentTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 2/23/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEPageCommentTableViewCell.h"
#import "PIEEntityCommentReply.h"

@implementation PIEPageCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews
{
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.commentLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.replyLabel];
    [self.contentView addSubview:self.receiveNameLabel];
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(self.contentView).with.offset(17);
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
    }];
    [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(_avatarView.mas_right).with.offset(10);
    }];
    [_replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(_usernameLabel.mas_right).with.offset(3);
    }];
    [_receiveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(_replyLabel.mas_right).with.offset(3);
    }];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(_usernameLabel.mas_bottom).with.offset(10.5).with.priorityHigh();
        make.left.equalTo(_usernameLabel).with.offset(1);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        make.bottom.equalTo(self.contentView).with.offset(-11);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-17);
        make.left.greaterThanOrEqualTo(_receiveNameLabel.mas_right).with.offset(2);
        make.top.equalTo(self.contentView).with.offset(15);
        make.width.lessThanOrEqualTo(@(80));
    }];
    
    UIView *lineSeperator = [UIView new];
    lineSeperator.backgroundColor = [UIColor colorWithHex:0xE5E5E5 andAlpha:1.0];
    [self.contentView addSubview:lineSeperator];
    [lineSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.leading.equalTo(self.usernameLabel);
        make.trailing.equalTo(self.timeLabel);
        make.bottom.equalTo(self);
    }];
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

-(void)getSource:(PIECommentVM *)vm {
    self.usernameLabel.text = vm.username;
    self.commentLabel.text = vm.text;
    self.timeLabel.text = vm.time;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:vm.avatar]];
    if (vm.replyArray.count > 0) {
        PIEEntityCommentReply* replierModal = [vm.replyArray objectAtIndex:0];
        
        if (replierModal.uid!=[DDUserManager currentUser].uid) {
            self.receiveNameLabel.text= replierModal.username;
            self.receiveNameLabel.tag = replierModal.uid;
            self.replyLabel.hidden = NO;
            self.receiveNameLabel.hidden = NO;
        } else {
            self.replyLabel.hidden = YES;
            self.receiveNameLabel.hidden = YES;
        }
        
    } else {
        self.replyLabel.hidden = YES;
        self.receiveNameLabel.hidden = YES;
    }
}

- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        //        _usernameLabel.backgroundColor = [UIColor clearColor];
        _usernameLabel.numberOfLines = 1;
        _usernameLabel.font = [UIFont lightTupaiFontOfSize:14.0];
        _usernameLabel.textColor = [UIColor blackColor];
        _usernameLabel.userInteractionEnabled = YES;
    }
    return _usernameLabel;
}
- (UILabel *)receiveNameLabel
{
    if (!_receiveNameLabel) {
        _receiveNameLabel = [UILabel new];
        _receiveNameLabel.numberOfLines = 1;
        _receiveNameLabel.hidden = YES;
        _receiveNameLabel.font = [UIFont lightTupaiFontOfSize:14.0];
        _receiveNameLabel.textColor = [UIColor blackColor];
        _receiveNameLabel.userInteractionEnabled = YES;
    }
    return _receiveNameLabel;
}
- (UILabel *)replyLabel
{
    if (!_replyLabel) {
        _replyLabel = [UILabel new];
        _replyLabel.text = @"回复";
        _replyLabel.hidden = YES;
        _replyLabel.font = [UIFont lightTupaiFontOfSize:13.0];
        _replyLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.4];
    }
    return _replyLabel;
}
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont lightTupaiFontOfSize:11.0];
        _timeLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.4];
    }
    return _timeLabel;
}
- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [UILabel new];
        _commentLabel.numberOfLines = 0;
        _commentLabel.font = [UIFont lightTupaiFontOfSize:14.0];
        _commentLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.6];
    }
    return _commentLabel;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.userInteractionEnabled = YES;
        _avatarView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _avatarView.layer.cornerRadius = 25/2.0;
        _avatarView.clipsToBounds = YES;
    }
    return _avatarView;
}


@end
