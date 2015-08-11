//
//  ATOMPageDetailViewModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/11/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMPageDetailViewModel.h"
#import "ATOMBaseRequest.h"
@implementation ATOMPageDetailViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _pageID = 0;
//        _userID = [ATOMCurrentUser currentUser].uid;
//        _userSex = ([ATOMCurrentUser currentUser].sex == 0) ? @"woman" : @"man";
        _userName = [ATOMCurrentUser currentUser].nickname;
        _avatarURL = [ATOMCurrentUser currentUser].avatar;
        _likeNumber = @"0";
        _shareNumber = @"0";
        _commentNumber = @"0";
    }
    return self;
}

-(void)setCommonViewModelWithAsk:(ATOMAskPageViewModel*)model {
    _type = 1;
    _uid = model.userID;
    _askID = model.ID;
    _pageID = model.ID;
    _pageImageURL = model.userImageURL;
    _pageImage = model.image;
    _avatarURL = model.avatarURL;
    _likeNumber = model.likeNumber;
    _shareNumber = model.shareNumber;
    _commentNumber = model.commentNumber;
    _width = model.width;
    _height = model.height;
    _userName = model.userName;
    _pageImage = model.image;
    _liked = model.liked;
    _collected = model.collected;
    _labelArray = model.labelArray;
}
-(void)setCommonViewModelWithHotDetail:(ATOMHotDetailPageViewModel*)model {
    _type = model.type;
    _pageID = model.ID;
    _uid = model.uid;
    _askID = model.askID;
    _pageImageURL = model.userImageURL;
    _pageImage = model.image;
    _avatarURL = model.avatarURL;
    _width = model.width;
    _height = model.height;
    _likeNumber = model.likeNumber;
    _shareNumber = model.shareNumber;
    _commentNumber = model.commentNumber;
    _userName = model.userName;
    _pageImage = model.image;
    _liked = model.liked;
    _collected = model.collected;
    _labelArray = model.labelArray;
}


-(void)setCommonViewModelWithFollow:(ATOMFollowPageViewModel*)model {
    _uid = model.userID;
    _askID = model.askID;
    _type = model.type;
    _pageID = model.imageID;
    _askID = model.askID;
    _pageImageURL = model.pageImageURL;
    _pageImage = model.image;
    _avatarURL = model.avatarURL;
    _width = model.width;
    _height = model.height;
    _likeNumber = model.likeNumber;
    _shareNumber = model.shareNumber;
    _commentNumber = model.commentNumber;
    _userName = model.userName;
    _pageImage = model.image;
    _liked = model.liked;
    _collected = model.collected;
    _labelArray = model.labelArray;
}

-(ATOMAskPageViewModel*)generateAskPageViewModel {
    ATOMAskPageViewModel* askPageViewModel = [ATOMAskPageViewModel new];
    if (_askID) {
        askPageViewModel.ID = _askID ;
    } else {
        askPageViewModel.ID = _pageID ;
    }
    askPageViewModel.userImageURL = _pageImageURL;
    askPageViewModel.image = _pageImage;
    askPageViewModel.avatarURL = _avatarURL;
    askPageViewModel.likeNumber = _likeNumber;
    askPageViewModel.shareNumber = _shareNumber;
    askPageViewModel.commentNumber = _commentNumber;
    askPageViewModel.width = _width;
    askPageViewModel.height = _height;
    askPageViewModel.userName = _userName;
    askPageViewModel.image = _pageImage;
    askPageViewModel.liked = _liked;
    askPageViewModel.collected = _collected;
    askPageViewModel.labelArray = _labelArray;
    return askPageViewModel;
}
- (void)toggleLike{
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSInteger status = _liked? 0:1;
    NSInteger one = _liked? -1:1;
    _liked = !_liked;
    NSString* url = _type == 1? @"ask/upask": @"reply/upreply";
    [param setValue:@(status) forKey:@"status"];
    ATOMBaseRequest* baseRequest = [ATOMBaseRequest new];
    [baseRequest toggleLike:param withUrl:url withID:_pageID withBlock:^(NSError *error) {
        if (!error) {
            NSLog(@"Server成功toggle like");
            NSInteger number = [_likeNumber integerValue]+one;
            [self setLikeNumber:[NSString stringWithFormat:@"%ld",(long)number]];            } else {
                NSLog(@"Server失败 toggle like");
            }
    }];
}


@end
