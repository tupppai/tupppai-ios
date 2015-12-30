//
//  PIEChannelViewModel.h
//  TUPAI
//
//  Created by chenpeiwei on 12/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PIEPageVM;
typedef NS_ENUM(NSInteger, PIEChannelType) {
    PIEChannelTypeChannel = 0,
    PIEChannelTypeActivity ,
};

@interface PIEChannelViewModel : NSObject
@property (nonatomic,assign ) NSInteger      ID;
@property (nonatomic,copy   ) NSString       * imageUrl;
@property (nonatomic,copy   ) NSString       * iconUrl;
@property (nonatomic,copy   ) NSString       * url;
@property (nonatomic,copy   ) NSString       * title;
@property (nonatomic,copy   ) NSString       * content;
@property (nonatomic,copy   ) NSString       * banner_pic;
@property (nonatomic,copy   ) NSString       * post_btn;
@property (nonatomic,assign ) NSInteger        askID;
@property (nonatomic,copy   ) NSArray<PIEPageVM *> * threads;
@property (nonatomic,assign ) PIEChannelType channelType;
@end
