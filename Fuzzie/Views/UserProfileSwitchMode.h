//
//  UserProfileSwitchMode.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UserProfileSwitchModeDelegate <NSObject>
- (void)modeChanged:(NSInteger)mode;
@end




@interface UserProfileSwitchMode : UITableViewHeaderFooterView
typedef enum : NSUInteger {
    UserProfileModeLike,
    UserProfileModeWhishList,
} UserProfileMode;

@property (weak, nonatomic) IBOutlet UIView *buttonLike;
@property (weak, nonatomic) IBOutlet UIView *buttonWishlist;
@property (weak, nonatomic) IBOutlet UILabel *wishlistLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (assign, nonatomic) NSInteger mode;
@property (weak, nonatomic) id<UserProfileSwitchModeDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *whishListFocusBar;
@property (weak, nonatomic) IBOutlet UIView *likeFocusBar;

- (void)setNbLike:(int)nbLike;
- (void)setNbWishlisted:(int)nbWishlisted;
- (void)refreshMode:(NSInteger)mode;

@end
