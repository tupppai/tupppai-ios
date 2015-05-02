//
//  ATOMRecentDetailHeaderView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMRecentDetailHeaderView.h"
#import "ATOMHomePageViewModel.h"
#import "ATOMBottomCommonButton.h"

@interface ATOMRecentDetailHeaderView ()

@end

@implementation ATOMRecentDetailHeaderView

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
    _topView.backgroundColor = [UIColor whiteColor];
    _userWorkImageView = [UIImageView new];
    _thinCenterView = [UIView new];
    [self addSubview:_topView];
    [self addSubview:_userWorkImageView];
    [self addSubview:_thinCenterView];
    
    _userHeaderButton = [UIButton new];
//    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.layer.cornerRadius = kUserHeaderButtonWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont systemFontOfSize:kFont14];
    _userNameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
    
    _psButton = [UIButton new];
//    _psButton.userInteractionEnabled = NO;
    [_psButton setBackgroundImage:[UIImage imageNamed:@"btn_p_normal"] forState:UIControlStateNormal];
    
    [_topView addSubview:_userHeaderButton];
    [_topView addSubview:_userNameLabel];
    [_topView addSubview:_psButton];
    
    _praiseButton = [ATOMBottomCommonButton new];
    _praiseButton.image = [UIImage imageNamed:@"btn_comment_like_normal"];
    _shareButton = [ATOMBottomCommonButton new];
    _shareButton.image = [UIImage imageNamed:@"icon_share_normal"];
    _commentButton = [ATOMBottomCommonButton new];
    _commentButton.image = [UIImage imageNamed:@"icon_comment_normal"];
    
    [_thinCenterView addSubview:_praiseButton];
    [_thinCenterView addSubview:_shareButton];
    [_thinCenterView addSubview:_commentButton];
    
    _moreShareButton = [UIButton new];
//    _moreShareButton.userInteractionEnabled = NO;
    [_moreShareButton setImage:[UIImage imageNamed:@"icon_others_normal"] forState:UIControlStateNormal];
    [_thinCenterView addSubview:_moreShareButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    _userHeaderButton.frame = CGRectMake(kPadding15, (60 - kUserHeaderButtonWidth) / 2, kUserHeaderButtonWidth, kUserHeaderButtonWidth);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, (60 - kFont14) / 2, kUserNameLabelWidth, kFont14);
    _psButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - kPSButtonWidth, (60 - kPSButtonHeight) / 2, kPSButtonWidth, kPSButtonHeight);
    
    CGSize workImageSize = CGSizeZero;
    CGSize commentSize, shareSize, praiseSize;
    if (_viewModel) {
        workImageSize = [[self class] calculateImageViewSizeWith:_viewModel];
        commentSize = [_viewModel.commentNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, kBottomCommonButtonWidth) options:NSStringDrawingUsesLineFragmentOrigin |                                         NSStringDrawingUsesFontLeading          attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
        commentSize.width += kBottomCommonButtonWidth + kPadding15;
        shareSize = [_viewModel.commentNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, kBottomCommonButtonWidth) options:NSStringDrawingUsesLineFragmentOrigin |                                           NSStringDrawingUsesFontLeading            attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
        shareSize.width += kBottomCommonButtonWidth + kPadding15;
        praiseSize = [_viewModel.commentNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, kBottomCommonButtonWidth) options:NSStringDrawingUsesLineFragmentOrigin |                                          NSStringDrawingUsesFontLeading           attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
        praiseSize.width += kBottomCommonButtonWidth + kPadding15;
    }
    _userWorkImageView.frame = CGRectMake((SCREEN_WIDTH - workImageSize.width) / 2, CGRectGetMaxY(_topView.frame), workImageSize.width, workImageSize.height);
    
    CGFloat thinViewHeight = 60;
    CGFloat bottomButtonOriginY = (thinViewHeight - kBottomCommonButtonWidth) / 2;
    _thinCenterView.frame = CGRectMake(0, CGRectGetMaxY(_userWorkImageView.frame), SCREEN_WIDTH, thinViewHeight);
    _moreShareButton.frame = CGRectMake(kPadding15, (thinViewHeight - kBottomCommonButtonWidth) / 2, 26, kBottomCommonButtonWidth);
    
    _commentButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - commentSize.width, bottomButtonOriginY, commentSize.width, kBottomCommonButtonWidth);
    _shareButton.frame = CGRectMake(CGRectGetMinX(_commentButton.frame) - kPadding20 - shareSize.width, bottomButtonOriginY, shareSize.width, kBottomCommonButtonWidth);
    _praiseButton.frame = CGRectMake(CGRectGetMinX(_shareButton.frame) - kPadding20 - praiseSize.width, bottomButtonOriginY, praiseSize.width, kBottomCommonButtonWidth);
}

+ (CGSize)calculateImageViewSizeWith:(ATOMHomePageViewModel *)viewModel {
    return CGSizeMake(viewModel.width, viewModel.height);
}

+ (CGFloat)calculateHeaderViewHeightWith:(ATOMHomePageViewModel *)viewModel {
    return 60 + viewModel.height + 60;
}

- (void)setViewModel:(ATOMHomePageViewModel *)viewModel {
    _viewModel = viewModel;
    _userNameLabel.text = viewModel.userName;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    if (viewModel.image) {
        _userWorkImageView.image = viewModel.image;
    } else {
        [_userWorkImageView setImageWithURL:[NSURL URLWithString:viewModel.userImageURL]];
    }
    _praiseButton.number = viewModel.praiseNumber;
    _shareButton.number = viewModel.shareNumber;
    _commentButton.number = viewModel.commentNumber;
    [self setNeedsLayout];
}



































@end
