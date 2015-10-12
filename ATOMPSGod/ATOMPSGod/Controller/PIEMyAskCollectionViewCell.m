//
//  PIEMyAskCollectionViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyAskCollectionViewCell.h"

@implementation PIEMyAskCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius = 8;
}
- (void)injectSauce:(DDPageVM*)vm {
    
    [_pageImgaeView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];
    
}
@end
