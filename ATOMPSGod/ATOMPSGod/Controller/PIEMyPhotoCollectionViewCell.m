//
//  PIECollectionViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/7/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyPhotoCollectionViewCell.h"

@implementation PIEMyPhotoCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _tipLabel.layer.cornerRadius = 4;
    _tipLabel.clipsToBounds = YES;
    _tipLabel.backgroundColor = [UIColor pieYellowColor];
    _tipLabel.textColor = [UIColor darkGrayColor];
    
    _likeCountLabel.layer.cornerRadius = 4;
    _likeCountLabel.clipsToBounds = YES;
    _likeCountLabel.backgroundColor = [UIColor pieYellowColor];
    _likeCountLabel.textColor = [UIColor darkGrayColor];
}
- (void)injectSauce:(DDPageVM*)vm {
    
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];
    if (vm.type == PIEPageTypeAsk) {
        _tipLabel.text = @"求P";
        _likeView.hidden = YES;
        _likeCountLabel.hidden = YES;
    }
    else {
        _tipLabel.text = @"作品";
        _likeView.hidden = NO;
        _likeCountLabel.hidden = NO;
        _likeCountLabel.text = vm.likeCount;
    }
    
}
@end
