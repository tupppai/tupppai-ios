//
//  PIEPageCollectionSwipeView.m
//  TUPAI
//
//  Created by chenpeiwei on 2/19/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "SwipeView.h"
#import "DDHotDetailManager.h"
#import "PIEPageCollectionSwipeView.h"
@interface PIEPageCollectionSwipeView()<SwipeViewDataSource,SwipeViewDelegate>
@property (nonatomic,strong) UIImageView *askImageView;
@property (nonatomic,strong) UIImageView *askImageView2;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) SwipeView *swipeView;
@property (nonatomic,strong) MASConstraint *askImageView2WidthMasConstraint;


@property (nonatomic,strong) NSArray *replySourceArray;
@property (nonatomic,strong) NSArray *askSourceArray;
@end
@implementation PIEPageCollectionSwipeView

-(void)setPageViewModel:(PIEPageVM *)pageViewModel {
    _pageViewModel = pageViewModel;
    [self letsgo];
    
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:@(SCREEN_WIDTH_RESOLUTION) forKey:@"width"];
        [param setObject:@(1) forKey:@"page"];
        [param setObject:@(100) forKey:@"size"];
        DDHotDetailManager *manager = [DDHotDetailManager new];
        [manager fetchAllReply:param ID:_pageViewModel.askID withBlock:^(NSMutableArray *askArray, NSMutableArray *replyArray) {
            _replySourceArray = replyArray;
            _askSourceArray = askArray;
            [self reloadAskImageViews];
            [self.swipeView reloadData];
        }];
    
}

- (void)reloadAskImageViews {
    if (_askSourceArray.count == 0) {
        return;
    }
    PIEPageVM *vm = [_askSourceArray objectAtIndex:0];
    [_askImageView sd_setImageWithURL:[NSURL URLWithString:vm.imageURL]];
    
    if (_askSourceArray.count != 2) {
        return;
    }
    
    PIEPageVM *vm2 = [_askSourceArray objectAtIndex:1];
    [_askImageView2 sd_setImageWithURL:[NSURL URLWithString:vm2.imageURL]];
}
- (void)letsgo {
    
    [self addSubview:self.askImageView];
    [self.askImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.width.equalTo(self.askImageView.mas_height);
        make.leading.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.askImageView2];
    
    [self.askImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        if (_pageViewModel.models_image.count == 2) {
            make.width.equalTo(self.askImageView2.mas_height);
        } else {
            make.width.equalTo(@0);
        }
        make.leading.equalTo(self.askImageView.mas_trailing);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.width.equalTo(@10);
        make.leading.equalTo(self.askImageView2.mas_trailing);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.swipeView];
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing);
        make.height.equalTo(self);
        make.trailing.equalTo(self);
        make.centerY.equalTo(self);
    }];
}


#pragma mark iCarousel methods


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    
    return _replySourceArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
        CGFloat width = self.swipeView.frame.size.height;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width+10, width)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, width, width)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imageView];
    }
    PIEPageVM* vm = [_replySourceArray objectAtIndex:index];
    for (UIView *subView in view.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imageView = (UIImageView *)subView;
            [imageView sd_setImageWithURL:[NSURL URLWithString:vm.imageURL]];
        }
    }
    ;
    return view;
}

-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {

//    PIEPageVM* vm = [_replySourceArray objectAtIndex:index];
}


-(UIImageView *)askImageView {
    if (!_askImageView) {
        _askImageView = [UIImageView new];
        _askImageView.backgroundColor = [UIColor greenColor];
    }
    return _askImageView;
}

-(UIImageView *)askImageView2 {
    if (!_askImageView2) {
        _askImageView2 = [UIImageView new];
        _askImageView.backgroundColor = [UIColor redColor];
    }
    return _askImageView2;
}
-(UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}
-(SwipeView *)swipeView {
    if (!_swipeView) {
        _swipeView = [SwipeView new];
        _swipeView.backgroundColor = [UIColor greenColor];
        _swipeView.dataSource = self;
        _swipeView.delegate = self;
    }
    return _swipeView;
}
@end
