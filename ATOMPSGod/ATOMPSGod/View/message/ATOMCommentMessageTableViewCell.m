//
//  ATOMCommentMessageTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCommentMessageTableViewCell.h"
#import "ATOMCommentMessageViewModel.h"

@implementation ATOMCommentMessageTableViewCell

static int padding20 = 20;
static int padding10 = 10;


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
    _userHeaderButton.backgroundColor = [UIColor redColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [UIImageView new];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [UILabel new];
    [self addSubview:_userNameLabel];
    
    _replyContentLabel = [UILabel new];
    _replyContentLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:_replyContentLabel];
    
    _replyTimeLabel = [UILabel new];
    _replyTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _replyTimeLabel.textColor = [UIColor colorWithHex:0x797979];
    [self addSubview:_replyTimeLabel];
    
    _workImageView = [UIImageView new];
    _workImageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_workImageView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(padding10, padding20, 45, 45);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - SEXRADIUS, CGRectGetMaxY(_userHeaderButton.frame) - SEXRADIUS, SEXRADIUS, SEXRADIUS);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, padding20, SCREEN_WIDTH - padding10 * 4 - 75 - 45, 20);
    _replyContentLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userNameLabel.frame), SCREEN_WIDTH - padding10 * 4 - 75 - 45, 30);
    _replyTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_replyContentLabel.frame), 80, 15);
    _workImageView.frame = CGRectMake(SCREEN_WIDTH - padding10 - 75, padding10, 75, 75);
}

+ (CGFloat)calculateCellHeightWithModel:(ATOMCommentMessageViewModel *)viewModel {
    return 95;
}

- (void)setCommentMessageViewModel:(ATOMCommentMessageViewModel *)commentMessageViewModel {
    _commentMessageViewModel = commentMessageViewModel;
    NSInteger nameLength = _commentMessageViewModel.userName.length;
    NSRange range = {0,nameLength};
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.f], NSFontAttributeName, [UIColor colorWithHex:0x797979], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 回复你",_commentMessageViewModel.userName] attributes:attributeDict];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x00adef] range:range];
    _userNameLabel.attributedText = attributeStr;
    _replyContentLabel.text = _commentMessageViewModel.repplyContent;
    _replyTimeLabel.text = _commentMessageViewModel.repplyTime;
    _userSexImageView.image = [UIImage imageNamed:_commentMessageViewModel.userSex];
    [self setNeedsLayout];
}



































@end
