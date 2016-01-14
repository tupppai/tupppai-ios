//
//  PIENotificationCommentFromOtherTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/14/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationCommentFromOtherTableViewCell.h"
#import "PIENotificationVM.h"

@implementation PIENotificationCommentFromOtherTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle      = UITableViewCellSelectionStyleNone;
    
    _usernameLabel.textColor = [UIColor colorWithHex:0x000000 andAlpha:1.0];
    _contentLabel.textColor  = [UIColor colorWithHex:0x000000 andAlpha:0.9];
    _timeLabel.textColor     = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    _replyLabel.textColor    = [UIColor colorWithHex:0xff6d3f andAlpha:1.0];

    
    _usernameLabel.font      = [UIFont lightTupaiFontOfSize:13];
    _contentLabel.font       = [UIFont lightTupaiFontOfSize:14];
    _replyLabel.font         = [UIFont lightTupaiFontOfSize:12];
    _timeLabel.font          = [UIFont lightTupaiFontOfSize:10];
 
    

    _originalCommentLabel.textColor       = [UIColor colorWithHex:0x797979];
    _originalCommentLabel.font            = [UIFont lightTupaiFontOfSize:12];
 
    _avatarView.layer.cornerRadius        = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds             = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectSauce:(PIENotificationVM*)vm {
    NSString* avatarUrl    = [vm.avatarUrl trimToImageWidth:_avatarView.frame.size.width*SCREEN_SCALE];
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:avatarUrl]placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    _usernameLabel.text          = vm.username;
    _timeLabel.text              = vm.time;
    _contentLabel.text           = vm.content;
    
    
    
    NSString *orignalCommentText = [NSString stringWithFormat:@"回复我的评论：%@", vm.desc];
    _originalCommentLabel.text   = orignalCommentText;
    
}
@end
