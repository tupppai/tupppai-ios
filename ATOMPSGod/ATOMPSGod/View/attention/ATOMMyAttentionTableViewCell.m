//
//  ATOMMyAttentionTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyAttentionTableViewCell.h"

@interface ATOMMyAttentionTableViewCell ()


@end

@implementation ATOMMyAttentionTableViewCell

static CGFloat totalHeight;
static int padding = 10;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)setViewModel {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);
    _userHeaderButton.frame = CGRectMake(padding, padding, 45, 45);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, padding, SCREEN_WIDTH - padding * 2- 45, 30);
    _userPublishTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding, CGRectGetMaxY(_userNameLabel.frame), 80, 15);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 17, CGRectGetMaxY(_userHeaderButton.frame) - 17, 17, 17);
    
    CGSize userWorkingImageViewSize = [self calculateWorkImageViewSize];
    _userWorkImageView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), userWorkingImageViewSize.width, userWorkingImageViewSize.height);
    
    _thinCenterView.frame = CGRectMake(0, CGRectGetMaxY(_userWorkImageView.frame), SCREEN_WIDTH, 40);
    _shareButton.frame = CGRectMake(padding, 7.5, 60, 25);
    _praiseButton.frame = CGRectMake(CGRectGetMaxX(_shareButton.frame) + padding * 2, 7.5, 60, 25);
    _commentButton.frame = CGRectMake(CGRectGetMaxX(_praiseButton.frame) + padding * 2, 7.5, 60, 25);
    _moreShareButton.frame = CGRectMake(SCREEN_WIDTH - 90, 7.5, 90, 25);
    
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_thinCenterView.frame), SCREEN_WIDTH, 61);
    
    totalHeight = _topView.frame.size.height + _userWorkImageView.frame.size.height + _thinCenterView.frame.size.height + _bottomView.frame.size.height;
}

- (CGSize)calculateWorkImageViewSize {
    CGSize result;
    result.width = SCREEN_WIDTH;
    if (_userWorkImage) {
        CGFloat imageWidth = _userWorkImage.size.width;
        CGFloat imageHeight = _userWorkImage.size.height;
        CGFloat ratio = imageHeight / imageWidth;
        result.height = result.width * ratio;
    } else {
        result.height = result.width;
    }
    return result;
}

+ (CGFloat)calculateCellHeight {
    return totalHeight;
}

- (void)createSubView {
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    _userWorkImageView = [UIImageView new];
    _userWorkImageView.backgroundColor = [UIColor yellowColor];
    _thinCenterView = [UIView new];
    _thinCenterView.backgroundColor = [UIColor whiteColor];
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [self addSubview:_topView];
    [self addSubview:_userWorkImageView];
    [self addSubview:_thinCenterView];
    [self addSubview:_bottomView];
    
    _userHeaderButton = [UIButton new];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.backgroundColor = [UIColor brownColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    
    _userNameLabel = [UILabel new];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.f], NSFontAttributeName, [UIColor colorWithHex:0x797979], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"宋祥伍发布了一个求助" attributes:attributeDict];
    NSRange range = {0,3};
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x00adef] range:range];
    _userNameLabel.attributedText = attributeStr;
    
    _userPublishTimeLabel = [UILabel new];
    //    _userPublishTimeLabel.backgroundColor = [UIColor greenColor];
    _userPublishTimeLabel.text = @"3小时前";
    _userPublishTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _userPublishTimeLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
    _userSexImageView = [UIImageView new];
    [_userSexImageView setImage:[UIImage imageNamed:@"man"]];
    
    [_topView addSubview:_userHeaderButton];
    [_topView addSubview:_userNameLabel];
    [_topView addSubview:_userPublishTimeLabel];
    [_topView addSubview:_userSexImageView];
    
    _praiseButton = [UIButton new];
    [_praiseButton setImage:[UIImage imageNamed:@"btn_comment_like_pressed"] forState:UIControlStateSelected];
    _shareButton = [UIButton new];
    _commentButton = [UIButton new];
    [self setCommonButton:_praiseButton WithImage:[UIImage imageNamed:@"icon_like_normal"]];
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
    button.userInteractionEnabled = NO;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor colorWithHex:0xededed] CGColor];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(3.5, 0, 3.5, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(3.5, padding / 2.0, 3.5, 0)];
    [button setTitle:@"100" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


@end
