//
//  ATOMReplyViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMAskPage;

@interface ATOMReplyViewModel : NSObject

@property (nonatomic, copy) NSString *imageURL;

- (void)setViewModelData:(ATOMAskPage *)homeImage;


@end
