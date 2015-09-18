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
}

//put a needle injecting into cell's ass.
- (void)injectSource:(DDPageVM*)vm {
    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
    //    _contentLabel.text = @"";
}


@end
