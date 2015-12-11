//
//  PIEChannelBannerCell.m
//  TUPAI
//
//  Created by huangwei on 15/12/4.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import "PIEChannelBannerCell.h"

@implementation PIEChannelBannerCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    [_leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
//    [_leftButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
//
//    [_rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
//    [_rightbutton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];

//    _leftButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    _rightbutton.imageView.contentMode = UIViewContentModeScaleToFill;
//    [_leftButton setImage:[UIImage imageNamed:@"pieChannelBannerCellButton2"] forState:UIControlStateNormal];
//    [_rightbutton setImage:[UIImage imageNamed:@"pieChannelBannerCellButton1"] forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Target-actions
- (IBAction)bannerCellDidClickLeftButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(channelBannerCell:didClickLeftButton:)]) {
        [self.delegate channelBannerCell:self
                      didClickLeftButton:sender];
    }
    
}
- (IBAction)bannerCellDidClickRightButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(channelBannerCell:didClickRightButton:)]) {
        [self.delegate channelBannerCell:self
                     didClickRightButton:sender];
    }

}

#pragma mark - Reuse methods
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    /**
     *  set delegate to nil while cell is being reused.
     */
    self.delegate = nil;
}

- (void)dealloc
{
    self.delegate = nil;
}



@end
