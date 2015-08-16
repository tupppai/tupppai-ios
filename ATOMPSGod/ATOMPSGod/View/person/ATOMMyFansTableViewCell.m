//
//  ATOMMyFansTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/10.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMMyFansTableViewCell.h"
#import "ATOMFansViewModel.h"

@interface ATOMMyFansTableViewCell ()

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;

@end
@implementation ATOMMyFansTableViewCell
static CGFloat cellHeight = 70;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _userHeaderButton = [UIButton new];
    _userHeaderButton.userInteractionEnabled = NO;
    _userHeaderButton.layer.cornerRadius = KAvatarWidth / 2;
    _userHeaderButton.layer.masksToBounds = YES;
    [_userHeaderButton setBackgroundImage:[UIImage imageNamed:@"head_portrait"] forState:UIControlStateNormal];
    [self addSubview:_userHeaderButton];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.text = @"**";
    _userNameLabel.font = [UIFont systemFontOfSize:kFont14];
    [self addSubview:_userNameLabel];
    
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kPadding15 - 33, 18, 33, 27)];
    _attentionButton.userInteractionEnabled = NO;
    [self addSubview:_attentionButton];
    _fansNumberLabel = [UILabel new];
    _fansNumberLabel.textColor = [UIColor colorWithHex:0xc5cdd3];
    _fansNumberLabel.font = [UIFont systemFontOfSize:kFont10];
    [self addSubview:_fansNumberLabel];
    _view1 = [self littleCircleView];
    [self addSubview:_view1];
    _uploadNumberLabel = [UILabel new];
    _uploadNumberLabel.textColor = [UIColor colorWithHex:0xc5cdd3];
    _uploadNumberLabel.font = [UIFont systemFontOfSize:kFont10];
    [self addSubview:_uploadNumberLabel];
    _view2 = [self littleCircleView];
    [self addSubview:_view2];
    _workNumberLabel = [UILabel new];
    _workNumberLabel.textColor = [UIColor colorWithHex:0xc5cdd3];
    _workNumberLabel.font = [UIFont systemFontOfSize:kFont10];
    [self addSubview:_workNumberLabel];
}

- (UIView *)littleCircleView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:0xc5cdd3];
    view.layer.cornerRadius = 2.5;
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize fansSize = [_fansNumberLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kFont10) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
    CGSize uploadSize = [_uploadNumberLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kFont10) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
    CGSize workSize = [_workNumberLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kFont10) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:kFont10], NSFontAttributeName, nil] context:NULL].size;
    _userHeaderButton.frame = CGRectMake(kPadding15, (cellHeight - KAvatarWidth) / 2, KAvatarWidth, KAvatarWidth);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + kPadding15, CGRectGetMinY(_userHeaderButton.frame), kUserNameLabelWidth, kFont14+2);
    [_attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_addattention"] forState:UIControlStateNormal];
    [_attentionButton setBackgroundImage:[UIImage imageNamed:@"btn_mutualattention"] forState:UIControlStateSelected];
    CGFloat labelOriginY = CGRectGetMaxY(_userNameLabel.frame) + kPadding5;
    _fansNumberLabel.frame = CGRectMake(kPadding15 + CGRectGetMaxX(_userHeaderButton.frame), labelOriginY, fansSize.width, kFont10);
    _view1.frame = CGRectMake(CGRectGetMaxX(_fansNumberLabel.frame) + kPadding5, labelOriginY + 2.5, 5, 5);
    _uploadNumberLabel.frame = CGRectMake(CGRectGetMaxX(_view1.frame) + kPadding5, labelOriginY, uploadSize.width, kFont10);
    _view2.frame = CGRectMake(CGRectGetMaxX(_uploadNumberLabel.frame) + kPadding5, labelOriginY + 2.5, 5, 5);
    _workNumberLabel.frame = CGRectMake(CGRectGetMaxX(_view2.frame) + kPadding5, labelOriginY, workSize.width, kFont10);
}

- (void)setViewModel:(ATOMFansViewModel *)viewModel {
    
    _viewModel = viewModel;
    [_userHeaderButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:viewModel.avatarURL] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
    _userNameLabel.text = viewModel.userName;
    _fansNumberLabel.text = [NSString stringWithFormat:@"%@粉丝", viewModel.totalFansNumber];
    _uploadNumberLabel.text = [NSString stringWithFormat:@"%@求p", viewModel.totalAskNumber];
    _workNumberLabel.text = [NSString stringWithFormat:@"%@求p", viewModel.totalReplyNumber];

    if (viewModel.isFellow) {
        //已关注
        _attentionButton.selected = YES;
    } else  {
        _attentionButton.selected = NO;
    }
}



@end
