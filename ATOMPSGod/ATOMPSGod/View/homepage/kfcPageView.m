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
    //use self.property ，not _property
    [self addSubview:self.topView];
    [self addSubview:self.imageViewMain];
    [self addSubview:self.bottomView];
    //    [self addSubview:self.lineView];
    [self configMansory];
}

- (void)configMansory {
    [self configMansoryViews];
    [self configMansoryTopView];
    [self configMansorybottomView];
}

- (void) configMansoryViews {
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(kPadding15);
        make.right.equalTo(self).with.offset(-kPadding15);
        make.height.equalTo(@(kfcTopViewHeight));
    }];
    [_imageViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).with.offset(0);
        make.left.equalTo(self).with.offset(kPadding15);
        make.right.equalTo(self).with.offset(-kPadding15);
        make.height.lessThanOrEqualTo(@(kfcImageHeightMax)).with.priorityLow();
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewMain.mas_bottom).with.offset(0);
        make.left.equalTo(self).with.offset(kPadding15);
        make.right.equalTo(self).with.offset(-kPadding15);
        make.height.equalTo(@(kfcBottomViewHeight));
        make.bottom.equalTo(self).with.offset(0);
    }];
}

- (void) configMansoryTopView {
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topView).with.offset(0);
        make.left.equalTo(_topView).with.offset(0);
        make.width.equalTo(@(kfcAvatarWidth));
        make.height.equalTo(@(kfcAvatarWidth));
    }];
    
    [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topView).with.offset(0);
        make.left.equalTo(_avatarView.mas_right).with.offset(kPadding15);
    }];
    
    [_psView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topView).with.offset(0);
        make.right.equalTo(_topView).with.offset(0);
        make.width.equalTo(@(kfcPSWidth));
        make.height.equalTo(@(kfcPSHeight));
    }];
}

- (void) configMansorybottomView {
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView);
        make.left.equalTo(_bottomView).with.offset(0);
        make.width.equalTo(@(kfcButtonWidth));
        make.height.equalTo(@(kfcButtonHeight));
    }];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView);
        make.right.equalTo(_wechatButton.mas_leading).with.offset(-kPadding10);
        make.height.equalTo(@(kfcButtonHeight));
    }];
    [_wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView);
        make.right.equalTo(_commentButton.mas_leading).with.offset(-kPadding10);
        make.height.equalTo(@(kfcButtonHeight));
    }];
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView);
        make.right.equalTo(_bottomView).with.offset(-2);
        make.height.equalTo(@(kfcButtonHeight));
    }];
}

-(void)setVm:(DDCommentPageVM *)vm {
    _usernameLabel.text = vm.userName;
    [_avatarView setImageWithURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _likeButton.number = vm.likeNumber;
    _likeButton.selected = vm.liked;
    _wechatButton.number = vm.shareNumber;
    _commentButton.number = vm.commentNumber;
    [_imageViewMain mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(vm.height)).with.priorityHigh();
    }];
    [super updateConstraints];
    
    if (vm.pageImage) {
        _imageViewMain.image = vm.pageImage;
    } else {
        [_imageViewMain setImageWithURL:[NSURL URLWithString:vm.pageImageURL] placeholderImage:[UIImage imageNamed:@"placeholderImage_1"]];
    }
    [self addTipLabel:vm];
}
- (void)addTipLabel:(DDCommentPageVM*)vm {
    //    移除旧的标签
    for (UIView * subView in _imageViewMain.subviews) {
        if ([subView isKindOfClass:[ATOMTipButton class]]) {
            ATOMTipButton *button = (ATOMTipButton *)subView;
            [button removeFromSuperview];
        }
    }
    for (DDTipLabelVM *labelViewModel in vm.labelArray) {
        CGRect labelFrame = [labelViewModel getFrame:CGSizeMake(vm.width, vm.height)];
        ATOMTipButton * button = [[ATOMTipButton alloc] initWithFrame:labelFrame];
        if (labelViewModel.labelDirection == 0) {
            button.type = ATOMTipButtonTypeLeft;
        } else {
            button.type = ATOMTipButtonTypeRight;
        }
        button.buttonText = labelViewModel.content;
        [_imageViewMain addSubview:button];
    }
}


-(UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor clearColor];
        _psView = [UIImageView new];
        _psView.contentMode = UIViewContentModeTopRight;
        _psView.image = [UIImage imageNamed:@"btn_p_normal"];
        _psView.userInteractionEnabled = YES;
        [_topView addSubview:_psView];
        [_topView addSubview:self.avatarView];
        [_topView addSubview:self.usernameLabel];
    }
    return _topView;
}
-(UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor clearColor];
        _likeButton = [kfcButton new];
        _likeButton.image = [UIImage imageNamed:@"btn_comment_like_normal"];
        _wechatButton = [kfcButton new];
        _wechatButton.image = [UIImage imageNamed:@"icon_share_normal"];
        _commentButton = [kfcButton new];
        _commentButton.image = [UIImage imageNamed:@"icon_comment_normal"];
        _moreButton= [UIButton new];
        [_moreButton setImage:[UIImage imageNamed:@"icon_others_normal"] forState:UIControlStateNormal];
        [_bottomView addSubview:_moreButton];
        [_bottomView addSubview:_likeButton];
        [_bottomView addSubview:_wechatButton];
        [_bottomView addSubview:_commentButton];
    }
    return _bottomView;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [kAvatarView new];
        _avatarView.userInteractionEnabled = YES;
    }
    return _avatarView;
}

- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [kUsernameLabel new];
        _usernameLabel.userInteractionEnabled = YES;
    }
    return _usernameLabel;
}

-(UIImageView*)imageViewMain {
    if (!_imageViewMain) {
        _imageViewMain = [kImageView new];
        _imageViewMain.image = [UIImage imageNamed:@"placeholderImage_1"];
        _imageViewMain.userInteractionEnabled = YES;
    }
    return _imageViewMain;
}

























@end
