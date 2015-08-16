//
//  kUsernameLabel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/14/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "PageComonSubviews.h"

@implementation kAvatarView
-(instancetype)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = KAvatarWidth/2.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}
@end
@implementation kImageView
-(instancetype)init {
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}
@end

@implementation kUsernameLabel
-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.numberOfLines = 0;
        self.font = [UIFont fontWithName:kUserNameFont size:kUsernameFontSize];
        self.textColor = [UIColor kfcUsernameColor];
    }
    return self;
}
@end

@implementation kPublishTimeLabel
-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.numberOfLines = 0;
        self.font = [UIFont systemFontOfSize:kPublishTimeFontSizeBig];
        self.textColor = [UIColor kfcPublishTimeColor];
    }
    return self;
}
@end
@implementation kGapView
-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    }
    return self;
}
@end
