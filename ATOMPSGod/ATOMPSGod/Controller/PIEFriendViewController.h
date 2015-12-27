//
//  PIEFriendViewController.h
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEFriendViewController : DDBaseVC
@property (nonatomic, strong) PIEPageVM* pageVM;

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) PIEUserModel* user;

@end
