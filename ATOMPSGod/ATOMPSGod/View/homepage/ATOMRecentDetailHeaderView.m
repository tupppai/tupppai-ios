//
//  ATOMRecentDetailHeaderView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMRecentDetailHeaderView.h"
#import "ATOMHomePageViewModel.h"

@interface ATOMRecentDetailHeaderView ()

@property (nonatomic, strong) UIView *littleVerticalView1;
@property (nonatomic, strong) UIView *littleVerticalView2;
@property (nonatomic, strong) UIView *littleVerticalView3;

@end

@implementation ATOMRecentDetailHeaderView

static int padding = 10;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _topView = [UIView new];
    [self addSubview:_topView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [_topView addSubview:_userHeaderButton];
    
    _userSexImageView = [UIImageView new];
    [_topView addSubview:_userSexImageView];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont systemFontOfSize:16.f];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    _userNameLabel.userInteractionEnabled = YES;
    [_topView addSubview:_userNameLabel];
    
    _userPublishTimeLabel = [UILabel new];
    _userPublishTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _userPublishTimeLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
    [_topView addSubview:_userPublishTimeLabel];
    
    _psButton = [UIButton new];
    [_psButton setBackgroundImage:[UIImage imageNamed:@"btn_p_normal"] forState:UIControlStateNormal];
    [_psButton setBackgroundImage:[UIImage imageNamed:@"btn_p_pressed"] forState:UIControlStateHighlighted];
    [_topView addSubview:_psButton];
    
    _userWorkImageView = [UIImageView new];
    [self addSubview:_userWorkImageView];
    
    _thinCenterView = [UIView new];
    [self addSubview:_thinCenterView];
    
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
    [_moreShareButton setImage:[UIImage imageNamed:@"icon_others_normal"] forState:UIControlStateNormal];
    [_moreShareButton setImage:[UIImage imageNamed:@"icon_others_pressed"] forState:UIControlStateHighlighted];
    
    _littleVerticalView1 = [UIView new];
    _littleVerticalView2 = [UIView new];
    _littleVerticalView3 = [UIView new];
    [self setLittleVerticalView:_littleVerticalView1];
    [self setLittleVerticalView:_littleVerticalView2];
    [self setLittleVerticalView:_littleVerticalView3];
    
}

- (void)setLittleVerticalView:(UIView *)view {
    view.backgroundColor = [UIColor colorWithHex:0xededed];
    [_thinCenterView addSubview:view];
}

- (void)setCommonButton:(UIButton *)button WithImage:(UIImage *)image{
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(3.5, 0, 3.5, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(3.5, padding / 2.0, 3.5, 0)];
    button.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [button setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0x00adef] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);
    _userHeaderButton.frame = CGRectMake(padding, padding, 45, 45);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, padding, 150, 30);
    _userPublishTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, CGRectGetMaxY(_userNameLabel.frame), 150, 15);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - SEXRADIUS, CGRectGetMaxY(_userHeaderButton.frame) - SEXRADIUS, SEXRADIUS, SEXRADIUS);
    _psButton.frame = CGRectMake(SCREEN_WIDTH - padding - 28, 17.5, 28, 28);
    
    CGSize workImageSize;
    if (_viewModel) {
        workImageSize = [[self class] calculateImageViewSizeWith:_viewModel];
    }
    _userWorkImageView.frame = CGRectMake((SCREEN_WIDTH - workImageSize.width) / 2, CGRectGetMaxY(_topView.frame), workImageSize.width, workImageSize.height);
    
    CGFloat buttonInterval = (SCREEN_WIDTH - 4 * 60) / 5;
    _thinCenterView.frame = CGRectMake(0, CGRectGetMaxY(_userWorkImageView.frame), SCREEN_WIDTH, 40);
    _shareButton.frame = CGRectMake(buttonInterval, 7.5, 60, 25);
    _praiseButton.frame = CGRectMake(CGRectGetMaxX(_shareButton.frame) + buttonInterval, 7.5, 60, 25);
    _commentButton.frame = CGRectMake(CGRectGetMaxX(_praiseButton.frame) + buttonInterval, 7.5, 60, 25);
    _moreShareButton.frame = CGRectMake(CGRectGetMaxX(_commentButton.frame) + buttonInterval, 7.5, 60, 25);
    
    CGFloat verticalViewInterval = SCREEN_WIDTH / 4;
    _littleVerticalView1.frame = CGRectMake(verticalViewInterval - 0.25, 7.5, 0.5, 25);
    _littleVerticalView2.frame = CGRectMake(verticalViewInterval * 2 - 0.25, 7.5, 0.5, 25);
    _littleVerticalView3.frame = CGRectMake(verticalViewInterval * 3 - 0.25, 7.5, 0.5, 25);
    
}

+ (CGSize)calculateImageViewSizeWith:(ATOMHomePageViewModel *)viewModel {
    return CGSizeMake(viewModel.width, viewModel.height);
}

+ (CGFloat)calculateHeaderViewHeightWith:(ATOMHomePageViewModel *)viewModel {
    return 65 + viewModel.height + 40;
}

- (void)setViewModel:(ATOMHomePageViewModel *)viewModel {
    _viewModel = viewModel;
    _userNameLabel.text = viewModel.userName;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL]];
    _userSexImageView.image = [UIImage imageNamed:viewModel.userSex];
    _userPublishTimeLabel.text = viewModel.publishTime;
    if (viewModel.image) {
        _userWorkImageView.image = viewModel.image;
    } else {
        [_userWorkImageView setImageWithURL:[NSURL URLWithString:viewModel.userImageURL]];
    }
    [_praiseButton setTitle:viewModel.commentNumber forState:UIControlStateNormal];
    [_shareButton setTitle:viewModel.shareNumber forState:UIControlStateNormal];
    [_commentButton setTitle:viewModel.commentNumber forState:UIControlStateNormal];
    [self setNeedsLayout];
}



































@end
