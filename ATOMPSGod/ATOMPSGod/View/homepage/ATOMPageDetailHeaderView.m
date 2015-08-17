//
//  ATOMPageDetailHeaderView.m
//  ATOMPSGod
//
//  Created by atom on 15/3/22.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPageDetailHeaderView.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMBottomCommonButton.h"
#import "ATOMTipButton.h"
#import "ATOMImageTipLabelViewModel.h"
#define MAXHEIGHT (SCREEN_WIDTH-kPadding15*2)*4/3

@interface ATOMPageDetailHeaderView ()

@end

@implementation ATOMPageDetailHeaderView

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
    _userWorkImageView.contentMode = UIViewContentModeScaleAspectFit;
    _userWorkImageView.userInteractionEnabled = YES;
    _thinCenterView = [UIView new];
    [self addSubview:_topView];
    [self addSubview:_userWorkImageView];
    [self addSubview:_thinCenterView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.layer.cornerRadius = kfcAvatarWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:kUsernameFontSize];
    _userNameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
    
    _psButton = [UIButton new];
    [_psButton setBackgroundImage:[UIImage imageNamed:@"btn_p_normal"] forState:UIControlStateNormal];
    
    [_topView addSubview:_userHeaderButton];
    [_topView addSubview:_userNameLabel];
    [_topView addSubview:_psButton];
    
    _likeButton = [ATOMBottomCommonButton new];
    _likeButton.image = [UIImage imageNamed:@"btn_comment_like_normal"];
    _shareButton = [ATOMBottomCommonButton new];
    _shareButton.image = [UIImage imageNamed:@"icon_share_normal"];
    _commentButton = [ATOMBottomCommonButton new];
    _commentButton.image = [UIImage imageNamed:@"icon_comment_normal"];
    
    [_thinCenterView addSubview:_likeButton];
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
    _userHeaderButton.frame = CGRectMake(kPadding15, (60 - kfcAvatarWidth) / 2, kfcAvatarWidth, kfcAvatarWidth);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, (60 - kFont14) / 2, kUserNameLabelWidth, kFont14+2);
    _psButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - kfcPSWidth, (60 - kfcPSHeight) / 2, kfcPSWidth, kfcPSHeight);
    
    CGSize workImageSize = CGSizeZero;
    CGSize commentSize, shareSize, likeSize;
    
    if (_pageDetailViewModel) {
        workImageSize = [[self class] calculateImageViewSizeWith:_pageDetailViewModel.width height:_pageDetailViewModel.height];
        commentSize = [_pageDetailViewModel.commentNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, kBottomCommonButtonWidth) options:NSStringDrawingUsesLineFragmentOrigin |                                         NSStringDrawingUsesFontLeading          attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
        commentSize.width += kBottomCommonButtonWidth + kPadding15;
        shareSize = [_pageDetailViewModel.commentNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, kBottomCommonButtonWidth) options:NSStringDrawingUsesLineFragmentOrigin |                                           NSStringDrawingUsesFontLeading            attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
        shareSize.width += kBottomCommonButtonWidth + kPadding15;
        likeSize = [_pageDetailViewModel.commentNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, kBottomCommonButtonWidth) options:NSStringDrawingUsesLineFragmentOrigin |                                          NSStringDrawingUsesFontLeading           attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
        likeSize.width += kBottomCommonButtonWidth + kPadding15;
    }
    
    CGFloat cellHeight;
    if (workImageSize.height >= MAXHEIGHT) {
        cellHeight = MAXHEIGHT;
    } else {
        cellHeight = workImageSize.height;
    }
    _userWorkImageView.frame = CGRectMake((SCREEN_WIDTH - workImageSize.width) / 2, CGRectGetMaxY(_topView.frame), workImageSize.width, cellHeight);
    
    CGFloat thinViewHeight = 60;
    CGFloat bottomButtonOriginY = (thinViewHeight - kBottomCommonButtonWidth) / 2;
    _thinCenterView.frame = CGRectMake(0, CGRectGetMaxY(_userWorkImageView.frame), SCREEN_WIDTH, thinViewHeight);
    _moreShareButton.frame = CGRectMake(kPadding15+1, (thinViewHeight - kBottomCommonButtonWidth) / 2, 60, kBottomCommonButtonWidth);
    _moreShareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    
    _commentButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - commentSize.width, bottomButtonOriginY, commentSize.width, kBottomCommonButtonWidth);
    _shareButton.frame = CGRectMake(CGRectGetMinX(_commentButton.frame) - kPadding20 - shareSize.width, bottomButtonOriginY, shareSize.width, kBottomCommonButtonWidth);
    _likeButton.frame = CGRectMake(CGRectGetMinX(_shareButton.frame) - kPadding20 - likeSize.width, bottomButtonOriginY, likeSize.width, kBottomCommonButtonWidth);
}
+ (CGSize)calculateImageViewSizeWith:(CGFloat)width height:(CGFloat)height {
    return CGSizeMake(width, height);
}
+ (CGFloat)calculateHeaderViewHeight:(ATOMPageDetailViewModel *)viewModel {
    if (viewModel.height >= MAXHEIGHT) {
        return 60 + MAXHEIGHT + 60;
    }
    return 60 + viewModel.height + 60 ;
}
//- (void)setAskPageViewModel:(ATOMAskPageViewModel *)askPageViewModel {
//    _userNameLabel.text = askPageViewModel.userName;
//    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:askPageViewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
//    if (askPageViewModel.image) {
//        _userWorkImageView.image = askPageViewModel.image;
//    } else {
//        [_userWorkImageView setImageWithURL:[NSURL URLWithString:askPageViewModel.userImageURL]];
//    }
//    
//    _likeButton.selected = askPageViewModel.liked;
//    _likeButton.number = askPageViewModel.likeNumber;
//    _shareButton.number = askPageViewModel.shareNumber;
//    _commentButton.number = askPageViewModel.commentNumber;
//    [self setNeedsLayout];
//}

//-(void)setProductPageViewModel:(ATOMHotDetailPageViewModel *)productPageViewModel {
//    _userNameLabel.text = productPageViewModel.userName;
//    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:productPageViewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
//    if (productPageViewModel.image) {
//        _userWorkImageView.image = productPageViewModel.image;
//    } else {
//        [_userWorkImageView setImageWithURL:[NSURL URLWithString:productPageViewModel.userImageURL]];
//    }
//    _likeButton.selected = productPageViewModel.liked;
//    _likeButton.number = productPageViewModel.likeNumber;
//    _shareButton.number = productPageViewModel.shareNumber;
//    _commentButton.number = productPageViewModel.commentNumber;
//    [self setNeedsLayout];
//}

-(void)setPageDetailViewModel:(ATOMPageDetailViewModel *)pageDetailViewModel {
    _pageDetailViewModel = pageDetailViewModel;
    CGFloat height = [[self class]calculateHeaderViewHeight:pageDetailViewModel];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    _userNameLabel.text = pageDetailViewModel.userName;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:pageDetailViewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    if (pageDetailViewModel.pageImage) {
        _userWorkImageView.image = pageDetailViewModel.pageImage;
    } else {
        [_userWorkImageView setImageWithURL:[NSURL URLWithString:pageDetailViewModel.pageImageURL]];
    }
    _likeButton.selected = pageDetailViewModel.liked;
    _likeButton.number = pageDetailViewModel.likeNumber;
    _shareButton.number = pageDetailViewModel.shareNumber;
    _commentButton.number = pageDetailViewModel.commentNumber;
    [self addTipLabelToImageView];
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
    for (ATOMImageTipLabelViewModel *labelViewModel in _pageDetailViewModel.labelArray) {
        CGRect labelFrame = [labelViewModel imageTipLabelFrameByImageSize:CGSizeMake(_pageDetailViewModel.width, _pageDetailViewModel.height)];
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
























@end
