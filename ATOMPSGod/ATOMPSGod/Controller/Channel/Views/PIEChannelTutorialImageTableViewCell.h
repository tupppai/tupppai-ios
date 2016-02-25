//
//  PIEChannelTutorialImageTableViewCell.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/25/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIEChannelTutorialImageModel;

@interface PIEChannelTutorialImageTableViewCell : UITableViewCell
@property (weak, nonatomic)   IBOutlet UIImageView *tutorialImageView;

@property (assign, nonatomic) BOOL locked;

- (void)injectImageModel:(PIEChannelTutorialImageModel *)tutorialImageModel;

@end
