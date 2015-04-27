//
//  ATOMHomePageHotTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHomePageHotTableViewCell.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMTipButton.h"
#import "ATOMImageTipLabelViewModel.h"
#import "ATOMReplierViewModel.h"

@interface ATOMHomePageHotTableViewCell ()

@property (nonatomic, strong) UIView *littleVerticalView1;
@property (nonatomic, strong) UIView *littleVerticalView2;
@property (nonatomic, strong) UIView *littleVerticalView3;
@property (nonatomic, strong) NSMutableArray *replierAvatars;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *totalPSLabel;

@end

@implementation ATOMHomePageHotTableViewCell

static int padding = 10;
static int padding5 = 5;
static int defaultAvatarCount = 7;
static int padding20 = 20;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _topThinView = [UIView new];
    _topThinView.backgroundColor = [UIColor colorWithHex:0xededed];
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    _userWorkImageView = [UIImageView new];
    _thinCenterView = [UIView new];
    _thinCenterView.backgroundColor = [UIColor whiteColor];
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topThinView];
    [self addSubview:_topView];
    [self addSubview:_userWorkImageView];
    [self addSubview:_thinCenterView];
    [self addSubview:_bottomView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont systemFontOfSize:16.f];
    _userNameLabel.textColor = [UIColor blackColor];
    _userPublishTimeLabel = [UILabel new];
    _userPublishTimeLabel.font = [UIFont systemFontOfSize:16.f];
    _userPublishTimeLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
//    _userSexImageView = [UIImageView new];
    
    [_topView addSubview:_userHeaderButton];
    [_topView addSubview:_userNameLabel];
    [_topView addSubview:_userPublishTimeLabel];
//    [_topView addSubview:_userSexImageView];
    
    _praiseButton = [UIButton new];
    [_thinCenterView addSubview:_praiseButton];
    _shareButton = [UIButton new];
    [_thinCenterView addSubview:_shareButton];
    _commentButton = [UIButton new];
    [_thinCenterView addSubview:_commentButton];
    _moreShareButton = [UIButton new];
    [_thinCenterView addSubview:_moreShareButton];
    
    [self setCommonButton:_praiseButton WithImage:[UIImage imageNamed:@"btn_comment_like_normal"]];
    [_praiseButton setImage:[UIImage imageNamed:@"btn_comment_like_pressed"] forState:UIControlStateSelected];
    [self setCommonButton:_shareButton WithImage:[UIImage imageNamed:@"icon_share_normal"]];
    [self setCommonButton:_commentButton WithImage:[UIImage imageNamed:@"icon_comment_normal"]];
    _moreShareButton.userInteractionEnabled = NO;
    [_moreShareButton setImageEdgeInsets:UIEdgeInsetsMake(9.5, 0, 9.5, 34)];
    [_moreShareButton setImage:[UIImage imageNamed:@"icon_others_normal"] forState:UIControlStateNormal];
    [_moreShareButton setImage:[UIImage imageNamed:@"icon_others_pressed"] forState:UIControlStateHighlighted];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithHex:0xededed];
    [_thinCenterView addSubview:_lineView];
    
    _totalPSLabel = [UILabel new];
    _totalPSLabel.textColor = [UIColor blackColor];
    _totalPSLabel.font = [UIFont systemFontOfSize:16.f];
    [_bottomView addSubview:_totalPSLabel];
    
    _replierAvatars = [NSMutableArray array];
    for (int i = 0; i < defaultAvatarCount; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.layer.cornerRadius = 15;
        imageView.layer.masksToBounds = YES;
        [_bottomView addSubview:imageView];
        [_replierAvatars addObject:imageView];
    }
    
//    _littleVerticalView1 = [UIView new];
//    _littleVerticalView2 = [UIView new];
//    _littleVerticalView3 = [UIView new];
//    [self setLittleVerticalView:_littleVerticalView1];
//    [self setLittleVerticalView:_littleVerticalView2];
//    [self setLittleVerticalView:_littleVerticalView3];
    
}

- (void)setLittleVerticalView:(UIView *)view {
    view.backgroundColor = [UIColor colorWithHex:0xededed];
    [_thinCenterView addSubview:view];
}

- (void)setCommonButton:(UIButton *)button WithImage:(UIImage *)image{
//    button.layer.borderColor = [[UIColor colorWithHex:0xededed] CGColor];
//    button.layer.borderWidth = 0.5;
//    button.layer.cornerRadius = 5;
//    button.layer.masksToBounds = YES;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
//    button.backgroundColor = [UIColor orangeColor];
    
    button.userInteractionEnabled = NO;
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(2.5, 0, 2.5, padding5)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(6.5, padding5, 7.5, 0)];
    button.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [button setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0xfe8282] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topThinView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
    _topView.frame = CGRectMake(0, CGRectGetMaxY(_topThinView.frame), SCREEN_WIDTH, 65);
    _userHeaderButton.frame = CGRectMake(padding, padding, 45, 45);
    CGFloat labelOriginY = 7.5;
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, CGRectGetMinY(_userHeaderButton.frame) + labelOriginY, 150, 30);
    _userPublishTimeLabel.frame = CGRectMake(SCREEN_WIDTH - padding - 150, CGRectGetMinY(_userNameLabel.frame), 150, 30);
//    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - SEXRADIUS, CGRectGetMaxY(_userHeaderButton.frame) - SEXRADIUS, SEXRADIUS, SEXRADIUS);
    
    CGSize workImageSize;
    if (_viewModel) {
        workImageSize = [[self class] calculateHomePageHotImageViewSizeWith:_viewModel];
    }
    _userWorkImageView.frame = CGRectMake((SCREEN_WIDTH - workImageSize.width) / 2, CGRectGetMaxY(_topView.frame), workImageSize.width, workImageSize.height);
    
    _thinCenterView.frame = CGRectMake(0, CGRectGetMaxY(_userWorkImageView.frame), SCREEN_WIDTH, 40);
    CGFloat buttonWidth = 60, buttonHeight = 25, buttonOriginY = 7.5;
    _moreShareButton.frame = CGRectMake(padding, buttonOriginY, buttonWidth, buttonHeight);
    _commentButton.frame = CGRectMake(SCREEN_WIDTH - padding - buttonWidth, buttonOriginY, buttonWidth, buttonHeight);
    _praiseButton.frame = CGRectMake(CGRectGetMinX(_commentButton.frame) - padding20 - buttonWidth, buttonOriginY, buttonWidth, buttonHeight);
    _shareButton.frame = CGRectMake(CGRectGetMinX(_praiseButton.frame) - padding20 - buttonWidth, buttonOriginY, buttonWidth, buttonHeight);
    _lineView.frame = CGRectMake(0, CGHeight(_thinCenterView.frame) - 1, SCREEN_WIDTH, 1);
    
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 60);
//    _totalPSButton.frame = CGRectMake(SCREEN_WIDTH - padding - 30, (CGHeight(_bottomView.frame) - 30) / 2, 30, 30);
    CGFloat originX = SCREEN_WIDTH - defaultAvatarCount * (padding + 30) - padding;
    for (int i = 0; i < defaultAvatarCount; i++) {
        UIImageView *imageView = _replierAvatars[i];
        imageView.frame = CGRectMake(padding * (i + 1) + 30 * i + originX, (CGHeight(_bottomView.frame) - 30) / 2, 30, 30);
    }
    UIImageView *firstImageView = [_replierAvatars firstObject];
    _totalPSLabel.frame = CGRectMake(padding, (CGHeight(_bottomView.frame) - 30) / 2, CGRectGetMinX(firstImageView.frame), 30);
}

+ (CGFloat)calculateCellHeightWith:(ATOMHomePageViewModel *)viewModel {
    return 6 + 65 + viewModel.height + 40 + 60;
}

+ (CGSize)calculateHomePageHotImageViewSizeWith:(ATOMHomePageViewModel *)viewModel {
    return CGSizeMake(viewModel.width, viewModel.height);
}

- (void)setViewModel:(ATOMHomePageViewModel *)viewModel {
    _viewModel = viewModel;
    _userNameLabel.text = viewModel.userName;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _userSexImageView.image = [UIImage imageNamed:viewModel.userSex];
    _userPublishTimeLabel.text = viewModel.publishTime;
    [_shareButton setTitle:viewModel.shareNumber forState:UIControlStateNormal];
    [_praiseButton setTitle:viewModel.praiseNumber forState:UIControlStateNormal];
    [_commentButton setTitle:viewModel.commentNumber forState:UIControlStateNormal];
    _totalPSLabel.text = [NSString stringWithFormat:@"%@人·P过", viewModel.totalPSNumber];
    if (viewModel.image) {
        _userWorkImageView.image = viewModel.image;
    } else {
        [_userWorkImageView setImageWithURL:[NSURL URLWithString:viewModel.userImageURL]];
    }
    [self addTipLabelToImageView];
    [self addReplier];
    [self setNeedsLayout];
}

- (void)addTipLabelToImageView {
    //移除旧的标签
    for (UIView * subView in _userWorkImageView.subviews) {
        if ([subView isKindOfClass:[ATOMTipButton class]]) {
            ATOMTipButton *button = (ATOMTipButton *)subView;
            [button removeFromSuperview];
        }
    }
    
    for (ATOMImageTipLabelViewModel *labelViewModel in _viewModel.labelArray) {
        CGRect labelFrame = [labelViewModel imageTipLabelFrameByImageSize:CGSizeMake(_viewModel.width, _viewModel.height)];
        ATOMTipButton * button = [[ATOMTipButton alloc] initWithFrame:labelFrame];
        if (labelViewModel.labelDirection == 0) {
            button.tipButtonType = ATOMLeftTipType;
        } else {
            button.tipButtonType = ATOMRightTipType;
        }
        button.buttonText = labelViewModel.content;
        [_userWorkImageView addSubview:button];
    }
}

- (void)addReplier {
    for (int i = 0; i < defaultAvatarCount; i++) {
        UIImageView *imageView = _replierAvatars[i];
        imageView.hidden = YES;
    }
    for (int i = 0; i < MIN(_viewModel.replierArray.count, defaultAvatarCount); i++) {
        ATOMReplierViewModel *replierViewModel = _viewModel.replierArray[i];
        UIImageView *imageView = _replierAvatars[defaultAvatarCount - MIN(_viewModel.replierArray.count, defaultAvatarCount) + i];
        imageView.hidden = NO;
        [imageView setImageWithURL:[NSURL URLWithString:replierViewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    }
}













@end
