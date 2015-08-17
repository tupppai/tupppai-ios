//
//  kfcHotCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "kfcHotCell.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMTipButton.h"
#import "ATOMImageTipLabelViewModel.h"
#import "ATOMReplierViewModel.h"
#import "ATOMBottomCommonButton.h"
#import "kfcViews.h"
//#define MAXHEIGHT (SCREEN_WIDTH-kPadding15*2)*4/3

@interface kfcHotCell ()
@end

@implementation kfcHotCell


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
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.additionView];
    [self.contentView addSubview:self.gapView];
    [self configMansory];
}

- (void)configMansory {
    [self configMansoryViews];
    [self configMansoryTopView];
    [self configMansorybottomView];
    [self configMansoryAdditionView];
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
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(kPadding15);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        make.height.equalTo(@(1));
        make.bottom.equalTo(_additionView.mas_top).with.offset(0);
    }];
    [_additionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(kPadding15);
        make.right.equalTo(self.contentView).with.offset(-kPadding15);
        //change height var and name of _additionView
        make.height.equalTo(@(kfcAddtionViewHeight));
    }];
    [_gapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_additionView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        //change height var and name of _additionView
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
    
    [_publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topView).with.offset(0);
        make.right.equalTo(_topView).with.offset(0);
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
//        make.width.greaterThanOrEqualTo(@(kfcButtonWidth));
    }];
    
    [_wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView);
        make.right.equalTo(_commentButton.mas_leading).with.offset(-kPadding10);
        make.height.equalTo(@(kfcButtonHeight));
//        make.width.greaterThanOrEqualTo(@(kfcButtonWidth));
    }];
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView);
        make.right.equalTo(_bottomView).with.offset(-2);
        make.height.equalTo(@(kfcButtonHeight));
//        make.width.greaterThanOrEqualTo(@(kfcButtonWidth));
    }];
    
}
- (void) configMansoryAdditionView {
    [_totalPSLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_additionView).with.offset(0);
        make.left.equalTo(_additionView).with.offset(0);
        make.height.equalTo(@(kfcReplierWidth));
    }];
}




- (void)configCell:(ATOMAskPageViewModel *)viewModel {
    _usernameLabel.text = viewModel.userName;
    [_avatarView setImageWithURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    
    _publishTimeLabel.text = viewModel.publishTime;
    _likeButton.number = viewModel.likeNumber;
    _likeButton.selected = viewModel.liked;
    _wechatButton.number = viewModel.shareNumber;
    _commentButton.number = viewModel.commentNumber;
    _totalPSLabel.number = viewModel.totalPSNumber;

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
    [self addReplier:viewModel];

}
- (void)addTipLabel:(ATOMAskPageViewModel*)vm {
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

- (void)addReplier:(ATOMAskPageViewModel*)vm {
    _repliers = [NSMutableArray array];
    NSInteger min = MIN(vm.replierArray.count, kfcReplierDefaultQuantity);
    for (int i = 0; i < min; i++) {
        ATOMReplierViewModel *replierViewModel = vm.replierArray[i];
        kReplierView* replier = [kReplierView new];
        [_additionView addSubview:replier];
        [replier setImageWithURL:[NSURL URLWithString:replierViewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
        CGFloat offset = -i * (kfcReplierWidth + kPadding5);
        [replier mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_additionView).with.offset(0);
            make.right.equalTo(_additionView).with.offset(offset);
        }];
        if (i == min - 1) {
            [_totalPSLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(replier.mas_left).with.offset(-kPadding5).with.priorityHigh();
            }];
            [super updateConstraints];
        }
    }
    _repliers = nil;
}

-(UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor clearColor];
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
        _totalPSLabel = [ATOMTotalPSView new];
        [_additionView addSubview:_totalPSLabel];
    }
    return _additionView;
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

@end
