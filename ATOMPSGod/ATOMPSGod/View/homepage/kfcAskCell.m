//
//  kfcAskCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "kfcAskCell.h"
#import "ATOMTipButton.h"
#import "DDTipLabelVM.h"
#import "kfcButton.h"
#import "kfcViews.h"
//#define MAXHEIGHT (SCREEN_WIDTH-kPadding15*2)*4/3

@interface kfcAskCell ()

@end

@implementation kfcAskCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //ios7.1 auto layout height issue
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews {
    //use self.property ，not _property
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.imageViewMain];
    [self.contentView addSubview:self.bottomView];
//    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.gapView];
    [self configMansory];
}

- (void)configMansory {
    [self configMansoryViews];
    [self configMansoryTopView];
    [self configMansorybottomView];
}

- (void) configMansoryViews {
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(kPadding15);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        make.height.equalTo(@(kfcTopViewHeight));
    }];
    [_imageViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(kPadding15);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        make.height.lessThanOrEqualTo(@(kfcImageHeightMax));
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewMain.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(kPadding15);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        //todo :change height var and name of _additionView
        make.height.equalTo(@(kfcBottomViewHeight));
    }];

    [_gapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.equalTo(@(kfcGapViewHeight));
        make.bottom.equalTo(self.contentView).with.offset(0);
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

- (void)configCell:(DDPageVM *)viewModel {
    _usernameLabel.text = viewModel.username;
    [_avatarView setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _likeButton.number = viewModel.likeCount;
    _likeButton.selected = viewModel.liked;
    _wechatButton.number = viewModel.shareCount;
    _commentButton.number = viewModel.commentNumber;
    [_imageViewMain mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(viewModel.height)).with.priorityHigh();
    }];
    [super updateConstraints];
    
    if (viewModel.image) {
        _imageViewMain.image = viewModel.image;
    } else {
        [_imageViewMain setImageWithURL:[NSURL URLWithString:viewModel.imageURL] placeholderImage:[UIImage imageNamed:@"placeholderImage_1"]];
    }
    [self addTipLabel:viewModel];
}

- (void)addTipLabel:(DDPageVM*)vm {
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
        _moreButton.userInteractionEnabled = NO;
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
    }
    return _avatarView;
}

- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [kUsernameLabel new];
    }
    return _usernameLabel;
}

-(UIView*)gapView {
    if (!_gapView) {
        _gapView = [kGapView new];
    }
    return _gapView;
}

-(UIImageView*)imageViewMain {
    if (!_imageViewMain) {
        _imageViewMain = [kImageView new];
        _imageViewMain.image = [UIImage imageNamed:@"placeholderImage_1"];
    }
    return _imageViewMain;
}




@end
