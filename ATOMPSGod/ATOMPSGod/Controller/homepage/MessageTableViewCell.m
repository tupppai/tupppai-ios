//
//  MessageTableViewCell.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 9/1/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

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
    [self.contentView addSubview:self.likeButton];

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
    }];
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_usernameLabel.mas_trailing).with.offset(kPadding15);
        make.top.equalTo(self.contentView).with.offset(kPadding15);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        make.width.equalTo(@(kMessageTableViewCellAvatarHeight*2));
        make.bottom.equalTo(_commentLabel.mas_top);
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.usernameLabel.font = [UIFont boldSystemFontOfSize:16.0];
//    self.commentLabel.font = [UIFont systemFontOfSize:16.0];
}

-(void)getSource:(CommentVM *)vm {
    self.usernameLabel.text = vm.username;
    self.commentLabel.text = vm.text;
    self.likeButton.selected = vm.liked;
    self.likeButton.likeNumber = vm.likeNumber;
    [self.avatarView setImageWithURL:[NSURL URLWithString:vm.avatar] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
}
#pragma mark - Getters
-(CommentLikeButton*)likeButton {
    if (!_likeButton) {
        _likeButton = [CommentLikeButton new];
        }
    return _likeButton;
}
- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.backgroundColor = [UIColor clearColor];
        _usernameLabel.numberOfLines = 0;
        _usernameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _usernameLabel.textColor = [UIColor grayColor];
    }
    return _usernameLabel;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [UILabel new];
        _commentLabel.backgroundColor = [UIColor clearColor];
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
    }
    return _avatarView;
}

@end
