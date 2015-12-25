//
//  PIENotificationVM.m
//  TUPAI
//
//  Created by chenpeiwei on 10/15/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIENotificationVM.h"

@implementation PIENotificationVM
-(instancetype)initWithEntity:(PIEModelNotification *)entity {
    self = [super init];
    if (self) {
        _avatarUrl          = entity.avatarUrl;
        _commentId          = entity.commentId;
        _content            = entity.content;
        _ID                 = entity.ID;
        _username           = entity.username;
        _imageUrl           = entity.imageUrl;
        _senderID           = entity.senderID;
        _targetID           = entity.targetID;
        _targetType         = entity.targetType;
        _type               = entity.type;
        _askID              = entity.askID;
        _replyID            = entity.replyID;

        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:entity.time];
        _time               = [Util formatPublishTime:publishDate];
    }
    return self;
}
@end
