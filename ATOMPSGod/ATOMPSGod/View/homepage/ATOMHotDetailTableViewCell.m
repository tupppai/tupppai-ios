//
//  ATOMHotDetailTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHotDetailTableViewCell.h"
#import "ATOMCommentViewModel.h"
#import "ATOMHotDetailPageViewModel.h"
#import "ATOMTipButton.h"
#import "ATOMImageTipLabelViewModel.h"
#import "ATOMBottomCommonButton.h"

@interface ATOMHotDetailTableViewCell ()

@property (nonatomic, strong) UILabel *commentLabel1;
@property (nonatomic, strong) UILabel *commentLabel2;
@property (nonatomic, strong) UIImageView *commentImageView;

@end

@implementation ATOMHotDetailTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = NO;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    _userWorkImageView = [UIImageView new];
    _thinCenterView = [UIView new];
    _thinCenterView.backgroundColor = [UIColor whiteColor];
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _extralBottomView = [UIView new];
    _extralBottomView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [self addSubview:_topView];
    [self addSubview:_userWorkImageView];
    [self addSubview:_thinCenterView];
    [self addSubview:_bottomView];
    [self addSubview:_extralBottomView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.layer.cornerRadius = kUserHeaderButtonWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont systemFontOfSize:kFont14];
    _userNameLabel.textColor = [UIColor colorWithHex:0x585858];

    _psButton = [UIButton new];
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
    [_moreShareButton setImage:[UIImage imageNamed:@"icon_others_normal"] forState:UIControlStateNormal];
    [_thinCenterView addSubview:_moreShareButton];
    
    _commentImageView = [UIImageView new];
//    _commentImageView.backgroundColor = [UIColor orangeColor];
    _commentImageView.image = [UIImage imageNamed:@"ic_comment"];
    [_bottomView addSubview:_commentImageView];
    
    _commentLabel1 = [UILabel new];
    _commentLabel2 = [UILabel new];
    [_bottomView addSubview:_commentLabel1];
    [_bottomView addSubview:_commentLabel2];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    _userHeaderButton.frame = CGRectMake(kPadding15, (60 - kUserHeaderButtonWidth) / 2, kUserHeaderButtonWidth, kUserHeaderButtonWidth);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, (60 - kFont14) / 2, kUserNameLabelWidth, kFont14+2);
    _psButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - kPSButtonWidth, (60 - kPSButtonHeight) / 2, kPSButtonWidth, kPSButtonHeight);
    
    CGSize workImageSize = CGSizeZero;
    CGSize commentSize, shareSize, praiseSize;
    if (_viewModel) {
        workImageSize = [[self class] calculateHomePageHotImageViewSizeWith:_viewModel];
        commentSize = [_viewModel.commentNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, kBottomCommonButtonWidth) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
        commentSize.width += kBottomCommonButtonWidth + kPadding15;
        shareSize = [_viewModel.commentNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, kBottomCommonButtonWidth) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
        shareSize.width += kBottomCommonButtonWidth + kPadding15;
        praiseSize = [_viewModel.commentNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, kBottomCommonButtonWidth) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
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
    
    if (_viewModel) {
        NSInteger commentCount = (_viewModel.commentArray.count > 2) ? 2 : _viewModel.commentArray.count;
        if (commentCount == 0) {
            _commentImageView.frame = CGRectZero;
            _bottomView.frame = CGRectZero;
            _commentLabel1.frame = CGRectZero;
            _commentLabel2.frame = CGRectZero;
            _extralBottomView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 40);
        } else if (commentCount == 1) {
            _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 20);
            _commentImageView.frame = CGRectMake(kPadding15, 2.5, kPadding15, kPadding15);
            _commentLabel1.frame = CGRectMake(CGRectGetMaxX(_commentImageView.frame) + kPadding15, 0, CGWidth(_bottomView.frame) - 4 * kPadding15, 20);
            _commentLabel2.frame = CGRectZero;
            _extralBottomView.frame = CGRectMake(0, CGRectGetMaxY(_bottomView.frame), SCREEN_WIDTH, 40);
        } else if (commentCount == 2) {
            _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 40);
            _commentImageView.frame = CGRectMake(kPadding15, 2.5, kPadding15, kPadding15);
            _commentLabel1.frame = CGRectMake(CGRectGetMaxX(_commentImageView.frame) + kPadding15, 0, CGWidth(_bottomView.frame) - 4 * kPadding15, 20);
            _commentLabel2.frame = CGRectMake(CGRectGetMaxX(_commentImageView.frame) + kPadding15, 20, CGWidth(_bottomView.frame) - 4 * kPadding15, 20);
            _extralBottomView.frame = CGRectMake(0, CGRectGetMaxY(_bottomView.frame), SCREEN_WIDTH, 40);
        }
    }
}

+ (CGFloat)calculateCellHeightWith:(ATOMHotDetailPageViewModel *)viewModel {
    return 60 + viewModel.height + 60 + ((viewModel.commentArray.count > 2) ? 2 : viewModel.commentArray.count) * 20 + 40;
}

+ (CGSize)calculateHomePageHotImageViewSizeWith:(ATOMHotDetailPageViewModel *)viewModel {
    return CGSizeMake(viewModel.width, viewModel.height);
}

- (void)setViewModel:(ATOMHotDetailPageViewModel *)viewModel {
    _viewModel = viewModel;
    _userNameLabel.text = viewModel.userName;
    for (int i = 0; i < viewModel.commentArray.count; i++) {
        ATOMCommentViewModel *commentViewModel = viewModel.commentArray[i];
        NSInteger commentNameLength = commentViewModel.nickname.length;
        NSRange range = {0, commentNameLength + 1};
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f], NSFontAttributeName, [UIColor colorWithHex:0x797979], NSForegroundColorAttributeName, nil];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@： %@",commentViewModel.nickname, commentViewModel.content] attributes:attributeDict];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        if (i == 0) {
            _commentLabel1.attributedText = attributeStr;
        } else if (i == 1) {
            _commentLabel2.attributedText = attributeStr;
        }
    }

    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _praiseButton.number = viewModel.likeNumber;
    NSLog(@"_praiseButton number %@,selected%d,ID%ld",viewModel.likeNumber,viewModel.liked,(long)viewModel.ID);
    _praiseButton.selected = viewModel.liked;
    _shareButton.number = viewModel.shareNumber;
    _commentButton.number = viewModel.commentNumber;
    _userWorkImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_userWorkImageView setImageWithURL:[NSURL URLWithString:viewModel.userImageURL] placeholderImage:[UIImage imageNamed:@"placeholderImage_1"]];
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










@end
