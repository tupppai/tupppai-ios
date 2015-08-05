//
//  ATOMMyAttentionTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyAttentionTableViewCell.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMBottomCommonButton.h"
#import "ATOMTotalPSView.h"
#import "ATOMFollowPageViewModel.h"
#import "ATOMTipButton.h"
#import "ATOMImageTipLabelViewModel.h"
#import "ATOMReplierViewModel.h"

@interface ATOMMyAttentionTableViewCell ()

@property (nonatomic, strong) UIView *littleVerticalView1;
@property (nonatomic, strong) UIView *littleVerticalView2;
@property (nonatomic, strong) UIView *littleVerticalView3;
@property (nonatomic, strong) NSMutableArray *replierAvatars;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ATOMTotalPSView *totalPSLabel;
@property (nonatomic, strong) UILabel *publishTypeLabel;

@end

@implementation ATOMMyAttentionTableViewCell

static int defaultAvatarCount = 7;
static CGFloat replierWidth = 25;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    _userWorkImageView = [UIImageView new];
    _userWorkImageView.contentMode = UIViewContentModeScaleAspectFill;
    _userWorkImageView.layer.masksToBounds = YES;
    
    _thinCenterView = [UIView new];
    _thinCenterView.backgroundColor = [UIColor whiteColor];
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomThinView = [UIView new];
    _bottomThinView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self addSubview:_topView];
    [self addSubview:_userWorkImageView];
    [self addSubview:_thinCenterView];
    [self addSubview:_bottomView];
    [self addSubview:_bottomThinView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.layer.cornerRadius = kUserHeaderButtonWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:kFont14];
    _userNameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
    
    _publishTypeLabel = [UILabel new];
    _publishTypeLabel.font = [UIFont systemFontOfSize:kFont14];
    _publishTypeLabel.textColor = [UIColor colorWithHex:0x74c3ff];
    
    _userPublishTimeLabel = [UILabel new];
    _userPublishTimeLabel.font = [UIFont systemFontOfSize:11];
    _userPublishTimeLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    
    _psButton = [UIButton new];
    _psButton.userInteractionEnabled = NO;
    [_psButton setBackgroundImage:[UIImage imageNamed:@"btn_p_normal"] forState:UIControlStateNormal];

    [_topView addSubview:_userHeaderButton];
    [_topView addSubview:_userNameLabel];
    [_topView addSubview:_publishTypeLabel];
    [_topView addSubview:_userPublishTimeLabel];
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
    _moreShareButton.userInteractionEnabled = NO;
    [_moreShareButton setImage:[UIImage imageNamed:@"icon_others_normal"] forState:UIControlStateNormal];
    [_thinCenterView addSubview:_moreShareButton];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithHex:0xededed];
    [_thinCenterView addSubview:_lineView];
    
    _totalPSLabel = [ATOMTotalPSView new];
    [_bottomView addSubview:_totalPSLabel];
    
    _replierAvatars = [NSMutableArray array];
    for (int i = 0; i < defaultAvatarCount; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.layer.cornerRadius = replierWidth / 2;
        imageView.layer.masksToBounds = YES;
        [_bottomView addSubview:imageView];
        [_replierAvatars addObject:imageView];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat topViewHeight = 60;
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, topViewHeight);
    _userHeaderButton.frame = CGRectMake(kPadding15, (topViewHeight - kUserHeaderButtonWidth) / 2, kUserHeaderButtonWidth, kUserHeaderButtonWidth);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, CGRectGetMinY(_userHeaderButton.frame), kUserNameLabelWidth, kFont14+3);
    _publishTypeLabel.frame = CGRectMake(CGRectGetMaxX(_userNameLabel.frame) + kPadding13, CGRectGetMinY(_userHeaderButton.frame), kFont14*7 , kFont14+3);
    _userPublishTimeLabel.frame = CGRectMake(CGRectGetMinX(_userNameLabel.frame)+1, CGRectGetMaxY(_userHeaderButton.frame) - kFont10, 200, kFont12+1);
    _psButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - kPSButtonWidth, (60 - kPSButtonHeight) / 2, kPSButtonWidth, kPSButtonHeight);
    CGSize workImageSize = CGSizeZero;
    CGSize commentSize, shareSize, praiseSize;
    if (_viewModel) {
        workImageSize = CGSizeMake(_viewModel.width, _viewModel.height);
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
    _moreShareButton.frame = CGRectMake(kPadding15+1, (thinViewHeight - kBottomCommonButtonWidth) / 2, 60, kBottomCommonButtonWidth);
    _moreShareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    
    _commentButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - commentSize.width, bottomButtonOriginY, commentSize.width, kBottomCommonButtonWidth);
    _shareButton.frame = CGRectMake(CGRectGetMinX(_commentButton.frame) - kPadding20 - shareSize.width, bottomButtonOriginY, shareSize.width, kBottomCommonButtonWidth);
    _praiseButton.frame = CGRectMake(CGRectGetMinX(_shareButton.frame) - kPadding20 - praiseSize.width, bottomButtonOriginY, praiseSize.width, kBottomCommonButtonWidth);
    _lineView.frame = CGRectMake(kPadding15, CGHeight(_thinCenterView.frame) - 1, SCREEN_WIDTH - 2 * kPadding15, 1);
    
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 60);
    CGFloat originX = SCREEN_WIDTH - defaultAvatarCount * (kPadding5 + replierWidth) + kPadding5 - kPadding15;
    for (int i = 0; i < defaultAvatarCount; i++) {
        UIImageView *imageView = _replierAvatars[i];
        imageView.frame = CGRectMake(originX + i * (replierWidth + kPadding5), (CGHeight(_bottomView.frame) - replierWidth) / 2, replierWidth, replierWidth);
    }
    _totalPSLabel.frame = CGRectMake(kPadding15, (CGHeight(_bottomView.frame) - kFont14) / 2, kFont14 * (_viewModel.totalPSNumber.length + 3) + 6 * 2, kFont14);
    if (_viewModel.type == 1) {
        _bottomThinView.frame = CGRectMake(0, CGRectGetMaxY(_bottomView.frame), SCREEN_WIDTH, 8);
    } else {
        _bottomThinView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 8);
    }
    
}

+ (CGFloat)calculateCellHeightWith:(ATOMFollowPageViewModel *)viewModel {
    if (viewModel.type == 1) {
        return 60 + viewModel.height + 60 + 60 + 8;
    } else {
        return 60 + viewModel.height + 60 + 8;
    }
}

- (void)setViewModel:(ATOMFollowPageViewModel *)viewModel {
    _viewModel = viewModel;
    if (viewModel.type == 1) {
        _publishTypeLabel.text = @"发布了一个求P";
    } else {
        _publishTypeLabel.text = @"发布了一个作品";
    }
    _userNameLabel.text = [NSString stringWithFormat:@"%@", viewModel.userName];
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _userPublishTimeLabel.text = viewModel.publishTime;
    _praiseButton.number = viewModel.likeNumber;
    _praiseButton.selected = viewModel.liked;
    _shareButton.number = viewModel.shareNumber;
    _commentButton.number = viewModel.commentNumber;
    _totalPSLabel.number = viewModel.totalPSNumber;

    if (viewModel.image) {
        _userWorkImageView.image = viewModel.image;
    } else {
        [_userWorkImageView setImageWithURL:[NSURL URLWithString:viewModel.pageImageURL] placeholderImage:[UIImage imageNamed:@"placeholderImage_1"]];
    }
    if (viewModel.type == 1) {
        _lineView.hidden = NO;
        _bottomView.hidden = NO;
        [self addReplier];
    } else {
        _lineView.hidden = YES;
        _bottomView.hidden = YES;
    }
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
