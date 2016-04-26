//
//  PIECategoryModel.h
//  TUPAI
//
//  Created by chenpeiwei on 12/24/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PIECategoryType) {
    PIECategoryTypeChannel = 0,
    PIECategoryTypeActivity ,
    PIECategoryTypeTutorial,
};
@class PIEPageVM;
@interface PIECategoryModel : PIEBaseModel
@property (nonatomic,strong ) NSNumber       * ID;
@property (nonatomic,strong ) NSNumber       * askID;
@property (nonatomic,assign ) PIECategoryType type;
@property (nonatomic,copy   ) NSString       * imageUrl;
@property (nonatomic,copy   ) NSString       * iconUrl;
@property (nonatomic,copy   ) NSString       * url;
@property (nonatomic,copy   ) NSString       * title;
@property (nonatomic,copy   ) NSString       * content;
@property (nonatomic,copy   ) NSString       * banner_pic;
@property (nonatomic,copy   ) NSString       * post_btn;

@property (nonatomic,copy   ) NSArray<PIEPageVM *> * threads;

@end
