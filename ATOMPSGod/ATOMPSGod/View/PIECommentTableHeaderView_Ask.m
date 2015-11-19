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
    [self addSubview:self.contentLabel];
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
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewMain.mas_bottom).with.offset(10);
        //left and right to cause constraint error when self.width = 0;
        make.left.equalTo(self).with.offset(12);
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
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(12).with.priorityHigh();
        make.centerY.equalTo(self.commentButton).with.priorityMedium();
        make.width.equalTo(@25);
        make.height.equalTo(@40);
        make.right.equalTo(self).with.offset(-10);
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
        NSLog(@"ask1");
        if (vm.thumbEntityArray.count == 2) {
            NSLog(@"ask2");

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
            NSLog(@"%@",imgEntity1.url);
            NSLog(@"%@",imgEntity2.url);

            [_imageViewMain setImageWithURL:[NSURL URLWithString:imgEntity1.url] placeholderImage:[UIImage imageNamed:@"cellBG"]];
            [_imageViewRight setImageWithURL:[NSURL URLWithString:imgEntity2.url] placeholderImage:[UIImage imageNamed:@"cellBG"]];
        }
        else {
            NSLog(@"ask3");

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
        _contentLabel.text = vm.content;
    }
    else {
        _imageViewMain.image = [UIImage imageNamed:@"cellBG"];
    }
    
    NSDictionary *attributes = @{NSFontAttributeName : self.contentLabel.font};
    CGFloat messageLabelHeight = CGRectGetHeight([self.contentLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil]);
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(messageLabelHeight+5)).with.priorityHigh();
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
-(UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
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



















@end
