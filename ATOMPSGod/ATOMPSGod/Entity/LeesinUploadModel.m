//
//  LeesinUploadModel.m
//  TUPAI
//
//  Created by chenpeiwei on 1/8/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "LeesinUploadModel.h"

@implementation LeesinUploadModel
-(instancetype)init {
    self = [super init];
    if (self) {
        _uploadIdArray = [NSMutableArray new];
        _ratioArray = [NSMutableArray new];
        _type = PIEPageTypeAsk;
    }
    return self;
}

@end
