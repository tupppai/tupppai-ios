//
//  PIEUploadModel.h
//  TUPAI
//
//  Created by chenpeiwei on 12/28/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIEUploadModel : NSObject

@property (nonatomic,copy) NSString* content;

@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger ask_id;
@property (nonatomic,assign) NSInteger channel_id;
@property (nonatomic,assign) PIEPageType type;

@property (nonatomic,strong) NSMutableArray* imageArray;
@property (nonatomic, strong) NSMutableArray *uploadIdArray;
@property (nonatomic, strong) NSMutableArray *ratioArray;
@property (nonatomic,copy) NSArray* tagIDArray;


@end
