//
//  PIEDoneCollectionViewCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEDoneCollectionViewCell.h"

@implementation PIEDoneCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius = 6;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _blurBottomView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithHex:0x000000 andAlpha:0.5] CGColor], nil];
    [_blurBottomView.layer insertSublayer:gradient atIndex:0];
    //    _tipLabel.layer.cornerRadius = 4;
}

//put a needle injecting juicy sauce into cell's ass.
- (void)injectSauce:(PIEPageVM*)vm {
    [_theImageView sd_setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    
    _likeCountLabel.text = vm.likeCount;
}

@end
