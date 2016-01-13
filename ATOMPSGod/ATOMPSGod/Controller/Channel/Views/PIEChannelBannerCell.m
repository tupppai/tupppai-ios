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
    _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _leftButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    _rightbutton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _rightbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _rightbutton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;


}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"initWithCoder");
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)tapLeft:(id)sender {
    if ([self.delegate respondsToSelector:@selector(channelBannerCell:didClickLeftButton:)]) {
        [self.delegate channelBannerCell:self
                      didClickLeftButton:sender];
    }
}


- (IBAction)tapRight:(id)sender {
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
