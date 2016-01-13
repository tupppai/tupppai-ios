//
//  LeesinUploadModel.h
//  TUPAI
//
//  Created by chenpeiwei on 1/8/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeesinUploadModel : NSObject
//@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger ask_id;
@property (nonatomic,assign) NSInteger channel_id;
@property (nonatomic,assign) PIEPageType type;

@property (nonatomic,copy) NSString* content;
@property (nonatomic,copy) NSOrderedSet* imageArray;
@property (nonatomic,copy) NSArray* tagIDArray;

@property (nonatomic, strong) NSMutableArray *uploadIdArray;
@property (nonatomic, strong) NSMutableArray *ratioArray;
@end
