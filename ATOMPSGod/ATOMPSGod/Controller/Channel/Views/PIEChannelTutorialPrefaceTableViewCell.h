//
//  PIEChannelTutorialPrefaceTableViewCell.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIEChannelTutorialModel;
@interface PIEChannelTutorialPrefaceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tutorialTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tutorialSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *loveCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *clickCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;

- (void)injectModel:(PIEChannelTutorialModel *)tutorialModel;

@end
