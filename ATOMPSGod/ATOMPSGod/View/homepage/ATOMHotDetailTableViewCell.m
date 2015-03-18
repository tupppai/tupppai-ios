//
//  ATOMHotDetailTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHotDetailTableViewCell.h"
#import "ATOMHomePageViewModel.h"

@interface ATOMHotDetailTableViewCell ()



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
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    _userWorkImageView = [UIImageView new];
    _thinCenterView = [UIView new];
    _thinCenterView.backgroundColor = [UIColor whiteColor];
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [self addSubview:_topView];
    [self addSubview:_userWorkImageView];
    [self addSubview:_thinCenterView];
    [self addSubview:_bottomView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.backgroundColor = [UIColor brownColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    _userNameLabel = [UILabel new];
    //    _userNameLabel.backgroundColor = [UIColor orangeColor];
    _userNameLabel.font = [UIFont systemFontOfSize:16.f];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    _userPublishTimeLabel = [UILabel new];
    //    _userPublishTimeLabel.backgroundColor = [UIColor greenColor];
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
    [self setCommonButton:_praiseButton WithImage:[UIImage imageNamed:@"icon_like_normal"]];
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
    
}

- (void)setCommonButton:(UIButton *)button WithImage:(UIImage *)image{
    //    button.layer.borderWidth = 1;
    //    button.layer.borderColor = [[UIColor colorWithHex:0xededed] CGColor];
    //    button.layer.cornerRadius = 5;
    //    button.layer.masksToBounds = YES;
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(3.5, 0, 3.5, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(3.5, padding / 2.0, 3.5, 0)];
    button.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0xf80630] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);
    _userHeaderButton.frame = CGRectMake(padding, padding, 45, 45);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, padding, 80, 30);
    _userPublishTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, CGRectGetMaxY(_userNameLabel.frame), 80, 15);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 16, CGRectGetMaxY(_userHeaderButton.frame) - 16, 17, 17);
    _psButton.frame = CGRectMake(SCREEN_WIDTH - padding - 46, 17.5, 46, 32);
    
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
    
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 61);
}

+ (CGFloat)calculateCellHeightWith:(ATOMHomePageViewModel *)viewModel {
    return 65 + viewModel.calculateImageViewSize.height + 40 + 61;
}

+ (CGSize)calculateHomePageHotImageViewSizeWith:(ATOMHomePageViewModel *)viewModel {
    return [viewModel calculateImageViewSize];
}

- (void)setViewModel:(ATOMHomePageViewModel *)viewModel {
    _viewModel = viewModel;
    _userNameLabel.text = viewModel.userName;
    _userSexImageView.image = [UIImage imageNamed:viewModel.userSex];
    _userPublishTimeLabel.text = viewModel.publishTime;
    [_shareButton setTitle:viewModel.shareNumber forState:UIControlStateNormal];
    [_praiseButton setTitle:viewModel.praiseNumber forState:UIControlStateNormal];
    [_commentButton setTitle:viewModel.commentNumber forState:UIControlStateNormal];
    _userWorkImageView.image = viewModel.userImage;
    [self setNeedsLayout];
}





@end
