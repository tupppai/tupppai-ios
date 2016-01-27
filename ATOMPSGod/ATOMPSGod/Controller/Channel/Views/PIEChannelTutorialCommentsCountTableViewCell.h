//
//  PIEChannelTutorialCommentsCountTableViewCell.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/27/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PIEChannelTutorialCommentsCountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

- (void)injectCommentCount:(NSUInteger)count;

@end
