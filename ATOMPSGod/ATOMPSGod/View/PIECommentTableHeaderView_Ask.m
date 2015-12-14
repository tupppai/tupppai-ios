//
//  kfcPageView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "PIECommentTableHeaderView_Ask.h"
//#import "ATOMTipButton.h"
//#import "DDTipLabelVM.h"
#import "PIEImageEntity.h"
#import "FXBlurView.h"


#define MAXHEIGHT (SCREEN_WIDTH-kPadding15*2)*4/3

@interface PIECommentTableHeaderView_Ask ()

@end

@implementation PIECommentTableHeaderView_Ask

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
    [self addSubview:self.followButton];
    [self addSubview:self.imageViewBlur];
    [self addSubview:self.imageViewMain];
    [self addSubview:self.imageViewRight];
    [self addSubview:self.textView_content];
    [self addSubview:self.commentButton];
    [self addSubview:self.shareButton];
    [self addSubview:self.bangView];
    [self configMansory];
}

- (void)configMansory {
    [self configMansoryViews];
}

- (void) configMansoryViews {
    //to avoid contraints break warning since self.width = 0 initially and we should set the leading and trailing of imageView.
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-12);
        make.width.equalTo(@(32));
        make.height.equalTo(@(32));
    }];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarView).with.offset(0);
        make.right.equalTo(_avatarView.mas_left).with.offset(-9);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_usernameLabel.mas_bottom).with.offset(3);
        make.right.equalTo(_usernameLabel.mas_right).with.offset(0);
    }];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@58);
        make.height.equalTo(@28);
        make.centerY.equalTo(self.avatarView);
        make.left.equalTo(self).with.offset(12);
    }];
    [self.imageViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self).with.offset(0);
        make.width.equalTo(self).with.priorityHigh();
        make.height.equalTo(self.imageViewMain.mas_width);
    }];
    [self.imageViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageViewMain.mas_top);
        make.left.equalTo(self.imageViewMain.mas_right).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self.imageViewMain.mas_bottom).with.offset(0);
    }];
    [self.imageViewBlur mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageViewMain);
        make.bottom.equalTo(self.imageViewMain);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.textView_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewMain.mas_bottom).with.offset(5);
        //left and right would cause constraint error when self.width = 0;
        make.left.equalTo(self).with.offset(8);
        make.right.equalTo(self).with.offset(-12);
    }];

    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40).with.priorityMedium();
        make.width.greaterThanOrEqualTo(@40);
        make.height.equalTo(@25);
        make.left.equalTo(self).with.offset(15);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentButton);
        make.width.equalTo(@40).with.priorityMedium();
        make.width.greaterThanOrEqualTo(@40);
        make.height.equalTo(@25);
        make.left.equalTo(self.commentButton.mas_right).with.offset(18);
    }];
    [self.bangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView_content.mas_bottom).with.offset(6).with.priorityHigh();
        make.centerY.equalTo(self.commentButton).with.priorityMedium();
        make.width.equalTo(@25);
        make.height.equalTo(@40);
        make.right.equalTo(self).with.offset(-20);
    }];

    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.bangView.mas_bottom).with.offset(5);
        make.bottom.equalTo(self);
    }];
}



-(void)setVm:(PIEPageVM *)vm {
    _vm = vm;
    if (vm) {
        [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        _usernameLabel.text = vm.username;
        _timeLabel.text = vm.publishTime;
        _followButton.selected = vm.followed;
        
        if (vm.thumbEntityArray.count == 2) {
            _imageViewMain.contentMode = UIViewContentModeScaleAspectFill;
            _imageViewRight.contentMode = UIViewContentModeScaleAspectFill;
            _imageViewMain.clipsToBounds = YES;
            _imageViewRight.clipsToBounds = YES;
            
            PIEImageEntity* imgEntity1 = vm.thumbEntityArray[0];
            PIEImageEntity* imgEntity2 = vm.thumbEntityArray[1];
            [_imageViewMain mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self).with.multipliedBy(0.5).with.priorityHigh();
                make.height.equalTo(@(SCREEN_WIDTH)).with.priorityHigh();
            }];

            [_imageViewMain setImageWithURL:[NSURL URLWithString:imgEntity1.url] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
            [_imageViewRight setImageWithURL:[NSURL URLWithString:imgEntity2.url] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
        }
        else {
//            [_imageViewMain setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
            [DDService downloadImage:vm.imageURL withBlock:^(UIImage *image) {
                _imageViewBlur.image = [image blurredImageWithRadius:80 iterations:1 tintColor:[UIColor blackColor]];
                _imageViewMain.image = image;
            }];
            CGFloat height = vm.imageHeight/vm.imageWidth *SCREEN_WIDTH;
            if (height > 100) {
                [_imageViewMain mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(height));
                }];
            } else {
                _imageViewMain.contentMode = UIViewContentModeScaleAspectFit;
            }
        }
        _commentButton.numberString = vm.commentCount;
        _shareButton.numberString = vm.shareCount;
        
        NSString * htmlString = vm.content;
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont lightTupaiFontOfSize:15] range:NSMakeRange(0, attrStr.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x000000 andAlpha:0.9] range:NSMakeRange(0, attrStr.length)];

        _textView_content.attributedText = attrStr;
    }
    else {
        _imageViewMain.image = [UIImage imageNamed:@"cellHolder"];
    }
    
    CGSize size = [self.textView_content sizeThatFits:CGSizeMake(SCREEN_WIDTH-24, CGFLOAT_MAX)];
    [self.textView_content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height)).with.priorityHigh();
    }];
}

//
//_button_name.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//_label_time.textAlignment = NSTextAlignmentRight;
//
//[_button_avatar setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.9] forState:UIControlStateNormal];
//[_button_avatar.titleLabel setFont:[UIFont lightTupaiFontOfSize:13]];
//[_label_time setTintColor:[UIColor colorWithHex:0x000000 andAlpha:0.4]];
//[_label_time setFont:[UIFont lightTupaiFontOfSize:10]];
- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.userInteractionEnabled = YES;
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = 16;
    }
    return _avatarView;
}

- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.userInteractionEnabled = YES;
        _usernameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.9];
        _usernameLabel.font = [UIFont lightTupaiFontOfSize:13];
    }
    return _usernameLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.userInteractionEnabled = YES;
        _timeLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.4];
        _timeLabel.font = [UIFont lightTupaiFontOfSize:10];
    }
    return _timeLabel;
}
-(UIImageView*)imageViewBlur {
    if (!_imageViewBlur) {
        _imageViewBlur = [UIImageView new];
        _imageViewBlur.contentMode = UIViewContentModeScaleAspectFill;
        _imageViewBlur.clipsToBounds = YES;
    }
    return _imageViewBlur;
}
-(UIImageView*)imageViewMain {
    if (!_imageViewMain) {
        _imageViewMain = [UIImageView new];
        _imageViewMain.userInteractionEnabled = YES;
        _imageViewMain.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageViewMain;
}
-(UIImageView*)imageViewRight {
    if (!_imageViewRight) {
        _imageViewRight = [UIImageView new];
        _imageViewRight.userInteractionEnabled = YES;
        _imageViewRight.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageViewRight;
}
- (PIETextView_linkDetection *)textView_content {
    if (!_textView_content) {
        _textView_content = [PIETextView_linkDetection new];
//        _textView_content.delegate = self;
    }
    return _textView_content;
}

-(PIEPageButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [PIEPageButton new];
        _commentButton.imageView.image = [UIImage imageNamed:@"hot_comment"];
        _commentButton.imageSize = CGSizeMake(16, 16);
    }
    return _commentButton;
}
-(PIEPageButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [PIEPageButton new];
        _shareButton.imageView.image = [UIImage imageNamed:@"hot_share"];
        _shareButton.imageSize = CGSizeMake(16, 16);
    }
    return _shareButton;
}



-(PIEBangView *)bangView {
    if (!_bangView) {
        _bangView = [PIEBangView new];
    }
    return _bangView;
}


-(UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton new];
        _followButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_followButton setImage:[UIImage imageNamed:@"new_reply_follow"] forState:UIControlStateNormal];
        [_followButton setImage:[UIImage imageNamed:@"new_reply_followed"] forState:UIControlStateHighlighted];
        [_followButton setImage:[UIImage imageNamed:@"new_reply_followed"] forState:UIControlStateSelected];
        [_followButton addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}
-(void)follow:(UIButton*)followView {
    
    followView.selected = !followView.selected;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_vm.userID) forKey:@"uid"];
    if (followView.selected) {
        [param setObject:@1 forKey:@"status"];
    }
    else {
        [param setObject:@0 forKey:@"status"];
    }
    
    [DDService follow:param withBlock:^(BOOL success) {
        if (success) {
            _vm.followed = followView.selected;
        } else {
            followView.selected = !followView.selected;
        }
    }];
}



@end
