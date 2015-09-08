//
//  ATOMCollectionViewModel.h
//  ATOMPSGod
//
//  Created by atom on 15/4/8.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATOMAskPage;

@interface ATOMCollectionViewModel : NSObject
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign) NSInteger totalPSNumber;

- (void)setViewModelData:(ATOMAskPage *)homeImage;


@end
