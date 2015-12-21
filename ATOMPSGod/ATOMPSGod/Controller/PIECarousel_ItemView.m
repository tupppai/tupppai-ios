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
#import "AppDelegate.h"
#import "PIEActionSheet_PS.h"
//#import "PIEWebViewViewController.h"
//#import "DDNavigationController.h"
//#import "AppDelegate.h"
@interface PIECarousel_ItemView()
@property (nonatomic, strong) NSMutableArray *source_newComment;
@property (nonatomic, strong)  PIEActionSheet_PS * psActionSheet;
@property (nonatomic, strong)  PIEShareView * shareView;

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
        _button_avatar.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _button_avatar.layer.cornerRadius = _button_avatar.frame.size.width/2;
        _button_avatar.clipsToBounds = YES;
        _pageButton_comment.imageView.image = [UIImage imageNamed:@"hot_comment"];
        _pageButton_share.imageView.image   = [UIImage imageNamed:@"hot_share"];
        
        _button_name.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _label_time.textAlignment = NSTextAlignmentRight;

        [_button_avatar setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.9] forState:UIControlStateNormal];
        [_button_avatar.titleLabel setFont:[UIFont lightTupaiFontOfSize:13]];
        _label_time.textColor =[UIColor colorWithHex:0x000000 andAlpha:0.4];
        [_label_time setFont:[UIFont lightTupaiFontOfSize:10]];
//        _textView_content.delegate = self;
//        [_label_content setTintColor:[UIColor colorWithHex:0x000000 andAlpha:0.8]];
//        [_label_content setFont:[UIFont lightTupaiFontOfSize:15]];

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
    
    UITapGestureRecognizer* tapPS = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPS)];

    [_bangView addGestureRecognizer:tapPS];
    [_pageButton_share addGestureRecognizer:tapShare];
    [_pageButton_comment addGestureRecognizer:tapComment];
    [_pageLikeButton addGestureRecognizer:tapLike];
}
-(void) tapPS {
    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
}
- (void)tapLike {
    [self like:_pageLikeButton];
}
- (void)tapShare {
//    [self.shareView show];
   
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
    _source_newComment = [NSMutableArray new];
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
    return _source_newComment.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView_comment == tableView) {
        PIECommentTableCell *cell = (PIECommentTableCell *)[tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        if (!cell) {
            cell = [[PIECommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        }
        [cell getSource:_source_newComment[indexPath.row]];

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
    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_vm.ID) forKey:@"target_id"];
    [param setObject:@(_vm.type) forKey:@"type"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(2) forKey:@"size"];
    PIECommentManager *commentManager = [PIECommentManager new];
    [commentManager ShowDetailOfComment:param withBlock:^(NSMutableArray *hotCommentArray, NSMutableArray *recentCommentArray, NSError *error) {
        ws.source_newComment.array = recentCommentArray;
        [self.tableView_comment reloadData];
    }];
}


#pragma mark - Gesture events
-(void)like:(PIEPageLikeButton*)likeView {
    likeView.selected = !likeView.selected;
    
    [DDService toggleLike:likeView.selected ID:_vm.ID type:_vm.type  withBlock:^(BOOL success) {
        if (success) {
            if (likeView.selected) {
                _vm.likeCount = [NSString stringWithFormat:@"%zd",_vm.likeCount.integerValue + 1];
            } else {
                _vm.likeCount = [NSString stringWithFormat:@"%zd",_vm.likeCount.integerValue - 1];
            }
            _vm.liked = likeView.selected;
        } else {
            likeView.selected = !likeView.selected;
        }
    }];
}

#pragma mark - <PIEShareViewDelegate> and its related methods
- (void)updateShareStatus {
    // _vm.shareCount ++ 这个副作用集中发生在PIEShareView之中。
    
}

- (void)showShareView
{
    [self.shareView show:_vm];
}

- (void)shareViewDidShare:(PIEShareView *)shareView
{
    // refresh ui element on main thread after successful sharing, do nothing otherwise.
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateShareStatus];
    }];
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
    if (_vm != vm) {
        _vm = vm;
    }
    _pageButton_comment.numberString = vm.commentCount;
    _pageButton_share.numberString = vm.shareCount;
    _label_time.text = vm.publishTime;
    //    _label_content.text = vm.content;
    [_button_name setTitle:vm.username forState:UIControlStateNormal];
    [_button_avatar setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:vm.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
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
        _pageLikeButton.highlighted = vm.liked;
        _pageLikeButton.numberString = vm.likeCount;
    }
    
    //    [_imageView_page setImageWithURL:[NSURL URLWithString:vm.imageURL] placeholderImage:[UIImage imageNamed:@"cellHolder"]];
    [DDService downloadImage:vm.imageURL withBlock:^(UIImage *image) {
        _view_pageImage.image = image;
    }];
    
    
    if ([vm.content isEqualToString:@""]) {
        [_textView_content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0).with.priorityMedium();
        }];
    }
    //    else {
    //        NSString * htmlString = vm.content;
    //        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType } documentAttributes:nil error:nil];
    //        [attrStr addAttribute:NSFontAttributeName value:[UIFont lightTupaiFontOfSize:15] range:NSMakeRange(0, attrStr.length)];
    //        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x000000 andAlpha:0.9] range:NSMakeRange(0, attrStr.length)];
    //        _textView_content.attributedText = attrStr;
    //    }
    _textView_content.font = [UIFont lightTupaiFontOfSize:15];
    _textView_content.textColor = [UIColor colorWithHex:0x000000 andAlpha:0.9];
    _textView_content.text = vm.content;
    [self getDataSource];
}
@end