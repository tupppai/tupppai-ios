//
//  KVCMutableArray.m
//  TUPAI
//
//  Created by chenpeiwei on 11/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "KVCMutableArray.h"

@implementation KVCMutableArray
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [[NSMutableArray alloc] init];
    }
    return self;
}


-(NSUInteger)countOfArray{
    return self.array.count;
}


-(id)objectInArrayAtIndex:(NSUInteger)index{
    return [self.array objectAtIndex:index];
}
-(void)addObject:(id)object {
    [self.array addObject:object];
}
-(void)insertObject:(id)object inArrayAtIndex:(NSUInteger)index {
    [self.array insertObject:object atIndex:index];
}


-(void)removeObjectFromArrayAtIndex:(NSUInteger)index{
    [self.array removeObjectAtIndex:index];
}
-(void)addArrayObject:(NSArray *)object {
    [self.array addObjectsFromArray:object];
}
-(void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(id)object{
    [self.array replaceObjectAtIndex:index withObject:object];
}
@end
