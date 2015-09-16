//
//  PIEAskCollectionCell.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/16/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEAskCollectionCell.h"

@implementation PIEAskCollectionCell

- (void)awakeFromNib {
    // Initialization code
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
}

@end
