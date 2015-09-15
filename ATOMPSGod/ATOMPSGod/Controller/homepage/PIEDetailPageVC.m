//
//  PIEDetailPageVC.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/8/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEDetailPageVC.h"
#import "DDHotDetailManager.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface PIEDetailPageVC ()
@property (weak, nonatomic) IBOutlet UIImageView *blurView;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation PIEDetailPageVC

-(void)awakeFromNib {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBlurredImage];
    [self getDataSource];

    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;

    _carousel.type = iCarouselTypeLinear;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupBlurredImage
{
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    
    dispatch_async(backgroundQueue, ^{
        //Code here is executed asynchronously
        UIImage *theImage = _pageVM.image? :[UIImage imageNamed:@"psps"];
        //create our blurred image
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
        
        //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
        CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            self.blurView.image = [UIImage imageWithCGImage:cgImage];
        }];
        });

    });

}
#pragma mark iCarousel methods
    
    - (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
    {
        return MAX(_dataSource.count,1);
    }
    
    - (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
    {
        DDPageVM* vm = [_dataSource objectAtIndex:index];

        //create new view if no view is available for recycling
        if (view == nil)
        {
            CGFloat width = self.carousel.frame.size.height-60;
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
            view.backgroundColor = [UIColor lightGrayColor];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
        }
        [((UIImageView *)view) setImageWithURL:[NSURL URLWithString:vm.imageURL]];
        return view;
    }
    

    - (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
    {
        //customize carousel display
        switch (option)
        {
            case iCarouselOptionWrap:
            {
                //normally you would hard-code this to YES or NO
                return NO;
            }
            case iCarouselOptionSpacing:
            {
                //add a bit of spacing between the item views
                return value * 1.05f;
            }
            case iCarouselOptionFadeMax:
            {
                if (self.carousel.type == iCarouselTypeCustom)
                {
                    //set opacity based on distance from camera
                    return 0.0f;
                }
                return value;
            }
            case iCarouselOptionShowBackfaces:
            case iCarouselOptionRadius:
            case iCarouselOptionAngle:
            case iCarouselOptionArc:
            case iCarouselOptionTilt:
            case iCarouselOptionCount:
            case iCarouselOptionFadeMin:
            case iCarouselOptionFadeMinAlpha:
            case iCarouselOptionFadeRange:
            case iCarouselOptionOffsetMultiplier:
            case iCarouselOptionVisibleItems:
            {
                return value;
            }
        }
    }
    
#pragma mark -
#pragma mark iCarousel taps
    
    - (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
    {
        NSLog(@"Tapped view number: %zd", index);
    }
    
    - (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
    {
//        NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
    }



- (void)getDataSource {
    _currentPage = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(5) forKey:@"size"];
    DDHotDetailManager *showDetailOfHomePage = [DDHotDetailManager new];
    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:_pageVM.ID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
        //第一张图片为首页点击的图片，剩下的图片为回复图片
        _dataSource = nil;
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:_pageVM];
        for (ATOMDetailPage *detailImage in detailOfHomePageArray) {
            DDPageVM *model = [DDPageVM new];
            [model setViewModelDataWithDetailPage:detailImage];
            [_dataSource addObject:model];
        }
        [_carousel reloadData];
    }];
}

//- (void)getMoreDataSource {
//    WS(ws);
//    ws.currentPage++;
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
//    [param setObject:@(ws.currentPage) forKey:@"page"];
//    [param setObject:@(10) forKey:@"size"];
//    [param setObject:@(_fold) forKey:@"fold"];
//    DDHotDetailManager *showDetailOfHomePage = [DDHotDetailManager new];
//    [showDetailOfHomePage ShowDetailOfHomePage:param withImageID:ws.askVM.ID withBlock:^(NSMutableArray *detailOfHomePageArray, NSError *error) {
//        for (ATOMDetailPage *detailImage in detailOfHomePageArray) {
//            DDHotDetailPageVM *model = [DDHotDetailPageVM new];
//            [model setViewModelDataWithDetailImage:detailImage];
//            model.labelArray = [ws.askVM.labelArray mutableCopy];
//            [ws.dataSource addObject:model];
//        }
//        if (detailOfHomePageArray.count == 0) {
//            _canRefreshFooter = NO;
//        } else {
//            _canRefreshFooter = YES;
//        }
//        [ws.tableView reloadData];
//        [ws.tableView.footer endRefreshing];
//    }];
//}
@end
