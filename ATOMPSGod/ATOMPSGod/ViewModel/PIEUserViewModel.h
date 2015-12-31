//
//  PIEUserViewModel.h
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIEUserModel.h"

@interface PIEUserViewModel : NSObject

@property (nonatomic, strong) PIEUserModel *model;
@property (nonatomic, strong) NSMutableArray *replyPages;
@property (nonatomic, copy  ) NSString  *username;
@property (nonatomic, copy  ) NSString  *avatar;
@property (nonatomic, copy) NSString *followCount;
@property (nonatomic, copy) NSString *fansCount;
@property (nonatomic, copy) NSString *likedCount;
@property (nonatomic, copy) NSString *askCount;
@property (nonatomic, copy) NSString *replyCount;

- (instancetype)initWithEntity:(PIEUserModel*)user;
@end
