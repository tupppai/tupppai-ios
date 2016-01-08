//
//  ViewController.h
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEChannelViewModel.h"

typedef NS_ENUM(NSUInteger, LeesinViewControllerType) {
    LeesinViewControllerTypeAsk = 0,
    LeesinViewControllerTypeReply,
};

@interface LeesinViewController : UIViewController
@property (nonatomic,assign)LeesinViewControllerType type;
@property (nonatomic, strong)PIEChannelViewModel *channelViewModel;

@end

