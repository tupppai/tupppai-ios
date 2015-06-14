
#import <Foundation/Foundation.h>
#import "ATOMFollowPageViewModel.h"
#import "ATOMAskPageViewModel.h"
#import "ATOMProductPageViewModel.h"

@interface PWPageDetailViewModel : NSObject
@property (nonatomic, assign) NSInteger pageID;
//type 1 求P ，2 作品
@property (nonatomic, assign) NSInteger askID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, strong) NSString *pageImageURL;
@property (nonatomic, copy) NSString *likeNumber;
@property (nonatomic, copy) NSString *shareNumber;
@property (nonatomic, copy) NSString *commentNumber;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIImage *pageImage;
@property (nonatomic, assign) BOOL liked;
-(void)setCommonViewModelWithAsk:(ATOMAskPageViewModel*)model;
-(void)setCommonViewModelWithProduct:(ATOMProductPageViewModel*)model;
-(void)setCommonViewModelWithFollow:(ATOMFollowPageViewModel*)model;
- (void)toggleLike;
-(ATOMAskPageViewModel*)generateAskPageViewModel;
//@property (nonatomic, copy) NSString *userSex;
//@property (nonatomic, copy) NSString *publishTime;
//@property (nonatomic, assign) NSInteger userID;
//@property (nonatomic, copy) NSString *PSNumber;
//@property (nonatomic, strong) NSMutableArray *labelArray;
//@property (nonatomic, strong) NSMutableArray *replierArray;
//@property (nonatomic, strong) NSMutableArray *commentArray;
@end
