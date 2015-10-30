//
//  PIEFriendAskTableViewCell.m
//  TUPAI
//
//  Created by chenpeiwei on 10/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendReplyCollectionViewCell.h"


@implementation PIEFriendReplyCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.cornerRadius = 10;
        _theImageView = [UIImageView new];
        _theImageView.layer.cornerRadius = 6;
        _theImageView.clipsToBounds = YES;
        _theImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_theImageView];
        [_theImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;

}

//put a needle injecting into cell's ass.
- (void)injectSource:(DDPageVM*)vm {

    [_theImageView setImageWithURL:[NSURL URLWithString:vm.imageURL]placeholderImage:[UIImage imageNamed:@"cellBG"]];

}
@end
