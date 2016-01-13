//
//  PIEUploadAssetCell.m
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/5/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "LeesinAssetCell.h"
#import "LeesinCheckmarkView.h"
#import "Masonry.h"
@interface LeesinAssetCell()
@property (nonatomic, strong) LeesinCheckmarkView *checkmarkView;

@end
@implementation LeesinAssetCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        _selected = NO;
        [self addSubview:self.imageView];
        [self addSubview:self.checkmarkView];
        [self.checkmarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@17);
            make.height.equalTo(@17);
            make.top.equalTo(self).with.offset(5);
            make.trailing.equalTo(self.imageView).with.offset(-5);
        }];
        
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 5);

        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(inset);
        }];
        
        [self layoutIfNeeded];
    }
    return self;
}

-(void)setSelected:(BOOL)selected {
    if (_selected == selected) {
        return;
    }
    _selected = selected;
    _checkmarkView.selected = selected;
}
-(LeesinCheckmarkView *)checkmarkView {
    if (!_checkmarkView) {
        _checkmarkView = [LeesinCheckmarkView new];
    }
    return _checkmarkView;
}
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

-(UIImage *)image {
    return _imageView.image;
}
-(void)setImage:(UIImage *)image {
    _imageView.image = image;
}
@end
