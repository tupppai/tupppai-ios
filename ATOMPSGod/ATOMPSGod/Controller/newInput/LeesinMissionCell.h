//
//  PIEMyMissionCell.h
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/6/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIECustomViewFromXib.h"
@class LeesinCheckmarkView;

@interface LeesinMissionCell : PIECustomViewFromXib
@property (nonatomic,strong) PIEPageVM  *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (weak, nonatomic) IBOutlet UIButton *username;
@property (weak, nonatomic) IBOutlet LeesinCheckmarkView *checkmark;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, assign) BOOL selected;

@end
