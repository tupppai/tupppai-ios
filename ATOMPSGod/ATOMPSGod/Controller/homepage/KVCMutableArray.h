//
//  KVCMutableArray.h
//  TUPAI
//
//  Created by chenpeiwei on 11/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVCMutableArray : NSObject
@property (nonatomic, strong) NSMutableArray *array;
-(NSUInteger)countOfArray;

-(id)objectInArrayAtIndex:(NSUInteger)index;

-(void)insertObject:(id)object inArrayAtIndex:(NSUInteger)index;
- (void)addObject:(id )object ;
-(void)removeObjectFromArrayAtIndex:(NSUInteger)index;
-(void)addArrayObject:(NSArray *)object ;
-(void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(id)object;
@end
