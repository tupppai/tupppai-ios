//
//  PIEChannelTableViewCell.m
//  TUPAI-DEMO
//
//  Created by huangwei on 15/12/4.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//

#import "PIEChannelTableViewCell.h"

@implementation PIEChannelTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.swipeView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

#pragma mark - Setters for View models
-(void)setVm:(PIEChannelViewModel *)vm {
    _vm = vm;
    NSString* urlString = [vm.imageUrl trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
    [_imageView_banner sd_setImageWithURL:[NSURL URLWithString:urlString]];
}

@end
