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
#import "PIECommentViewController2.h"
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
//        _textView_content.delegate = self;
//        [_label_content setTintColor:[UIColor colorWithHex:0x000000 andAlpha:0.8]];
//        [_label_content setFont:[UIFont lightTupaiFontOfSize:15]];

        [_label_time setTintColor:[UIColor colorWithHex:0x000000 andAlpha:0.4]];
        [_label_time setFont:[UIFont lightTupaiFontOfSize:10]];
        
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
    [self.shareView show];
}
- (void)tapComment {
    PIECommentViewController2* vc = [PIECommentViewController2 new];
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
    } else {
        NSString * htmlString = vm.content;
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont lightTupaiFontOfSize:15] range:NSMakeRange(0, attrStr.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x000000 andAlpha:0.9] range:NSMakeRange(0, attrStr.length)];
        _textView_content.attributedText = attrStr;
    }
    
    [self getDataSource];

    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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


-(PIEShareView *)shareView {
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


- (void)help:(BOOL)shouldDownload {
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@(_vm.ID) forKey:@"target"];
    [param setObject:@"ask" forKey:@"type"];
    
    [DDService signProceeding:param withBlock:^(NSString *imageUrl) {
        if (imageUrl != nil) {
            if (shouldDownload) {
                [DDService downloadImage:imageUrl withBlock:^(UIImage *image) {
                    UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }];
            }
            else {
                [Hud customText:@"添加成功\n在“进行中”等你下载咯!" inView:[AppDelegate APP].window];
            }
        }
    }];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
    } else {
        [Hud customText:@"下载成功\n我猜你会用美图秀秀来P?" inView:[AppDelegate APP].window];
    }
}


- (void)updateShareStatus {
    _vm.shareCount = [NSString stringWithFormat:@"%zd",[_vm.shareCount integerValue]+1];
}
//sina
-(void)tapShare1 {
    [DDShareManager postSocialShare2:_vm withSocialShareType:ATOMShareTypeSinaWeibo block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//qqzone
-(void)tapShare2 {
    [DDShareManager postSocialShare2:_vm withSocialShareType:ATOMShareTypeQQZone block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
    
}
//wechat moments
-(void)tapShare3 {
    [DDShareManager postSocialShare2:_vm withSocialShareType:ATOMShareTypeWechatMoments block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
//wechat friends
-(void)tapShare4 {
    [DDShareManager postSocialShare2:_vm withSocialShareType:ATOMShareTypeWechatFriends block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
}
-(void)tapShare5 {
    [DDShareManager postSocialShare2:_vm withSocialShareType:ATOMShareTypeQQFriends block:^(BOOL success) {if (success) {[self updateShareStatus];}}];
    
}
-(void)tapShare6 {
    [DDShareManager copy:_vm];
}
-(void)tapShare7 {
    self.shareView.vm = _vm;
}
-(void)tapShare8 {
    [_vm collect];
}

-(void)tapShareCancel {
    [self.shareView dismiss];
}

@end
