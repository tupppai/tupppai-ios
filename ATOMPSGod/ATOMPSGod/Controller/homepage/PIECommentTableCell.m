//
//  CommentTableViewCell.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 9/1/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "PIECommentTableCell.h"
#import "PIEEntityCommentReply.h"
@implementation PIECommentTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
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

//    [self.contentView addSubview:self.likeButton];

    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(14);
        make.left.equalTo(self.contentView).with.offset(14);
        make.width.equalTo(@(28));
        make.height.equalTo(@(28));
    }];
    [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(13);
        make.left.equalTo(_avatarView.mas_right).with.offset(17);
    }];
    [_replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(13);
        make.left.equalTo(_usernameLabel.mas_right).with.offset(4);
    }];
    [_receiveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(13);
        make.left.equalTo(_replyLabel.mas_right).with.offset(3);
//        make.bottom.greaterThanOrEqualTo(_commentLabel.mas_top).with.offset(8).with.priorityLow();
    }];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(_usernameLabel.mas_bottom).with.offset(4).with.priorityHigh();
        make.left.equalTo(_usernameLabel).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        make.bottom.equalTo(self.contentView).with.offset(-14);
//        make.height.greaterThanOrEqualTo(@10);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-14);
        make.left.greaterThanOrEqualTo(_receiveNameLabel.mas_right).with.offset(2);
        make.top.equalTo(self.contentView).with.offset(16);
        make.width.lessThanOrEqualTo(@(80));
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
    [self.avatarView setImageWithURL:[NSURL URLWithString:vm.avatar]];
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
//#pragma mark - Getters
//-(CommentLikeButton*)likeButton {
//    if (!_likeButton) {
//        _likeButton = [CommentLikeButton new];
//        }
//    return _likeButton;
//}
- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
//        _usernameLabel.backgroundColor = [UIColor clearColor];
        _usernameLabel.numberOfLines = 1;
        _usernameLabel.font = [UIFont systemFontOfSize:14.0];
        _usernameLabel.textColor = [UIColor grayColor];
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
        _receiveNameLabel.font = [UIFont systemFontOfSize:14.0];
        _receiveNameLabel.textColor = [UIColor grayColor];
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
        _replyLabel.font = [UIFont systemFontOfSize:14.0];
        _replyLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.4];
    }
    return _replyLabel;
}
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:10.0];
        _timeLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.4];
    }
    return _timeLabel;
}
- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [UILabel new];
//        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.numberOfLines = 0;
        _commentLabel.font = [UIFont systemFontOfSize:14.0];
        _commentLabel.textColor = [UIColor darkGrayColor];
    }
    return _commentLabel;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.userInteractionEnabled = NO;
        _avatarView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _avatarView.layer.cornerRadius = kMessageTableViewCellAvatarHeight/2.0;
        _avatarView.layer.masksToBounds = YES;
        [self.avatarView setImageWithURL:[NSURL URLWithString:[DDUserManager currentUser].avatar]];
    }
    return _avatarView;
}

@end
