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
    _leftButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _rightbutton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _leftButton.imageView.clipsToBounds = YES;
    _rightbutton.imageView.clipsToBounds = YES;
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
