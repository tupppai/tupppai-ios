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
#import "PIECommentViewController.h"
#import "PIECategoryModel.h"
#import "PIEReplyCollectionViewController.h"

#define kPIEProceedingAskMaxCountForShowingMoreReply 10

@interface PIEProceedingAskTableViewCell_NoGap()

@property (strong, nonatomic) NSMutableArray<PIEPageVM *> *source;
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
    
    _originView1.thumbImageView.image = [UIImage imageNamed:@"pie_origin_tag"];
    _originView2.thumbImageView.image = [UIImage imageNamed:@"pie_origin_tag"];
    
    [_separator mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
    }];
    
    _separator.backgroundColor = [UIColor colorWithHex:0xE5E5E5];
    
    UITapGestureRecognizer* tapOnAsk1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnAsk1)];
    UITapGestureRecognizer* tapOnAsk2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnAsk2)];
    [self.originView1 addGestureRecognizer:tapOnAsk1];
    [self.originView2 addGestureRecognizer:tapOnAsk2];
    
    _contentTextField.textColor = [UIColor blackColor];

    _contentTextField.font = [UIFont lightTupaiFontOfSize:15];
    
    _categoryNameLabel.textColor =  [UIColor colorWithHex:0x4A4A4A];
    _categoryNameLabel.font = [UIFont lightTupaiFontOfSize:11];
    
    _uploadTimeLabel.textColor = [UIColor colorWithHex:0x50484B];
    _uploadTimeLabel.font = [UIFont lightTupaiFontOfSize:10];
    
    _contentTextField.enabled = NO;
    [_editButton setTitleColor:[UIColor colorWithHex:0xff6d3f] forState:UIControlStateSelected];
    [_editButton setImage:[UIImage new] forState:UIControlStateSelected];
    [_editButton setTitle:@"确定" forState:UIControlStateSelected];
    _editButton.titleLabel.font = [UIFont lightTupaiFontOfSize:14];
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
        
        [Hud activity:@"修改描述中..."];
        [DDService editAsk:param withBlock:^(BOOL success) {
            
            [Hud dismiss];
            if (!success) {
                _contentTextField.text = _vmAsk1.content;
            }else{
                [Hud text:@"描述修改成功"];
            }
        }];
    }
}
- (void)tapOnAsk1 {
    if (_vmAsk1) {
        if ([_vmAsk1.replyCount integerValue] <= 0) {
            PIECommentViewController *vc_comment = [PIECommentViewController new];
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
            PIECommentViewController *vc_comment = [PIECommentViewController new];
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
    
    
    /*
         在cell重用之际，让_originView2消失，由下一次的ViewModel->View的injectSource方法中再次决定
         _originView2是否有必要要出现。
     */
    [_originView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
        make.leading.equalTo(_originView1.mas_trailing).with.offset(0);
    }];
}
//put a needle injecting into cell's ass.
- (void)injectSource:(NSArray<PIEPageVM *> *)array {
    _source = [array mutableCopy];
    _vmAsk1 = [_source objectAtIndex:0];
    NSString *origin1_imageUrl = [_vmAsk1.imageURL trimToImageWidth:SCREEN_WIDTH*0.6];

    [_originView1.imageView sd_setImageWithURL:[NSURL URLWithString:origin1_imageUrl] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    [_source removeObjectAtIndex:0];
    
    if (_source.count >= 1) {
        _vmAsk2 = [_source objectAtIndex:0];
        if (_vmAsk2.type != PIEPageTypeReply) {
            
            /*
                如果由第二个PIEPageVM, 然后类型不是“帮P”，那么说明这一次的请求中原图有两张。
                － 显示第二张原图；
             */
            
            [_source removeObjectAtIndex:0];
            NSString *origin2_imageUrl = [_vmAsk2.imageURL trimToImageWidth:SCREEN_WIDTH*0.6];
            [_originView2.imageView sd_setImageWithURL:[NSURL URLWithString:origin2_imageUrl] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
            [_originView2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@84);
                make.leading.equalTo(_originView1.mas_trailing).with.offset(10);
            }];
        }
    }
    
    
    
    //    _contentLabel.text = [NSString stringWithFormat:@"要求:%@",_vmAsk1.content];
    _contentTextField.text = _vmAsk1.content;
    
    
    // 经过了injectSource的洗礼之后，_source 剩余的PiePageVM统统都是需要在swipeView中显示的，“他人的帮P”
    [self.swipeView reloadData];
    
    if (_vmAsk1.models_catogory.count>0) {
        PIECategoryModel* model = [_vmAsk1.models_catogory objectAtIndex:0];
        _categoryNameLabel.text = model.title;
    } else {
        _categoryNameLabel.text = @"随意求P区";
    }
    _uploadTimeLabel.text = _vmAsk1.publishTime;

}

#pragma mark - <SwipeViewDataSource>


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //generate 100 item views
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    
    /*
        (需求)：当作品数量超过10个，那么就显示一个额外的“查看更多”的按钮
     */
    
    if (_source.count > kPIEProceedingAskMaxCountForShowingMoreReply) {
        return _source.count + 1;
    }else{
        return _source.count;
    }
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

                if (index == _source.count) {
                    // 最后一个Item是特殊的“查看更多”Item；这个方法比_source.count多调用了一次
                    imageView.image = [UIImage imageNamed:@"pie_proceeding_checkMore"];
                }
                else
                {
                    PIEPageVM* vm = [_source objectAtIndex:index];
                    NSString *imageUrl = [vm.imageURL trimToImageWidth:SCREEN_WIDTH*0.6];

                    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                    
                }
            }
        }
    return view;

}


#pragma mark - <SwipeViewDelegate>
-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    
    if (index == _source.count) {
        /*
             点击了最后一个“查看更多”
         */

        /*
            进入“其它作品”页面
            self-managing pattern: 一个view自己解决打开新ViewController的问题。
         */
        
        PIEReplyCollectionViewController *vc = [PIEReplyCollectionViewController new];
        vc.pageVM = self.vmAsk1;
        DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
        [nav pushViewController:vc animated:YES ];
    }
    else
    {
        PIECarouselViewController2* vc = [PIECarouselViewController2 new];
        vc.pageVM = [_source objectAtIndex:index];
        DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
        [nav presentViewController:vc animated:YES completion:nil];

    }
}



@end