//
//  ATOMOtherMessageViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ATOMTopicReplyType = 0,
    ATOMConcernType,
    ATOmInviteType
}ATOMOtherMessageViewModelType;

@interface ATOMOtherMessageViewModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *contentContent;
@property (nonatomic, copy) NSString *contentTime;
@property (nonatomic, copy) NSString *contentImageURL;

- (instancetype)initWithStyle:(ATOMOtherMessageViewModelType)type;

@end
