//
//  ATOMAskViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/4/7.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMHomeImage;

@interface ATOMAskViewModel : NSObject

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *totalPSNumber;

- (void)setViewModelData:(ATOMHomeImage *)homeImage;

@end
