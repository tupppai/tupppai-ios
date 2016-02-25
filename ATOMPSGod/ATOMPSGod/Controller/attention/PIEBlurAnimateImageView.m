//
//  PIEBlurAnimateImageView.m
//  TUPAI
//
//  Created by chenpeiwei on 1/18/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBlurAnimateImageView.h"
#import "PIEModelImage.h"
@interface PIEBlurAnimateImageView()
@property (nonatomic,strong) MASConstraint* thumbWidth_MasContraint;
@property (nonatomic,strong) MASConstraint* thumbHeight_MasContraint;
@end


static int thumbViewSizeConstant = 100;


@implementation PIEBlurAnimateImageView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(void)commonInit {
    
    self.imageView.userInteractionEnabled = YES;
    
    [self addSubview:self.blurBackgroundImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.thumbView];
    
    [self.blurBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.and.bottom.equalTo(self);
        self.thumbWidth_MasContraint    = make.width.equalTo(@(thumbViewSizeConstant));
        self.thumbHeight_MasContraint   = make.height.equalTo(@(thumbViewSizeConstant));
    }];
    

    //setupContraints
}

- (void)animateWithType:(PIEThumbAnimateViewType)type {
    
    if(!self.enlarged) {
        //should enlarge

        [self.thumbWidth_MasContraint setOffset:self.bounds.size.width];
        [self.thumbHeight_MasContraint setOffset:self.bounds.size.height];
        
    } else {
        [self.thumbWidth_MasContraint setOffset:thumbViewSizeConstant];
        [self.thumbHeight_MasContraint setOffset:thumbViewSizeConstant];
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
                         [self.thumbView layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }
     ];
    [self.thumbView animateWithType:type];
    self.enlarged = !self.enlarged;
}

-(void)prepareForReuse {
    if(self.enlarged) {
        [self.thumbWidth_MasContraint setOffset:thumbViewSizeConstant];
        [self.thumbHeight_MasContraint setOffset:thumbViewSizeConstant];
        self.enlarged = NO;
        [self.thumbView prepareForReuse];
    }
    self.thumbView.leftView.image = nil;
    self.thumbView.rightView.image = nil;
    self.blurBackgroundImageView.image = nil;
    self.imageView.image = nil;
}


-(void)setViewModel:(PIEPageVM *)viewModel {
    _viewModel = viewModel;
    [DDService sd_downloadImage:viewModel.imageURL withBlock:^(UIImage *image) {
        _imageView.image = image;
        _blurBackgroundImageView.image = [image blurredImageWithRadius:30 iterations:1 tintColor:nil];
    }];
    
    
    _thumbView.subviewCounts = viewModel.models_image.count;
    
    if (viewModel.models_image.count > 0) {
        PIEModelImage* entity = [viewModel.models_image objectAtIndex:0];
        NSString *urlString_imageView1 = [entity.url trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
        [self.thumbView.rightView sd_setImageWithURL:[NSURL URLWithString:urlString_imageView1] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
        if (viewModel.models_image.count == 2) {
            NSString *urlString_imageView2 = [viewModel.models_image[1].url trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
            [_thumbView.leftView sd_setImageWithURL:[NSURL URLWithString:urlString_imageView2] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
        } else {
            _thumbView.leftView.image = nil;
        }
    }
}
-(UIImageView *)blurBackgroundImageView {
    if (!_blurBackgroundImageView) {
        _blurBackgroundImageView = [UIImageView new];
        _blurBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _blurBackgroundImageView.clipsToBounds = YES;
    }
    return _blurBackgroundImageView;
}

-(PIEThumbAnimateView *)thumbView {
    if (!_thumbView) {
        _thumbView = [PIEThumbAnimateView new];
    }
    return _thumbView;
}
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
