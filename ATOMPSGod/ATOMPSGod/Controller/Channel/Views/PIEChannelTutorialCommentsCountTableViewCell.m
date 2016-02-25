//
//  PIEChannelTutorialCommentsCountTableViewCell.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/27/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelTutorialCommentsCountTableViewCell.h"

@interface PIEChannelTutorialCommentsCountTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *cell_separator_bottom;


@end

@implementation PIEChannelTutorialCommentsCountTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_cell_separator_bottom mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)injectCommentCount:(NSUInteger)count
{
    NSString *prompt =
    [NSString stringWithFormat:@"评论（%ld）",(long)count];
    
    self.commentCountLabel.text = prompt;
}


@end
