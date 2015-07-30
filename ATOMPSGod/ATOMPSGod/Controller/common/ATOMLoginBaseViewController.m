//
//  ATOMLoginBaseViewController.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/30/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMLoginBaseViewController.h"

@implementation ATOMLoginBaseViewController
-(void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorEccuredRET) name:@"ErrorOccurred" object:nil];    
}

-(void) errorEccuredRET {
    [Util TextHud:@"出现未知错误" inView:self.view];
}

@end
