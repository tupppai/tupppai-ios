//
//  PIECarouselViewController3.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECarouselViewController3.h"
#import "iCarousel.h"


@interface PIECarouselViewController3 ()
<
    /* Protocols */
    iCarouselDelegate, iCarouselDataSource
>

@property (nonatomic, strong) iCarousel *iCarousel;

@end

@implementation PIECarouselViewController3

#pragma mark - UI life cycles


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
    
    
    
    [self setupSubviews];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavBar];
}



#pragma mark - UI components setup
- (void)setupSubviews
{
    
}


- (void)setupNavBar
{
    
}

- (void)setupData
{
    
}

#pragma mark - <iCarouselDelegate>

#pragma mark - <iCarouselDataSource>
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 10;
}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil) {
        
    }
    
    return nil;
}

@end
