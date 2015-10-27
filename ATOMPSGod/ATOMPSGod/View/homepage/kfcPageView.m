//
//  kfcPageView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "kfcPageView.h"

#import "kfcButton.h"
#import "ATOMTipButton.h"
#import "DDTipLabelVM.h"
#import "kfcViews.h"
#define MAXHEIGHT (SCREEN_WIDTH-kPadding15*2)*4/3

@interface kfcPageView ()

@end

@implementation kfcPageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configSubviews];
    }
    return self;
}
- (void)configSubviews {
    [self addSubview:self.avatarView];
    [self addSubview:self.usernameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.imageViewMain];
    [self addSubview:self.contentLabel];
    [self addSubview:self.commentButton];
    [self addSubview:self.shareButton];
    [self addSubview:self.bangView];
    [self addSubview:self.likeButton];

    [self configMansory];
}

- (void)configMansory {
    [self configMansoryViews];

}

- (void) configMansoryViews {
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self).with.offset(12);
        make.width.equalTo(@(kfcAvatarWidth));
        make.height.equalTo(@(kfcAvatarWidth));
    }];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarView).with.offset(3);
        make.left.equalTo(_avatarView.mas_right).with.offset(9);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_usernameLabel.mas_bottom).with.offset(3);
        make.left.equalTo(_avatarView.mas_right).with.offset(9);
    }];
    
    [_imageViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
//        make.height.equalTo(@(SCREEN_WIDTH));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewMain.mas_bottom).with.offset(10);
        make.left.equalTo(self).with.offset(12).with.priorityMedium();
        make.right.equalTo(self).with.offset(-12).with.priorityMedium();
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(12);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        make.left.equalTo(self).with.offset(12);
        make.bottom.equalTo(self).with.offset(-15);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentButton);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        make.left.equalTo(self.commentButton.mas_right).with.offset(6);
    }];
    [self.bangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentButton).with.priorityMedium();
        make.width.equalTo(@25);
        make.height.equalTo(@40);
        make.right.equalTo(self).with.offset(-10);
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentButton);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
        make.right.equalTo(self).with.offset(0);
    }];
    
}



-(void)setVm:(DDPageVM *)vm {
    if (vm) {
        [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
        _usernameLabel.text = vm.username;
        _timeLabel.text = vm.publishTime;
        [_imageViewMain setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
        CGFloat height = vm.imageHeight/vm.imageWidth *SCREEN_WIDTH;
        if (height > 100) {
            [_imageViewMain mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(height));
            }];
        } else {
            _imageViewMain.contentMode = UIViewContentModeScaleAspectFit;
        }

        _commentButton.numberString = vm.commentCount;
        _shareButton.numberString = vm.shareCount;
        _contentLabel.text = vm.content;
        _likeButton.numberString = vm.likeCount;
        _likeButton.highlighted = vm.liked;
        if (vm.type == PIEPageTypeAsk) {
            _bangView.hidden = NO;
            _likeButton.hidden = YES;
        } else {
            _bangView.hidden = YES;
            _likeButton.hidden = NO;
        }
    }
    else {
        _bangView.hidden = YES;
        _likeButton.hidden = YES;
        _imageViewMain.image = [UIImage imageNamed:@"cellBG"];
    }
}




- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.userInteractionEnabled = YES;
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = 17.5;
    }
    return _avatarView;
}

- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.userInteractionEnabled = YES;
        _usernameLabel.textColor = [UIColor darkGrayColor];
        _usernameLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _usernameLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.userInteractionEnabled = YES;
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:10.0];
    }
    return _timeLabel;
}

-(UIImageView*)imageViewMain {
    if (!_imageViewMain) {
        _imageViewMain = [UIImageView new];
//        _imageViewMain.contentMode = UIViewContentModeScaleAspectFit;
//        _imageViewMain.clipsToBounds = YES;
        _imageViewMain.userInteractionEnabled = YES;
    }
    return _imageViewMain;
}
-(UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont boldSystemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

-(PIEPageButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [PIEPageButton new];
        _commentButton.imageView.image = [UIImage imageNamed:@"hot_comment"];
    }
    return _commentButton;
}
-(PIEPageButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [PIEPageButton new];
        _shareButton.imageView.image = [UIImage imageNamed:@"hot_share"];
    }
    return _shareButton;
}

-(PIEBangView *)bangView {
    if (!_bangView) {
        _bangView = [PIEBangView new];
    }
    return _bangView;
}
-(PIEPageLikeButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [PIEPageLikeButton new];
    }
    return _likeButton;
}





















@end
