//
//  ATOMHotDetailTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHotDetailTableViewCell.h"
#import "ATOMCommentViewModel.h"
#import "ATOMDetailImageViewModel.h"
#import "ATOMTipButton.h"
#import "ATOMImageTipLabelViewModel.h"

@interface ATOMHotDetailTableViewCell ()

@property (nonatomic, strong) UILabel *commentLabel1;
@property (nonatomic, strong) UILabel *commentLabel2;
@property (nonatomic, strong) UIView *littleVerticalView1;
@property (nonatomic, strong) UIView *littleVerticalView2;
@property (nonatomic, strong) UIView *littleVerticalView3;

@end

@implementation ATOMHotDetailTableViewCell

static int padding = 10;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = NO;
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
    _bottomView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [self addSubview:_topThinView];
    [self addSubview:_topView];
    [self addSubview:_userWorkImageView];
    [self addSubview:_thinCenterView];
    [self addSubview:_bottomView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont systemFontOfSize:16.f];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    _userPublishTimeLabel = [UILabel new];
    _userPublishTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _userPublishTimeLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
    _userSexImageView = [UIImageView new];
    _psButton = [UIButton new];
    [_psButton setBackgroundImage:[UIImage imageNamed:@"btn_p_normal"] forState:UIControlStateNormal];
    [_psButton setBackgroundImage:[UIImage imageNamed:@"btn_p_pressed"] forState:UIControlStateHighlighted];
    
    [_topView addSubview:_userHeaderButton];
    [_topView addSubview:_userNameLabel];
    [_topView addSubview:_userPublishTimeLabel];
    [_topView addSubview:_userSexImageView];
    [_topView addSubview:_psButton];
    
    _praiseButton = [UIButton new];
    _shareButton = [UIButton new];
    _commentButton = [UIButton new];
    [self setCommonButton:_praiseButton WithImage:[UIImage imageNamed:@"btn_comment_like_normal"]];
    [_praiseButton setImage:[UIImage imageNamed:@"btn_comment_like_pressed"] forState:UIControlStateSelected];
    [self setCommonButton:_shareButton WithImage:[UIImage imageNamed:@"icon_share_normal"]];
    [self setCommonButton:_commentButton WithImage:[UIImage imageNamed:@"icon_comment_normal"]];
    [_thinCenterView addSubview:_praiseButton];
    [_thinCenterView addSubview:_shareButton];
    [_thinCenterView addSubview:_commentButton];
    _moreShareButton = [UIButton new];
    [_moreShareButton setImage:[UIImage imageNamed:@"icon_others_normal"] forState:UIControlStateNormal];
    [_moreShareButton setImage:[UIImage imageNamed:@"icon_others_pressed"] forState:UIControlStateNormal];
    [_thinCenterView addSubview:_moreShareButton];
    
    _commentLabel1 = [UILabel new];
    _commentLabel2 = [UILabel new];
    [_bottomView addSubview:_commentLabel1];
    [_bottomView addSubview:_commentLabel2];
    
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
    _topThinView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
    _topView.frame = CGRectMake(0, CGRectGetMaxY(_topThinView.frame), SCREEN_WIDTH, 65);
    _userHeaderButton.frame = CGRectMake(padding, padding, 45, 45);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, padding, 150, 30);
    _userPublishTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, CGRectGetMaxY(_userNameLabel.frame), 150, 15);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - SEXRADIUS, CGRectGetMaxY(_userHeaderButton.frame) - SEXRADIUS, SEXRADIUS, SEXRADIUS);
    _psButton.frame = CGRectMake(SCREEN_WIDTH - padding - 28, 17.5, 28, 28);
    
    CGSize workImageSize;
    if (_viewModel) {
        workImageSize = [[self class] calculateHomePageHotImageViewSizeWith:_viewModel];
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
    
    if (_viewModel) {
        NSInteger commentCount = (_viewModel.commentArray.count > 2) ? 2 : _viewModel.commentArray.count;
        if (commentCount == 0) {
            _bottomView.frame = CGRectZero;
            _commentLabel1.frame = CGRectZero;
            _commentLabel2.frame = CGRectZero;
        } else if (commentCount == 1) {
            _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 30);
            _commentLabel1.frame = CGRectMake(padding, 0, CGWidth(_bottomView.frame) - 2 * padding, 30);
            _commentLabel2.frame = CGRectZero;
        } else if (commentCount == 2) {
            _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 60);
            _commentLabel1.frame = CGRectMake(padding, 0, CGWidth(_bottomView.frame) - 2 * padding, 30);
            _commentLabel2.frame = CGRectMake(padding, CGRectGetMaxY(_commentLabel1.frame), CGWidth(_bottomView.frame) - 2 * padding, 30);
        }
    }
}

+ (CGFloat)calculateCellHeightWith:(ATOMDetailImageViewModel *)viewModel {
    return 6 + 65 + viewModel.height + 40 + ((viewModel.commentArray.count > 2) ? 2 : viewModel.commentArray.count) * 30;
}

+ (CGSize)calculateHomePageHotImageViewSizeWith:(ATOMDetailImageViewModel *)viewModel {
    return CGSizeMake(viewModel.width, viewModel.height);
}

- (void)setViewModel:(ATOMDetailImageViewModel *)viewModel {
    _viewModel = viewModel;
    _userNameLabel.text = viewModel.userName;
    _userSexImageView.image = [UIImage imageNamed:viewModel.userSex];
    _userPublishTimeLabel.text = viewModel.publishTime;
    for (int i = 0; i < viewModel.commentArray.count; i++) {
        ATOMCommentViewModel *commentViewModel = viewModel.commentArray[i];
        NSInteger commentNameLength = commentViewModel.nickname.length;
        NSRange range = {0, commentNameLength + 1};
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.f], NSFontAttributeName, [UIColor colorWithHex:0x797979], NSForegroundColorAttributeName, nil];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@： %@",commentViewModel.nickname, commentViewModel.content] attributes:attributeDict];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        if (i == 0) {
            _commentLabel1.attributedText = attributeStr;
        } else if (i == 1) {
            _commentLabel2.attributedText = attributeStr;
        }
    }

    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    [_shareButton setTitle:viewModel.shareNumber forState:UIControlStateNormal];
    [_praiseButton setTitle:viewModel.praiseNumber forState:UIControlStateNormal];
    [_commentButton setTitle:viewModel.commentNumber forState:UIControlStateNormal];
    [_userWorkImageView setImageWithURL:[NSURL URLWithString:viewModel.userImageURL]];
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
