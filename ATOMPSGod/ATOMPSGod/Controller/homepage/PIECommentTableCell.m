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
        self.backgroundColor = [UIColor whiteColor];
        self.separatorInset = UIEdgeInsetsMake(0, kMessageTableViewCellAvatarHeight+kPadding15+5, 0, 0);
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

//    [self.contentView addSubview:self.likeButton];

    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(kPadding15);
        make.left.equalTo(self.contentView).with.offset(kPadding15);
        make.width.equalTo(@(kMessageTableViewCellAvatarHeight));
        make.height.equalTo(@(kMessageTableViewCellAvatarHeight));
    }];
    [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(kPadding15);
        make.left.equalTo(_avatarView.mas_right).with.offset(kPadding15);
    }];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_usernameLabel).with.offset(kPadding15);
        make.left.equalTo(_usernameLabel).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        make.bottom.equalTo(self.contentView).with.offset(-kPadding10);
//        make.height.greaterThanOrEqualTo(@10);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(_usernameLabel.mas_right).with.offset(2);
        make.top.equalTo(self.contentView).with.offset(kPadding15);
        make.right.equalTo(self.contentView).with.offset(-14);
        make.width.lessThanOrEqualTo(@(80));
//        make.bottom.equalTo(_commentLabel.mas_top);
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
//    self.likeButton.selected = vm.liked;
//    self.likeButton.likeNumber = vm.likeNumber;
    [self.avatarView setImageWithURL:[NSURL URLWithString:vm.avatar]];
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
        _usernameLabel.numberOfLines = 0;
        _usernameLabel.font = [UIFont systemFontOfSize:14.0];
        _usernameLabel.textColor = [UIColor grayColor];
    }
    return _usernameLabel;
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
        _commentLabel.font = [UIFont systemFontOfSize:16.0];
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
