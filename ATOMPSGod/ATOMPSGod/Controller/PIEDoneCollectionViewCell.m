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
    _theImageView.clipsToBounds = YES;
}

//put a needle injecting juicy sauce into cell's ass.
- (void)injectSauce:(DDPageVM*)vm {
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
    //    _contentLabel.text = @"";
}

@end
