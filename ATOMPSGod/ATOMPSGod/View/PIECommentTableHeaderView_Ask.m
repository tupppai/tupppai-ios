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
#import "PIEWebViewViewController.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
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
    [self addSubview:self.imageViewMain];
    [self addSubview:self.imageViewRight];
//    [self addSubview:self.contentLabel];
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
    
    [self.imageViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self).with.offset(0);
        make.width.equalTo(self).with.priorityHigh();
    }];
    [self.imageViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageViewMain.mas_top);
        make.left.equalTo(self.imageViewMain.mas_right).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self.imageViewMain.mas_bottom).with.offset(0);
    }];
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_imageViewMain.mas_bottom).with.offset(10);
//        //left and right to cause constraint error when self.width = 0;
//        make.left.equalTo(self).with.offset(12);
//        make.right.equalTo(self).with.offset(-12);
//    }];
    
    [self.textView_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewMain.mas_bottom).with.offset(10);
        //left and right would cause constraint error when self.width = 0;
        make.left.equalTo(self).with.offset(8);
        make.right.equalTo(self).with.offset(-12);
    }];

    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        make.left.equalTo(self).with.offset(12);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentButton);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        make.left.equalTo(self.commentButton.mas_right).with.offset(6);
    }];
    [self.bangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView_content.mas_bottom).with.offset(12).with.priorityHigh();
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
        make.height.equalTo(@0.3);
        make.bottom.equalTo(self);
        make.top.equalTo(self.bangView.mas_bottom).with.offset(5);
    }];
}



-(void)setVm:(PIEPageVM *)vm {
    _vm = vm;
    if (vm) {
        [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        _usernameLabel.text = vm.username;
        _timeLabel.text = vm.publishTime;
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

            [_imageViewMain setImageWithURL:[NSURL URLWithString:imgEntity1.url] placeholderImage:[UIImage imageNamed:@"cellBG"]];
            [_imageViewRight setImageWithURL:[NSURL URLWithString:imgEntity2.url] placeholderImage:[UIImage imageNamed:@"cellBG"]];
        }
        else {
            [_imageViewMain setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellBG"]];
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
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, attrStr.length)];
        _textView_content.attributedText = attrStr;
    }
    else {
        _imageViewMain.image = [UIImage imageNamed:@"cellBG"];
    }
    
    CGSize size = [self.textView_content sizeThatFits:CGSizeMake(SCREEN_WIDTH-24, CGFLOAT_MAX)];
    [self.textView_content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height)).with.priorityHigh();
    }];
    
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
        _imageViewMain.backgroundColor= [ UIColor groupTableViewBackgroundColor];
    }
    return _imageViewMain;
}
-(UIImageView*)imageViewRight {
    if (!_imageViewRight) {
        _imageViewRight = [UIImageView new];
        //        _imageViewMain.contentMode = UIViewContentModeScaleAspectFit;
        //        _imageViewMain.clipsToBounds = YES;
        _imageViewRight.userInteractionEnabled = YES;
        _imageViewRight.backgroundColor= [ UIColor groupTableViewBackgroundColor];
    }
    return _imageViewRight;
}
- (PIETextView_linkDetection *)textView_content {
    if (!_textView_content) {
        _textView_content = [PIETextView_linkDetection new];
        _textView_content.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
        _textView_content.font = [UIFont systemFontOfSize:15];
    }
    return _textView_content;
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
















@end
