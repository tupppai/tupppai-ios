//
//  PIEBannerViewModel.h
//  TUPAI
//
//  Created by chenpeiwei on 11/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIEBannerViewModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* imageUrl;
//@property (nonatomic, copy) NSString* imageUrl_thumb;
@property (nonatomic, copy) NSString* desc;
@end
