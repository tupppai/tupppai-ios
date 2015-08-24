//
//  kfcDetailCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "kfcDetailCell.h"
#import "ATOMCommentViewModel.h"
#import "ATOMHotDetailPageViewModel.h"
#import "ATOMTipButton.h"
#import "ATOMImageTipLabelViewModel.h"
#import "ATOMBottomCommonButton.h"


#define MAXHEIGHT (SCREEN_WIDTH-kPadding15*2)*4/3

@interface kfcDetailCell ()
@end

@implementation kfcDetailCell


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
    [self.contentView addSubview:self.additionView];
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.gapView];
    [self configMansory];
}

- (void)configMansory {
    [self configMansoryViews];
    [self configMansoryTopView];
    [self configMansorybottomView];
//    [self configMansoryAdditionView];
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
        make.height.equalTo(@(kfcBottomViewHeight));
        make.bottom.equalTo(_lineView.mas_top).with.offset(0);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(kPadding15);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        make.height.equalTo(@1);
        make.bottom.equalTo(_additionView.mas_top).with.offset(0);
    }];
    [_additionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(kPadding15);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
    }];
    [_gapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_additionView.mas_bottom).with.offset(0);
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
        make.top.equalTo(_avatarView).with.offset(0);
        make.left.equalTo(_avatarView.mas_right).with.offset(kPadding15);
    }];
    [_publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_avatarView).with.offset(0);
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

- (void)configCell:(ATOMHotDetailPageViewModel *)viewModel {
    _usernameLabel.text = viewModel.userName;
    [_avatarView setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _publishTimeLabel.text = viewModel.publishTime;
    _likeButton.number = viewModel.likeNumber;
    _likeButton.selected = viewModel.liked;
    _wechatButton.number = viewModel.shareNumber;
    _commentButton.number = viewModel.commentNumber;
    [_imageViewMain mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(viewModel.height)).with.priorityHigh();
    }];
    [super updateConstraints];
    
    if (viewModel.image) {
        _imageViewMain.image = viewModel.image;
    } else {
        [_imageViewMain setImageWithURL:[NSURL URLWithString:viewModel.userImageURL] placeholderImage:[UIImage imageNamed:@"placeholderImage_1"]];
    }
    [self addTipLabel:viewModel];
    if (viewModel.commentArray.count == 0) {
        [_commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
        [_commentLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
        [_commentLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
    } else if (viewModel.commentArray.count == 1) {
        [_commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_additionView).with.offset(kPadding15);
            make.left.equalTo(_additionView).with.offset(0);
            make.height.equalTo(@17);
            make.width.equalTo(@15);
        }];
        [_commentLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_additionView).with.offset(12);
            make.left.equalTo(_commentView.mas_right).with.offset(10);
            make.right.equalTo(_additionView.mas_right).with.offset(-1);
            make.bottom.equalTo(_additionView).with.offset(-10);
        }];
        [_commentLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];

    } else {
        [_commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_additionView).with.offset(kPadding15);
            make.left.equalTo(_additionView).with.offset(0);
            make.height.equalTo(@17);
            make.width.equalTo(@15);
        }];
        [_commentLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_additionView).with.offset(10);
            make.left.equalTo(_commentView.mas_right).with.offset(10);
            make.right.equalTo(_additionView.mas_right).with.offset(-1);
        }];
        [_commentLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentLabel1.mas_bottom).with.offset(8).with.priorityHigh();
            make.left.equalTo(_commentView.mas_right).with.offset(10);
            make.bottom.equalTo(_additionView).with.offset(-10);
            make.right.equalTo(_additionView.mas_right).with.offset(-1);
        }];
    }
    for (int i = 0; i < viewModel.commentArray.count; i++) {
        ATOMCommentViewModel *commentViewModel = viewModel.commentArray[i];
        NSDictionary* info = [[NSDictionary alloc]initWithObjectsAndKeys:commentViewModel.nickname,@"username",commentViewModel.content,@"comment", nil];
        if (i == 0) {
            _commentLabel1.info = info;
        } else if (i == 1) {
            _commentLabel2.info = info;
        }
    }
}
-(void)prepareForReuse {
    
//    [_commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeZero);
//    }];
//    [_commentLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeZero);
//    }];
//    [_commentLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeZero);
//    }];

}
- (void)addTipLabel:(ATOMHotDetailPageViewModel*)vm {
    
    //    移除旧的标签
    for (UIView * subView in _imageViewMain.subviews) {
        if ([subView isKindOfClass:[ATOMTipButton class]]) {
            ATOMTipButton *button = (ATOMTipButton *)subView;
            [button removeFromSuperview];
        }
    }

    for (ATOMImageTipLabelViewModel *labelViewModel in vm.labelArray) {
        CGRect labelFrame = [labelViewModel imageTipLabelFrameByImageSize:CGSizeMake(vm.width, vm.height)];
        ATOMTipButton * button = [[ATOMTipButton alloc] initWithFrame:labelFrame];
        if (labelViewModel.labelDirection == 0) {
            button.tipButtonType = ATOMLeftTipType;
        } else {
            button.tipButtonType = ATOMRightTipType;
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
        [_topView addSubview:self.publishTimeLabel];
        
    }
    return _topView;
}
-(UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor clearColor];
        _likeButton = [ATOMBottomCommonButton new];
        _likeButton.image = [UIImage imageNamed:@"btn_comment_like_normal"];
        _wechatButton = [ATOMBottomCommonButton new];
        _wechatButton.image = [UIImage imageNamed:@"icon_share_normal"];
        _commentButton = [ATOMBottomCommonButton new];
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
- (UILabel *)publishTimeLabel
{
    if (!_publishTimeLabel) {
        _publishTimeLabel = [kPublishTimeLabel new];
        _publishTimeLabel.font = [UIFont kfcPublishTimeSmall];
    }
    return _publishTimeLabel;
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
-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHex:0xededed andAlpha:0.5];
    }
    return _lineView;
}

-(UIView *)additionView {
    if (!_additionView) {
        _additionView = [UIView new];
        _additionView.backgroundColor = [UIColor clearColor];
        [_additionView addSubview:self.commentView];
        [_additionView addSubview:self.commentLabel1];
        [_additionView addSubview:self.commentLabel2];
    }
    return _additionView;
}
- (UIImageView *)commentView
{
    if (!_commentView) {
        _commentView = [UIImageView new];
        _commentView.image = [UIImage imageNamed:@"ic_comment"];
        _commentView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _commentView;
}

- (kfcCommentLabel *)commentLabel1
{
    if (!_commentLabel1) {
        _commentLabel1 = [kfcCommentLabel new];
    }
    return _commentLabel1;
}
- (kfcCommentLabel *)commentLabel2
{
    if (!_commentLabel2) {
        _commentLabel2 = [kfcCommentLabel new];
    }
    return _commentLabel2;
}












@end