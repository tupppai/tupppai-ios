//
//  LeesinPreviewToolBar.m
//  PIEGrowingTextInput
//
//  Created by chenpeiwei on 1/7/16.
//  Copyright © 2016 chenpeiwei. All rights reserved.
//

#import "LeesinPreviewBar.h"
#import "Masonry.h"
#import <Photos/Photos.h>

@interface LeesinPreviewBar()

@property (nonatomic, strong) UIImageView *previewImageView1;
@property (nonatomic, strong) UIImageView *previewImageView2;
@property (nonatomic, strong) MASConstraint *previewImageView1MarginLC;
//@property (nonatomic, strong) MASConstraint *previewImageView1WC;

@end

@implementation LeesinPreviewBar

- (id)init
{
    if (self = [super init]) {
        [self pie_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self pie_commonInit];
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    [self addBottomLine];
}

- (void)pie_commonInit
{
    self.backgroundColor = [UIColor colorWithHex:0xeeeeee andAlpha:0.98];
    [self addSubview:self.previewImageView1];
    [self addSubview:self.previewImageView2];
    
    [self pie_setupViewConstraints];
    [self.previewImageView1 addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    UITapGestureRecognizer * tapImage1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage1)];
    UITapGestureRecognizer * tapImage2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage2)];

    self.previewImageView1.userInteractionEnabled = YES;
    self.previewImageView2.userInteractionEnabled = YES;
    
    [self.previewImageView1 addGestureRecognizer:tapImage1];
    [self.previewImageView2 addGestureRecognizer:tapImage2];


}

- (void)tapImage1 {
    if (_delegate && [_delegate respondsToSelector:@selector(leesinPreviewBar:didTapImage1:didTapImage2:)]) {
        if (self.previewImageView1.image) {
            [_delegate leesinPreviewBar:self didTapImage1:YES didTapImage2:NO];
        }
    }
}

- (void)tapImage2 {
    if (_delegate && [_delegate respondsToSelector:@selector(leesinPreviewBar:didTapImage1:didTapImage2:)]) {
        if (self.previewImageView2.image) {
            [_delegate leesinPreviewBar:self didTapImage1:NO didTapImage2:YES];
        }
    }
}

-(void)dealloc {
    [_previewImageView1 removeObserver:self forKeyPath:@"image"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString: @"image"]) {
        UIImage* image = [change objectForKey:@"new"];
        if (![image isKindOfClass:[UIImage class]]) {
            [_previewImageView1MarginLC setOffset:-25];
        } else {
            [_previewImageView1MarginLC setOffset:9];

        }
        
        [self layoutIfNeeded];

    }
}


- (void) pie_setupViewConstraints {
    //    CGSize buttonSize1 = [self pie_appropriateButtonSize:self.button_album];
    //    CGSize buttonSize2 = [self pie_appropriateButtonSize:self.button_shoot];
    //    CGSize buttonSize3 = [self pie_appropriateButtonSize:self.button_confirm];
    
    [self.previewImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(6);
        make.bottom.equalTo(self).with.offset(-7);
        _previewImageView1MarginLC = make.leading.equalTo(self).with.offset(9);
        make.width.equalTo(self.previewImageView1.mas_height).with.priorityHigh();
    }];
    
    
    [self.previewImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(6);
        make.bottom.equalTo(self).with.offset(-7);
        make.leading.equalTo(self.previewImageView1.mas_trailing).with.offset(6);
        make.width.equalTo(_previewImageView1.mas_height);
    }];
}
-(UIImageView *)previewImageView1 {
    if (!_previewImageView1) {
        _previewImageView1 = [UIImageView new];
        _previewImageView1.contentMode = UIViewContentModeScaleAspectFill;
        _previewImageView1.clipsToBounds = YES;
    }
    return _previewImageView1;
}

-(UIImageView *)previewImageView2 {
    if (!_previewImageView2) {
        _previewImageView2 = [UIImageView new];
        _previewImageView2.contentMode = UIViewContentModeScaleAspectFill;
        _previewImageView2.clipsToBounds = YES;
    }
    return _previewImageView2;
}



- (void)clear {
    _source = nil;
//    _sourceAsset_reply = nil;
//    _sourceMission_reply = nil;
    _previewImageView1.image = nil;
    _previewImageView2.image = nil;
}

- (BOOL)hasSourceMission {
    for (id object in _source) {
        if ([object isKindOfClass:[PIEPageVM class]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasSourcePHAsset {
    for (id object in _source) {
        if ([object isKindOfClass:[PHAsset class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)clearReplyImage {
    int index = 0;
    for (id object in _source) {
        if ([object isKindOfClass:[PHAsset class]]) {
            break;
        }
        index++;
    }
    [_source removeObjectAtIndex:index];
    _previewImageView2.image = nil;
}

- (void)clearReplyUrl {
    int index = 0;
    for (id object in _source) {
        if ([object isKindOfClass:[PIEPageVM class]]) {
            break;
        }
        index++;
    }
    [_source removeObjectAtIndex:index];
    _previewImageView1.image = nil;
}

- (BOOL)isSourceEmpty {
    return (!_source.count>0);
}

-(void)setSource:(NSMutableOrderedSet *)source {
    _previewImageView1.image = nil;
    _previewImageView2.image = nil;
    _source = source;
    PHImageManager *imageManager = [PHImageManager defaultManager];

        if (source.count >= 1) {
            id object = [source objectAtIndex:0];
            if ([object isKindOfClass:[PIEPageVM class]]) {
                PIEPageVM* vm = object;
                [self.previewImageView1 sd_setImageWithURL:[NSURL URLWithString:vm.imageURL]];
            } else if ([object isKindOfClass:[PHAsset class]]) {
                [imageManager requestImageForAsset:object
                                        targetSize:CGSizeMake(100,100)
                                       contentMode:PHImageContentModeDefault
                                           options:nil
                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                         _previewImageView1.image = result;
                                     }];
            }
        }
        
        if (source.count>=2) {
            
            id object = [source objectAtIndex:1];
            if ([object isKindOfClass:[PIEPageVM class]]) {
                PIEPageVM* vm = object;
                [self.previewImageView1 sd_setImageWithURL:[NSURL URLWithString:vm.imageURL]];
            } else if ([object isKindOfClass:[PHAsset class]]) {
                [imageManager requestImageForAsset:object
                                        targetSize:CGSizeMake(100,100)
                                       contentMode:PHImageContentModeDefault
                                           options:nil
                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                         _previewImageView2.image = result;
                                     }];
            }
        
    
        }

}

//
//-(void)setImagesInfo_reply:(NSArray *)imagesInfo_reply {
//    if (imagesInfo_reply.count == 1) {
//        id object = [imagesInfo_reply objectAtIndex:0];
//        if ([object isKindOfClass:[NSString class]]) {
//            
//        } else if ([object isKindOfClass:[PHAsset class]]) {
//            
//        }
//    } else     if (imagesInfo_reply.count == 2) {
//        id object = [imagesInfo_reply objectAtIndex:0];
//        if ([object isKindOfClass:[NSString class]]) {
//            
//        } else if ([object isKindOfClass:[PHAsset class]]) {
//            
//        }
//        id object1 = [imagesInfo_reply objectAtIndex:0];
//        if ([object1 isKindOfClass:[NSString class]]) {
//            
//        } else if ([object1 isKindOfClass:[PHAsset class]]) {
//            
//        }
//    }
//}


-(void)addBottomLine {
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    [self.layer addSublayer:border];
}

@end
