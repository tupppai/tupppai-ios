//
//  CommentCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "CommentCell.h"
#import "DDCommentVM.h"
//#import "CommentLikeButton.h"
#define leastHeight kPadding15 * 2 + kfcAvatarWidth
@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _userHeaderButton = [UIButton new];
    _userHeaderButton.layer.cornerRadius = kfcAvatarWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userNameButton = [UIButton new];
//    _userNameButton.backgroundColor = [UIColor lightGrayColor];
    [_userNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _userNameButton.titleLabel.font =  [UIFont systemFontOfSize:14.0];
    _userNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_userNameButton];

//    _userNameLabel = [UILabel new];
//    _userNameLabel.textColor = [UIColor blackColor];
//    _userNameLabel.font = [UIFont systemFontOfSize:kFont14];
//    [self addSubview:_userNameLabel];
    
    _userCommentDetailLabel = [UILabel new];
    _userCommentDetailLabel.numberOfLines = 0;
    _userCommentDetailLabel.font = [UIFont systemFontOfSize:kFont14];
    _userCommentDetailLabel.textColor = [UIColor colorWithHex:0x969696];
    [self addSubview:_userCommentDetailLabel];
    
//    _likeButton = [CommentLikeButton new];
//    [self addSubview:_likeButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(kPadding15, kPadding15, kfcAvatarWidth, kfcAvatarWidth);
    _userNameButton.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, kPadding15, kUserNameLabelWidth, kFont14+5);
    CGSize commentDetailTextSize = [[self class] calculateCommentDeailTextSize:_viewModel.text];
    _userCommentDetailLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, CGRectGetMaxY(_userNameButton.frame) + kPadding10, commentDetailTextSize.width, commentDetailTextSize.   height);
    CGSize size = [_viewModel.likeNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
    size.width += 14 + kPadding5 * 2 + 2;;
//    _likeButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - size.width - kPadding5, 0, size.width, leastHeight);
}

+ (CGSize)calculateCommentDeailTextSize:(NSString *)commentDetailStr {
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont14], NSFontAttributeName, nil];
    CGSize actualSize = [commentDetailStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - kPadding15 * 3 - kfcAvatarWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |                 NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
    return actualSize;
}

+ (CGFloat)calculateCellHeightWithModel:(DDCommentVM *)viewModel {
    CGFloat height1 = [[self class] calculateCommentDeailTextSize:viewModel.text].height + kFont14 + kPadding10 + kPadding15 * 2;
    return fmaxf(height1, leastHeight);
}

- (void)setViewModel:(DDCommentVM *)viewModel {
    _viewModel = viewModel;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatar] placeholderImage:[UIImage imageNamed:@"cellBG"]];
    [_userNameButton setTitle:viewModel.username forState:UIControlStateNormal];
    _userCommentDetailLabel.text = viewModel.text;
//    _likeButton.likeNumber = _viewModel.likeNumber;
//    _likeButton.selected = _viewModel.liked;
    [self setNeedsLayout];
}





@end
