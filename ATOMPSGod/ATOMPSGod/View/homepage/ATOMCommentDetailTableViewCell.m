//
//  ATOMCommentDetailTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/4.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentDetailTableViewCell.h"
#import "CommentVM.h"
#import "CommentLikeButton.h"

@interface ATOMCommentDetailTableViewCell ()



@end

@implementation ATOMCommentDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = NO;
        [self createSubView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(kPadding15, kPadding15, kfcAvatarWidth, kfcAvatarWidth);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, kPadding15, kUserNameLabelWidth, kFont14+1);
    CGSize commentDetailTextSize = [[self class] calculateCommentDeailTextSize:_viewModel.text];
    _userCommentDetailLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, CGRectGetMaxY(_userNameLabel.frame) + kPadding10, commentDetailTextSize.width, commentDetailTextSize.height);
    CGSize size = [_viewModel.likeNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
    size.width += 14 + kPadding5 * 2 + 2;;
    _likeButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - size.width - kPadding5, kPadding15, size.width, 13);
    
}

+ (CGSize)calculateCommentDeailTextSize:(NSString *)commentDetailStr {
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont14], NSFontAttributeName, nil];
    CGSize actualSize = [commentDetailStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - kPadding15 * 3 - kfcAvatarWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
    return actualSize;
}

+ (CGFloat)calculateCellHeightWithModel:(CommentVM *)viewModel {
    CGFloat height1 = [[self class] calculateCommentDeailTextSize:viewModel.text].height + kFont14 + kPadding10 + kPadding15 * 2;
    CGFloat height2 = kPadding15 * 2 + kfcAvatarWidth;
    return fmaxf(height1, height2);
}

- (void)createSubView {
    _userHeaderButton = [UIButton new];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.layer.cornerRadius = kfcAvatarWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.textColor = [UIColor blackColor];
    _userNameLabel.font = [UIFont systemFontOfSize:kFont14];
    [self addSubview:_userNameLabel];
    
    _userCommentDetailLabel = [UILabel new];
    _userCommentDetailLabel.numberOfLines = 0;
    _userCommentDetailLabel.font = [UIFont systemFontOfSize:kFont14];
    _userCommentDetailLabel.textColor = [UIColor colorWithHex:0x969696];
    [self addSubview:_userCommentDetailLabel];
    
    _likeButton = [CommentLikeButton new];
    [self addSubview:_likeButton];
}

- (void)setViewModel:(CommentVM *)viewModel {
    _viewModel = viewModel;
    _userNameLabel.text = viewModel.username;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatar] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _userCommentDetailLabel.text = viewModel.text;
    _likeButton.likeNumber = _viewModel.likeNumber;
    _likeButton.selected = _viewModel.liked;
    [self setNeedsLayout];
}





















@end
