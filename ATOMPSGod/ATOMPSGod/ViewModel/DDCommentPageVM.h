
#import <Foundation/Foundation.h>
#import "kfcFollowVM.h"

#import "DDHotDetailPageVM.h"

@interface DDCommentPageVM : NSObject
@property (nonatomic, assign) NSInteger pageID;
//type 1 求P ，2 作品
@property (nonatomic, assign) NSInteger askID;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, strong) NSString *pageImageURL;
@property (nonatomic, copy) NSString *likeNumber;
@property (nonatomic, copy) NSString *shareNumber;
@property (nonatomic, copy) NSString *commentNumber;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIImage *pageImage;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL collected;

@property (nonatomic, strong) NSMutableArray *labelArray;


-(void)setCommonViewModelWithAsk:(DDPageVM*)model;

@end
