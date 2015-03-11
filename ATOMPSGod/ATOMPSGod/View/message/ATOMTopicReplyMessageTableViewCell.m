//
//  ATOMTopicReplyMessageTableViewCell.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMTopicReplyMessageTableViewCell.h"

@implementation ATOMTopicReplyMessageTableViewCell

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
    _userHeaderButton.backgroundColor = [UIColor redColor];
    _userHeaderButton.layer.cornerRadius = 22.5;
    _userHeaderButton.layer.masksToBounds = YES;
    [self addSubview:_userHeaderButton];
    
    _userSexImageView = [UIImageView new];
    [self addSubview:_userSexImageView];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.textColor = [UIColor colorWithHex:0x00adef];
    _userNameLabel.font = [UIFont systemFontOfSize:20.f];
    [self addSubview:_userNameLabel];
    
    _topicReplyContentLabel = [UILabel new];
    _topicReplyContentLabel.text = @"处理了你的图片";
    _topicReplyContentLabel.textColor = [UIColor colorWithHex:0x828282];
    _topicReplyContentLabel.font = [UIFont systemFontOfSize:20.f];
    [self addSubview:_topicReplyContentLabel];
    
    _topicReplyTimeLabel = [UILabel new];
    _topicReplyTimeLabel.font = [UIFont systemFontOfSize:10.f];
    _topicReplyTimeLabel.textColor = [UIColor colorWithHex:0x797979];
    [self addSubview:_topicReplyTimeLabel];
    
    _workImageView = [UIImageView new];
    _workImageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_workImageView];
    
    [self test];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userHeaderButton.frame = CGRectMake(padding10, padding20, 45, 45);
    _userSexImageView.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) - 17, CGRectGetMaxY(_userHeaderButton.frame) - 17, 17, 17);
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, padding10, SCREEN_WIDTH - padding10 * 4 - 75 - 45, 30);
    _topicReplyContentLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_userNameLabel.frame), SCREEN_WIDTH - padding10 * 4 - 75 - 45, 30);
    _topicReplyContentLabel.backgroundColor = [UIColor yellowColor];
    _topicReplyTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userHeaderButton.frame) + padding10, CGRectGetMaxY(_topicReplyContentLabel.frame), 80, 15);
    _workImageView.frame = CGRectMake(SCREEN_WIDTH - padding10 - 75, padding10, 75, 75);
}

- (void)test {
    _userNameLabel.text = @"atom";
    _topicReplyTimeLabel.text = @"10月12号 11:00";
    _userSexImageView.image = [UIImage imageNamed:@"woman"];
    [self setNeedsLayout];
}


@end
