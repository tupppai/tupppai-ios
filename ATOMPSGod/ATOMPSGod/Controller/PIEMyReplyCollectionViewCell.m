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
    self.layer.cornerRadius = 6;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _blurBottomView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithHex:0x000000 andAlpha:0.5] CGColor], nil];
    [_blurBottomView.layer insertSublayer:gradient atIndex:0];
//    _tipLabel.layer.cornerRadius = 4;
}
- (void)injectSauce:(DDPageVM*)vm {
    
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];

        _likeCountLabel.text = vm.likeCount;    
}
@end
