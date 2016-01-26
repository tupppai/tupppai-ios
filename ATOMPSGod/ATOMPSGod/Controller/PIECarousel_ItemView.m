//
//  PIECarousel_ItemView.m
//  TUPAI
//
//  Created by chenpeiwei on 11/26/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECarousel_ItemView.h"
#import "PIECommentManager.h"
#import "PIECommentTableCell.h"
#import "PIEFriendViewController.h"
#import "DDNavigationController.h"
#import "PIECommentViewController.h"

#import "PIEActionSheet_PS.h"

@interface PIECarousel_ItemView()
//@property (nonatomic, strong) NSMutableArray *source_newComment;
@property (nonatomic, strong)  PIEActionSheet_PS * psActionSheet;
@property (nonatomic, strong)  PIEShareView * shareView;
@property (nonatomic, strong)  RACDisposable * loveStatusHander;
@property (nonatomic, strong)  RACDisposable * likeCountHander;
@property (nonatomic, strong)  RACDisposable * shareCountHander;
@property (nonatomic, strong)  RACDisposable * commentCountHander;

@end

/* Protocols */
@interface PIECarousel_ItemView (UITableView)
<UITableViewDataSource,UITableViewDelegate>
@end

@interface PIECarousel_ItemView (ShareView)
<PIEShareViewDelegate>
@end

@interface PIECarousel_ItemView (JGActionSheet)
<JGActionSheetDelegate>
@end


@implementation PIECarousel_ItemView


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _imageView_type.contentMode = UIViewContentModeScaleAspectFit;

        _pageButton_comment.imageView.image = [UIImage imageNamed:@"pieSquaredCommentIcon"];
        _pageButton_share.imageView.image   = [UIImage imageNamed:@"pieSquaredShareIcon"];
        
        _button_name.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _label_time.textAlignment = NSTextAlignmentRight;

        _label_time.textColor =[UIColor colorWithHex:0x000000 andAlpha:0.4];
        [_label_time setFont:[UIFont lightTupaiFontOfSize:10]];
        
        _textView_content.font = [UIFont lightTupaiFontOfSize:14];
        [self setupTableView];
        [self addEvent];
    }
    return self;
}



- (void)addEvent {
    [_button_avatar addTarget:self action:@selector(pushToUser) forControlEvents:UIControlEventTouchUpInside];
    [_button_name addTarget:self action:@selector(pushToUser) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer* tapShare = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShare)];
    UITapGestureRecognizer* tapComment = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapComment)];
    UITapGestureRecognizer* tapLike = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLike)];
    UILongPressGestureRecognizer* longpressLike = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressLike)];
    UITapGestureRecognizer* tapPS = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPS)];

    [_bangView addGestureRecognizer:tapPS];
    [_pageButton_share addGestureRecognizer:tapShare];
    [_pageButton_comment addGestureRecognizer:tapComment];
    [_pageLikeButton addGestureRecognizer:tapLike];
    [_pageLikeButton addGestureRecognizer:longpressLike];
}



-(void) tapPS {
    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
}

- (void)longpressLike {
    [_vm love:YES];
}
- (void)tapLike {
    [_vm love:NO];
}
- (void)tapShare {
    [self showShareView];
}
- (void)tapComment {
    PIECommentViewController* vc = [PIECommentViewController new];
    vc.vm = _vm;
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    DDNavigationController* nav = [[DDNavigationController alloc]initWithRootViewController:vc];
    [self.viewController presentViewController:nav animated:NO completion:nil];
}
- (void)pushToUser{
    PIEFriendViewController* vc = [PIEFriendViewController new];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.uid = _vm.userID;
    vc.name = _vm.username;
    DDNavigationController* nav = [[DDNavigationController alloc]initWithRootViewController:vc];

    [self.viewController presentViewController:nav animated:YES completion:nil];
}
- (void)setupTableView {
//    _source_newComment = [NSMutableArray new];
    _tableView_comment.dataSource = self;
    _tableView_comment.delegate = self;
    _tableView_comment.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView_comment.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    _tableView_comment.separatorInset = UIEdgeInsetsMake(0, 60, 0, 14);
    [self.tableView_comment registerClass:[PIECommentTableCell class] forCellReuseIdentifier:@"cellIdentifier"];
    self.tableView_comment.tableFooterView = [UIView new];
    self.tableView_comment.showsVerticalScrollIndicator = NO;
    self.tableView_comment.showsHorizontalScrollIndicator = NO;
    self.tableView_comment.scrollEnabled = NO;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark 0 - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vm.commentViewModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView_comment == tableView) {
        PIECommentTableCell *cell = (PIECommentTableCell *)[tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        if (!cell) {
            cell = [[PIECommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        }

        [cell getSource:self.vm.commentViewModelArray[indexPath.row]];

        return cell;
    }
    return nil;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}


#pragma mark - GetDataSource

- (void)getDataSource {
    if (self.vm.commentViewModelArray.count == 0 && self.vm.model.totalCommentNumber>0) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:@(_vm.ID) forKey:@"target_id"];
        [param setObject:@(_vm.type) forKey:@"type"];
        [param setObject:@(1) forKey:@"page"];
        [param setObject:@(2) forKey:@"size"];
        PIECommentManager *commentManager = [PIECommentManager new];
        [commentManager ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
            [self.vm.commentViewModelArray addObjectsFromArray:recentCommentArray];
            [self.tableView_comment reloadData];
        }];
    }

}



#pragma mark - <PIEShareViewDelegate> and its related methods


- (void)showShareView
{
    [self.shareView show:_vm];
}

- (void)shareViewDidShare:(PIEShareView *)shareView
{
    // refresh ui element on main thread after successful sharing, do nothing otherwise.
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self updateShareStatus];
//    }];
}

- (void)shareViewDidCancel:(PIEShareView *)shareView
{
    [shareView dismiss];
}
#pragma mark - Lazy loadings

- (PIEShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}
- (PIEActionSheet_PS *)psActionSheet {
    if (!_psActionSheet) {
        _psActionSheet = [PIEActionSheet_PS new];
        _psActionSheet.vm = _vm;
    }
    return _psActionSheet;
}


#pragma mark - Setters
-(void)setVm:(PIEPageVM *)vm {
    
    [_loveStatusHander dispose];
    [_likeCountHander dispose];
    [_shareCountHander dispose];
    [_commentCountHander dispose];
    _vm = vm;
     _loveStatusHander = [RACObserve(_vm,loveStatus)subscribeNext:^(id x) {
         self.pageLikeButton.status = [x integerValue];
     }];
    _likeCountHander = [RACObserve(_vm,likeCount)subscribeNext:^(id x) {
        self.pageLikeButton.numberString = x;
    }];
    _shareCountHander = [RACObserve(_vm,shareCount)subscribeNext:^(id x) {
        self.pageButton_share.numberString = x;
    }];
    _commentCountHander = [RACObserve(_vm,commentCount)subscribeNext:^(id x) {
        self.pageButton_comment.numberString = x;
    }];
    
    _label_time.text = vm.publishTime;
    [_button_name setTitle:vm.username forState:UIControlStateNormal];
    
    NSString* urlString_avatar = [vm.avatarURL trimToImageWidth:_button_avatar.frame.size.height*SCREEN_SCALE];
    
    [DDService sd_downloadImage:urlString_avatar withBlock:^(UIImage *image) {
        [_button_avatar setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        [_button_avatar setImage:image forState:UIControlStateNormal];

    }];
    
    
    _button_avatar.isV = vm.isV;

    
    if (vm.type == PIEPageTypeAsk) {
        _imageView_type.image = [UIImage imageNamed:@"carousel_type_ask"];
        _pageLikeButton.hidden = YES;
        _bangView.hidden = NO;
        _pageLikeButton.imageView.image = [UIImage imageNamed:@""];
    } else {
        _pageLikeButton.hidden = NO;
        _bangView.hidden = YES;
        _imageView_type.image = [UIImage imageNamed:@"carousel_type_reply"];
        _pageLikeButton.hidden = NO;
    }
    
    _view_pageImage.url = [vm.imageURL trimToImageWidth:SCREEN_WIDTH_RESOLUTION];
    
    if ([vm.content isEqualToString:@""]) {
        [_textView_content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0).with.priorityMedium();
        }];
    }
//        else {
//            NSString * htmlString = vm.content;
//            _textView_content.backgroundColor = [UIColor lightGrayColor];
//            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType } documentAttributes:nil error:nil];
//            [attrStr addAttribute:NSFontAttributeName value:[UIFont lightTupaiFontOfSize:15] range:NSMakeRange(0, attrStr.length)];
//            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x000000 andAlpha:0.9] range:NSMakeRange(0, attrStr.length)];
//            _textView_content.attributedText = attrStr;
//        }
    _textView_content.text = vm.content;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getDataSource];
    });
}



@end