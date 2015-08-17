//
//  kUsernameLabel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/14/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "kfcViews.h"

@implementation kAvatarView
-(instancetype)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = kfcAvatarWidth/2.0;
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
//        self.layer.masksToBounds = YES;
    }
    return self;
}
@end
@implementation kReplierView
-(instancetype)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = kfcReplierWidth / 2;
        self.layer.masksToBounds = YES;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kfcReplierWidth));
            make.height.equalTo(@(kfcReplierWidth));
        }];
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
        self.textColor = [UIColor kfcUsername];
    }
    return self;
}
@end
@implementation kfcCommentLabel
-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.numberOfLines = 0;
    }
    return self;
}
-(void)setInfo:(NSDictionary *)info {
    NSString* username = [info objectForKey:@"username"];
    NSString* comment = [info objectForKey:@"comment"];
    NSInteger nameLength = username.length;
    NSRange range = {0, nameLength + 1};
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont kfcComment], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.5], NSForegroundColorAttributeName, nil];
    NSDictionary *attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont kfcCommentUserName], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.8], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@： %@",username,comment] attributes:attributeDict];
    [attributeStr addAttributes:attributeDict2 range:range];
    self.attributedText = attributeStr;
}

@end
@implementation kPublishTimeLabel
-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.numberOfLines = 0;
        self.font = [UIFont kfcPublishTime];
        self.textColor = [UIColor kfcPublishTime];
    }
    return self;
}
@end

@implementation kfcPublishTypeLabel
-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.numberOfLines = 0;
        self.font = [UIFont kfcPublishType];
        self.textColor = [UIColor kfcPublishType];
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
