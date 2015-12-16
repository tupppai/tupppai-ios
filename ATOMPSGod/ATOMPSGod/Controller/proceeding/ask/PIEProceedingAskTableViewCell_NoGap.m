//
//  PIEProceedingAskTableViewCell_NoGap.m
//  TUPAI
//
//  Created by chenpeiwei on 11/25/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingAskTableViewCell_NoGap.h"
#import "PIECarouselViewController2.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
#import "PIECommentViewController2.h"

@interface PIEProceedingAskTableViewCell_NoGap()
@property (strong, nonatomic) NSMutableArray *source;
@property (strong, nonatomic) PIEPageVM *vmAsk1;
@property (strong, nonatomic) PIEPageVM *vmAsk2;
@end

@implementation PIEProceedingAskTableViewCell_NoGap

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    _swipeView.alignment = SwipeViewAlignmentEdge;
    _swipeView.dataSource = self;
    _swipeView.delegate = self;
    _swipeView.bounces = YES;
    
    _originView1.thumbImageView.image = [UIImage imageNamed:@"pie_origin"];
    _originView2.thumbImageView.image = [UIImage imageNamed:@"pie_origin"];
    
    UITapGestureRecognizer* tapOnAsk1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnAsk1)];
    UITapGestureRecognizer* tapOnAsk2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnAsk2)];
    [self.originView1 addGestureRecognizer:tapOnAsk1];
    [self.originView2 addGestureRecognizer:tapOnAsk2];
    
    _contentLabel.textColor = [UIColor colorWithHex:0x50484B andAlpha:1];
    _contentTextField.textColor = [UIColor colorWithHex:0x50484B andAlpha:1];
    _allWorkDescLabel.textColor = [UIColor colorWithHex:0xFEAA2B andAlpha:1];
    _contentLabel.font = [UIFont lightTupaiFontOfSize:14];
    _contentTextField.font = [UIFont lightTupaiFontOfSize:14];
    _allWorkDescLabel.font = [UIFont lightTupaiFontOfSize:11];
    
    _contentTextField.enabled = NO;
    [_editButton setTitleColor:[UIColor colorWithHex:0xff6d3f] forState:UIControlStateSelected];
    [_editButton setImage:[UIImage new] forState:UIControlStateSelected];
    [_editButton setTitle:@"确定" forState:UIControlStateSelected];
    _editButton.titleLabel.font = [UIFont lightTupaiFontOfSize:14.0];
    [_editButton addTarget:self action:@selector(editAsk) forControlEvents:UIControlEventTouchUpInside];
}

- (void)editAsk {
    if (_editButton.state == UIControlStateHighlighted) {
        _editButton.selected = YES;
        _contentTextField.enabled = YES;
        [_contentTextField becomeFirstResponder];
    } else  {
        _editButton.selected = NO;
        _contentTextField.enabled = NO;
        NSMutableDictionary* param = [NSMutableDictionary new];
        [param setObject:_contentTextField.text forKey:@"desc"];
        [param setObject:@(_vmAsk1.askID) forKey:@"ask_id"];
        [DDService editAsk:param withBlock:^(BOOL success) {
            if (!success) {
                _contentTextField.text = _vmAsk1.content;
            }
        }];
    }
}
- (void)tapOnAsk1 {
    if (_vmAsk1) {
        if ([_vmAsk1.replyCount integerValue] <= 0) {
            PIECommentViewController2 *vc_comment = [PIECommentViewController2 new];
            vc_comment.vm = _vmAsk1;
            DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
            DDNavigationController* nav2 = [[DDNavigationController alloc]initWithRootViewController:vc_comment];
            [nav presentViewController:nav2 animated:NO completion:nil];
        } else {
            PIECarouselViewController2* vc = [PIECarouselViewController2 new];
            vc.pageVM = _vmAsk1;
            DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
            //        [nav pushViewController:vc animated:YES ];
            [nav presentViewController:vc animated:YES completion:nil];
        }
    }
}
- (void)tapOnAsk2 {
    if (_vmAsk2) {
        if ([_vmAsk2.replyCount integerValue] <= 0) {
            PIECommentViewController2 *vc_comment = [PIECommentViewController2 new];
            vc_comment.vm = _vmAsk2;
            DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
            DDNavigationController* nav2 = [[DDNavigationController alloc]initWithRootViewController:vc_comment];
            [nav presentViewController:nav2 animated:NO completion:nil];
        } else {
            PIECarouselViewController2* vc = [PIECarouselViewController2 new];
            vc.pageVM = _vmAsk2;
            DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
            //        [nav pushViewController:vc animated:YES ];
            [nav presentViewController:vc animated:YES completion:nil];
        }
    }
    
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [_originView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
        make.leading.equalTo(_originView1.mas_trailing).with.offset(0);
    }];
}
//put a needle injecting into cell's ass.
- (void)injectSource:(NSArray*)array {
    _source = [array mutableCopy];
    _vmAsk1 = [_source objectAtIndex:0];
    [_originView1.imageView setImageWithURL:[NSURL URLWithString:_vmAsk1.imageURL] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    [_source removeObjectAtIndex:0];
    
    if (_source.count >= 1) {
        _vmAsk2 = [_source objectAtIndex:0];
        if (_vmAsk2.type != PIEPageTypeReply) {
            [_source removeObjectAtIndex:0];
            [_originView2.imageView setImageWithURL:[NSURL URLWithString:_vmAsk2.imageURL] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
            [_originView2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@84);
                make.leading.equalTo(_originView1.mas_trailing).with.offset(10);
            }];
        }
    }
    _timeLabel.text = _vmAsk1.publishTime;
    _allWorkDescLabel.text = [NSString stringWithFormat:@"已有%@个作品",_vmAsk1.replyCount];
    //    _contentLabel.text = [NSString stringWithFormat:@"要求:%@",_vmAsk1.content];
    _contentTextField.text = _vmAsk1.content;
    [self.swipeView reloadData];
    
}

#pragma mark iCarousel methods


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //generate 100 item views
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    
    // ??? WTF???
    
    // Add one more item in the back, "查看更多"
    return _source.count ;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        CGFloat width = self.swipeView.frame.size.height;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width+10, width)];
        view.contentMode = UIViewContentModeScaleAspectFill;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, width, width)];
        imageView.layer.cornerRadius = 3.0;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
    }
    
    

        for (UIView *subView in view.subviews){
            if([subView isKindOfClass:[UIImageView class]]){
                UIImageView *imageView = (UIImageView *)subView;
                
//                if (index < _source.count) {
//                    [imageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
//                }
//                else
//                {
//                    // 最后一个Item是特殊的“查看更多”Item；这个方法比_source.count多调用了一次
//                    imageView.image = [UIImage imageNamed:@"pie_proceeding_checkMore"];
//                }
                if (index == _source.count+2) {
                    // 最后一个Item是特殊的“查看更多”Item；这个方法比_source.count多调用了一次
                    imageView.image = [UIImage imageNamed:@"pie_proceeding_checkMore"];
                }
                else
                {
                    PIEPageVM* vm = [_source objectAtIndex:index];
                    [imageView setImageWithURL:[NSURL URLWithString:vm.imageURL]];
                    
                }
            }
        }
    return view;

}

-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    
    if (index <= _source.count) {
        PIECarouselViewController2* vc = [PIECarouselViewController2 new];
        vc.pageVM = [_source objectAtIndex:index];
        DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
        [nav presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        // 最后一张"查看更多"
        /* Do nothing yet. */
        NSLog(@"%s\nCheckMoreItem was clicked.", __func__);
    }
}



@end