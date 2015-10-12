//
//  PIECollectionViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/7/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyReplyCollectionViewCell.h"

@implementation PIEMyReplyCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
//    _tipLabel.layer.cornerRadius = 4;
}
- (void)injectSauce:(DDPageVM*)vm {
    
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];

        _likeCountLabel.text = vm.likeCount;    
}
@end
