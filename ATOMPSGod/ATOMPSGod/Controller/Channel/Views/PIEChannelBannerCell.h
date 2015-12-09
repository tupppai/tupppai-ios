//
//  PIEChannelBannerCell.h
//  TUPAI-DEMO
//
//  Created by huangwei on 15/12/4.
//  Copyright (c) 2015年 huangwei. All rights reserved.
//



#import <UIKit/UIKit.h>

@class PIEChannelBannerCell;

@protocol PIEChannelBannerCellDelegate <NSObject>

@required
- (void)channelBannerCell:(PIEChannelBannerCell *)channelBannerCell
       didClickLeftButton:(UIButton *)button;

- (void)channelBannerCell:(PIEChannelBannerCell *)channelBannerCell
      didClickRightButton:(UIButton *)button;

@end

@interface PIEChannelBannerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightbutton;
@property (nonatomic, weak) id <PIEChannelBannerCellDelegate> delegate;

@end
