//
//  PIEMyAskCollectionViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEImageCollectionViewCell.h"

@implementation PIEImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius = 4;
}
- (void)injectSauce:(PIEPageVM*)vm {
    
    [_pageImgaeView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];
    
}
@end
