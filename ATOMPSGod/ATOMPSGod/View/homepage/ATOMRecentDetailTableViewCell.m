//
//  ATOMRecentDetailTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMRecentDetailTableViewCell.h"
#import "ATOMCommentDetailViewModel.h"

@implementation ATOMRecentDetailTableViewCell

static int padding10 = 10;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = NO;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _userHeaderButton = [UIButton new];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [UIImageView new];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.font = [UIFont systemFontOfSize:16.f];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    [self addSubview:_userNameLabel];
    
    _userCommentDetailLabel = [UILabel new];
    _userCommentDetailLabel.numberOfLines = 0;
    _userCommentDetailLabel.font = [UIFont systemFontOfSize:16.f];
    _userCommentDetailLabel.textColor = [UIColor blackColor];
    [self addSubview:_userCommentDetailLabel];
    
    _praiseButton = [UIButton new];
    [_praiseButton setImage:[UIImage imageNamed:@"btn_comment_like_normal"] forState:UIControlStateNormal];
    [_praiseButton setImage:[UIImage imageNamed:@"btn_comment_like_pressed"] forState:UIControlStateSelected];
    _praiseButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
    [_praiseButton setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 2, 5)];
    [_praiseButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 0)];
    [_praiseButton setTitleColor:[UIColor colorWithHex:0x6e6e70] forState:UIControlStateNormal];
    [_praiseButton setTitleColor:[UIColor colorWithHex:0x00adef] forState:UIControlStateSelected];
    [self addSubview:_praiseButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(padding10, padding10, 45, 45);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - SEXRADIUS, CGRectGetMaxY(_userHeaderButton.frame) - SEXRADIUS, SEXRADIUS, SEXRADIUS);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, padding10, SCREEN_WIDTH - padding10 * 4 - 75 - 45, 20);
    _praiseButton.frame = CGRectMake(SCREEN_WIDTH - 60 - padding10, padding10, 60, 20);
    CGSize commentDetailTextSize = [[self class] calculateCommentDeailTextSize:_viewModel.content];
    _userCommentDetailLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userNameLabel.frame), commentDetailTextSize.width, commentDetailTextSize.height);
}

+ (CGSize)calculateCommentDeailTextSize:(NSString *)commentDetailStr {
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.f], NSFontAttributeName, nil];
    CGSize actualSize = [commentDetailStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - padding10 * 2 - 55, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
    return actualSize;
}

+ (CGFloat)calculateCellHeightWithModel:(ATOMCommentDetailViewModel *)viewModel {
    CGFloat height1 = [[self class] calculateCommentDeailTextSize:viewModel.content].height + 30 + padding10 *2;
    CGFloat height2 = 45 + padding10 * 2;
    return fmaxf(height1, height2);
}

- (void)setViewModel:(ATOMCommentDetailViewModel *)viewModel {
    _viewModel = viewModel;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatar] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _userNameLabel.text = viewModel.nickname;
    _userSexImageView.image = [UIImage imageNamed:viewModel.userSex];
    _userCommentDetailLabel.text = viewModel.content;
    [_praiseButton setTitle:viewModel.praiseNumber forState:UIControlStateNormal];
    [self setNeedsLayout];
}









































@end
