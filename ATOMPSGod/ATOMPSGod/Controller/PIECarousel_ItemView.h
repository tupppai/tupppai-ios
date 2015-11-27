//
//  PIECarousel_ItemView.h
//  TUPAI
//
//  Created by chenpeiwei on 11/26/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIECustomViewFromXib.h"
#import "PIEPageLikeButton.h"
#import "PIEPageButton.h"
@interface PIECarousel_ItemView : PIECustomViewFromXib
@property (weak, nonatomic) IBOutlet UIImageView *imageView_type;
@property (weak, nonatomic) IBOutlet UIButton *button_name;
@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet UIButton *button_avatar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_page;
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property (weak, nonatomic) IBOutlet PIEPageButton *pageButton_share;
@property (weak, nonatomic) IBOutlet PIEPageButton *pageButton_comment;
@property (weak, nonatomic) IBOutlet PIEPageLikeButton *pageLikeButton;
@property (nonatomic,strong) PIEPageVM* vm;
@end
