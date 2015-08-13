//
//  ATOMCommentTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/23.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentTableViewCell.h"
#import "ATOMCommentDetailViewModel.h"
#import "ATOMPraiseButton.h"
#define leastHeight kPadding15 * 2 + kUserHeaderButtonWidth
@implementation ATOMCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _userHeaderButton = [UIButton new];
    _userHeaderButton.layer.cornerRadius = kUserHeaderButtonWidth / 2;
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
    
    _praiseButton = [ATOMPraiseButton new];
    [self addSubview:_praiseButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(kPadding15, kPadding15, kUserHeaderButtonWidth, kUserHeaderButtonWidth);
    _userNameButton.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, kPadding15, kUserNameLabelWidth, kFont14+5);
    CGSize commentDetailTextSize = [[self class] calculateCommentDeailTextSize:_viewModel.content];
    _userCommentDetailLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, CGRectGetMaxY(_userNameButton.frame) + kPadding10, commentDetailTextSize.width, commentDetailTextSize.   height);
    CGSize size = [_viewModel.likeNumber boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary            dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
    size.width += 14 + kPadding5 * 2 + 2;;
    _praiseButton.frame = CGRectMake(SCREEN_WIDTH - kPadding15 - size.width - kPadding5, 0, size.width, leastHeight);
}

+ (CGSize)calculateCommentDeailTextSize:(NSString *)commentDetailStr {
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont14], NSFontAttributeName, nil];
    CGSize actualSize = [commentDetailStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - kPadding15 * 3 - kUserHeaderButtonWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |                 NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
    return actualSize;
}

+ (CGFloat)calculateCellHeightWithModel:(ATOMCommentDetailViewModel *)viewModel {
    CGFloat height1 = [[self class] calculateCommentDeailTextSize:viewModel.content].height + kFont14 + kPadding10 + kPadding15 * 2;
    return fmaxf(height1, leastHeight);
}

- (void)setViewModel:(ATOMCommentDetailViewModel *)viewModel {
    _viewModel = viewModel;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatar] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    [_userNameButton setTitle:viewModel.nickname forState:UIControlStateNormal];
    _userCommentDetailLabel.text = viewModel.content;
    _praiseButton.likeNumber = _viewModel.likeNumber;
    _praiseButton.selected = _viewModel.liked;
    [self setNeedsLayout];
}





@end
