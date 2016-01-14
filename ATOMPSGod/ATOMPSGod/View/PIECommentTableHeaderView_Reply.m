//
//  PIECommentTableHeaderView_Reply.m
//  TUPAI
//
//  Created by chenpeiwei on 11/10/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECommentTableHeaderView_Reply.h"
#import "PIEModelImage.h"
#import "FXBlurView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#define MAXHEIGHT (SCREEN_WIDTH-kPadding15*2)*4/3

@interface PIECommentTableHeaderView_Reply ()

@end

@implementation PIECommentTableHeaderView_Reply

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
//    [self addSubview:self.imageViewRight];
    [self addSubview:self.textView_content];
    [self addSubview:self.commentButton];
    [self addSubview:self.shareButton];
    [self addSubview:self.likeButton];
    [self addSubview:self.moreWorkButton];
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
//        make.width.equalTo(self).with.priorityHigh();
        make.right.equalTo(self).with.offset(0);

        make.height.equalTo(self.imageViewMain.mas_width);
    }];
    
    [self.imageViewBlur mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageViewMain);
        make.bottom.equalTo(self.imageViewMain);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.textView_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewMain.mas_bottom).with.offset(5);
        //left and right to cause constraint error when self.width = 0;
        make.left.equalTo(self).with.offset(8);
        make.right.equalTo(self).with.offset(-12);
    }];
    
    [self.moreWorkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentButton);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        make.left.equalTo(self).with.offset(11);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView_content.mas_bottom).with.offset(6).with.priorityLow();
        make.width.equalTo(@40).with.priorityMedium();
        make.width.greaterThanOrEqualTo(@40);
        make.height.equalTo(@30);
        make.left.equalTo(self.moreWorkButton.mas_right).with.offset(18);
//        make.bottom.equalTo(self).with.offset(-15);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareButton);
        make.width.equalTo(@40).with.priorityMedium();
        make.width.greaterThanOrEqualTo(@40);
        make.height.equalTo(@30);
        make.left.equalTo(self.shareButton.mas_right).with.offset(12);
    }];
  
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentButton);
        make.width.equalTo(@35).priorityHigh();
        make.width.greaterThanOrEqualTo(@35);
        make.height.equalTo(@32);
        make.right.equalTo(self).with.offset(-17);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.likeButton.mas_bottom).with.offset(5);
        make.bottom.equalTo(self);
    }];
    
}



-(void)setVm:(PIEPageVM *)vm {
    if (vm) {
        _vm = vm;
        
        [RACObserve(vm, followed)subscribeNext:^(id x) {
            self.followButton.selected = [x boolValue];
        }];
        
        [_avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        
        _avatarView.isV = vm.isV;
        
        _usernameLabel.text = vm.username;
        _timeLabel.text = vm.publishTime;
        
        if (vm.isMyFan) {
            [_followButton setImage:[UIImage imageNamed:@"pie_mutualfollow"] forState:UIControlStateSelected];
        } else {
            [_followButton setImage:[UIImage imageNamed:@"new_reply_followed"] forState:UIControlStateSelected];
        }
        _followButton.selected = vm.followed;
        
        if (vm.userID == [DDUserManager currentUser].uid) {
            _followButton.hidden = YES;
        } else {
            _followButton.hidden = NO;
        }
        
        [DDService sd_downloadImage:vm.imageURL withBlock:^(UIImage *image) {
            _imageViewBlur.image = [image blurredImageWithRadius:80 iterations:1 tintColor:[UIColor blackColor]];
            _imageViewMain.image = image;
            
            
            NSString* imageUrl2 = [vm.imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
            [DDService sd_downloadImage:imageUrl2 withBlock:^(UIImage *image) {
                _imageViewBlur.image = [image blurredImageWithRadius:80 iterations:1 tintColor:[UIColor blackColor]];
                _imageViewMain.image = image;
            }];

        }];
        

        _commentButton.numberString = vm.commentCount;
        _shareButton.numberString = vm.shareCount;
        [_likeButton initStatus:vm.loveStatus numberString:vm.likeCount];
        
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




- (PIEAvatarView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[PIEAvatarView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        _avatarView.userInteractionEnabled = YES;
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

-(UIImageView*)imageViewMain {
    if (!_imageViewMain) {
        _imageViewMain = [UIImageView new];
        _imageViewMain.contentMode = UIViewContentModeScaleAspectFit;
        _imageViewMain.userInteractionEnabled = YES;
    }
    return _imageViewMain;
}
-(UIImageView*)imageViewBlur {
    if (!_imageViewBlur) {
        _imageViewBlur = [UIImageView new];
        _imageViewBlur.contentMode = UIViewContentModeScaleAspectFill;
        _imageViewBlur.clipsToBounds = YES;
    }
    return _imageViewBlur;
}
//-(UIImageView*)imageViewRight {
//    if (!_imageViewRight) {
//        _imageViewRight = [UIImageView new];
//        _imageViewMain.contentMode = UIViewContentModeScaleAspectFit;
//        //        _imageViewMain.clipsToBounds = YES;
//        _imageViewRight.userInteractionEnabled = YES;
//        _imageViewRight.backgroundColor= [ UIColor groupTableViewBackgroundColor];
//    }
//    return _imageViewRight;
//}
- (PIETextView_linkDetection *)textView_content {
    if (!_textView_content) {
        _textView_content = [PIETextView_linkDetection new];
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

-(PIELoveButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [PIELoveButton new];
        _likeButton.imageSize = CGSizeMake(19,19);
    }
    return _likeButton;
}


-(UIButton *)moreWorkButton {
    if (!_moreWorkButton) {
        _moreWorkButton = [UIButton new];
        [_moreWorkButton setImage:[UIImage imageNamed:@"hot_allwork"] forState:UIControlStateNormal];
        _moreWorkButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _moreWorkButton;
}

-(UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton new];
        _followButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_followButton setImage:[UIImage imageNamed:@"new_reply_follow"] forState:UIControlStateNormal];
        [_followButton setImage:[UIImage imageNamed:@"new_reply_followed"] forState:UIControlStateHighlighted];
        [_followButton setImage:[UIImage imageNamed:@"new_reply_followed"] forState:UIControlStateSelected];
        [_followButton addTarget:self action:@selector(follow) forControlEvents:UIControlEventTouchDown];
    }
    return _followButton;
}
-(void)follow {
    [self.vm follow];
}

@end
