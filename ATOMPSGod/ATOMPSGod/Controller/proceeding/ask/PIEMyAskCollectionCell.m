//
//  PIEMyAskCollectionCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEMyAskCollectionCell.h"

@implementation PIEMyAskCollectionCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 6;
    _theImageView.clipsToBounds = YES;
    _contentLabel.text = @"";
}

//put a needle injecting into cell's ass.
- (void)injectSource:(PIEPageVM*)vm {
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    _contentLabel.text = vm.content;
}

@end
