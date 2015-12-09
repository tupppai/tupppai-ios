//
//  PIEChannelDetailLatestPSCell.m
//  TUPAI
//
//  Created by huangwei on 15/12/8.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEChannelDetailLatestPSCell.h"
#import "SwipeView.h"

@implementation PIEChannelDetailLatestPSCell

- (void)awakeFromNib {
    // Initialization code
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // configure _swipeView
    _swipeView.alignment         = SwipeViewAlignmentCenter;
    _swipeView.pagingEnabled     = YES;
    _swipeView.itemsPerPage      = 1;
    _swipeView.truncateFinalPage = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Reuse cycles
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // set delegate & dataSource to nil, in case of wild pointers
    _swipeView.delegate   = nil;
    _swipeView.dataSource = nil;
}

- (void)dealloc
{
    _swipeView.delegate   = nil;
    _swipeView.dataSource = nil;
}

@end
