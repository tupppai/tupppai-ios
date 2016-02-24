//
//  PIEPageCollectionSwipeView.m
//  TUPAI
//
//  Created by chenpeiwei on 2/19/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDHotDetailManager.h"
#import "PIEPageCollectionSwipeView.h"
@interface PIEPageCollectionSwipeView()

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) MASConstraint *askImageView2WidthMasConstraint;


@end
@implementation PIEPageCollectionSwipeView

-(void)setPageViewModel:(PIEPageVM *)pageViewModel {
    _pageViewModel = pageViewModel;
    [self letsgo];
}
-(void)setAskSourceArray:(NSArray *)askSourceArray {
    _askSourceArray = askSourceArray;
    [self reloadAskImageViews];
}
- (void)reloadAskImageViews {
    if (_askSourceArray.count == 0) {
        return;
    }
    PIEPageVM *vm = [_askSourceArray objectAtIndex:0];
//    [_askImageView sd_setImageWithURL:[NSURL URLWithString:vm.imageURL]];
    [DDService sd_downloadImage:vm.imageURL withBlock:^(UIImage *image) {
        _askImageView.image = image;
    }];
    
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
        make.leading.equalTo(self.askImageView.mas_trailing).with.offset(5);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.width.equalTo(@11.5);
        make.leading.equalTo(self.askImageView2.mas_trailing).with.offset(5.5);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.swipeView];
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).with.offset(5.5);
        make.height.equalTo(self);
        make.trailing.equalTo(self);
        make.centerY.equalTo(self);
    }];
}




-(PIEPageCollectionImageView *)askImageView {
    if (!_askImageView) {
        _askImageView = [PIEPageCollectionImageView new];
        _askImageView.userInteractionEnabled = YES;
        _askImageView.image_tag = [UIImage imageNamed:@"pie_origin"];
    }
    return _askImageView;
}

-(UIImageView *)askImageView2 {
    if (!_askImageView2) {
        _askImageView2 = [UIImageView new];
        _askImageView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _askImageView2.contentMode = UIViewContentModeScaleAspectFill;
        _askImageView2.userInteractionEnabled = YES;
        _askImageView2.clipsToBounds = YES;
    }
    return _askImageView2;
}
-(UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = [UIColor whiteColor];
        _iconImageView.image = [UIImage imageNamed:@"pagedetailshuffle"];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
-(SwipeView *)swipeView {
    if (!_swipeView) {
        _swipeView = [SwipeView new];
        _swipeView.backgroundColor = [UIColor whiteColor];
//        _swipeView.dataSource = self;
//        _swipeView.delegate = self;
    }
    return _swipeView;
}
@end
