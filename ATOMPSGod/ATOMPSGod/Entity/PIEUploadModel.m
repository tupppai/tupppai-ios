//
//  PIEUploadModel.m
//  TUPAI
//
//  Created by chenpeiwei on 12/28/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEUploadModel.h"

@implementation PIEUploadModel

-(instancetype)init {
    self = [super init];
    if (self) {
        _imageArray = [NSMutableArray new];
        _uploadIdArray = [NSMutableArray new];
        _ratioArray = [NSMutableArray new];
        _type = PIEPageTypeAsk;
    }
    return self;
}

//- (id)copyWithZone:(NSZone *)zone
//{
//    id copy = [[[self class] alloc] init];
//    
//    if (copy)
//    {
//        // Copy NSObject subclasses
//        [copy setAsk_id:[self.ask_id copyWithZone:zone]];
//        
//        // Set primitives
//    }
//    
//    return copy;
//}

@end
