//
//  PIECarouselViewController3.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECustomPresentViewController.h"

@interface PIECarouselViewController3 : PIECustomPresentViewController

@property (nonatomic, strong) NSArray<PIEPageVM *> *pageVMs;

- (void)scrollToIndex:(NSInteger)index;

@property (nonatomic, assign) NSInteger hideDetailButtonIndex;
@end
