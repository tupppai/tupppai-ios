//
//  ViewController.h
//  newInput
//
//  Created by chenpeiwei on 1/4/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEChannelViewModel.h"
@class  LeesinViewController;
@protocol LeesinViewControllerDelegate <NSObject>

@optional
- (void)leesinViewController:(LeesinViewController *)leesinViewController uploadPercentage:(CGFloat)percentage uploadSucceed:(BOOL)success;
@end


typedef NS_ENUM(NSUInteger, LeesinViewControllerType) {
    LeesinViewControllerTypeAsk = 0,
    LeesinViewControllerTypeReply,
    LeesinViewControllerTypeReplyNoMissionSelection
};

@interface LeesinViewController : UIViewController

@property (nonatomic, weak) id<LeesinViewControllerDelegate> delegate;

@property (nonatomic,assign)LeesinViewControllerType type;
@property (nonatomic, strong)PIEChannelViewModel *channelViewModel;
@property (nonatomic, strong)PIEPageVM *pageViewModel;

@property (nonatomic, weak) id<PWRefreshBaseTableViewDelegate> psDelegate;

@end

