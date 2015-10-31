//
//  PIEFriendAskTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendReplyCollectionViewCell.h"


@implementation PIEFriendReplyCollectionViewCell


- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius = 6;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _blurBottomView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHex:0x000000 andAlpha:0.3] CGColor], (id)[[UIColor colorWithHex:0xffffff andAlpha:0.3] CGColor], nil];
    [_blurBottomView.layer insertSublayer:gradient atIndex:0];
    //    _tipLabel.layer.cornerRadius = 4;
}
- (void)injectSource:(DDPageVM*)vm {
    
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];
    
    _likeCountLabel.text = vm.likeCount;
}

@end
