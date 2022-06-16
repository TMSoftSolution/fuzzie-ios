//
//  WishlistBrandTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/17/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WishlistBrandTableViewCellDelegate <NSObject>
- (void)buttonShareTapped;
- (void)buttonWhishListTappedWithState:(BOOL)state;
- (void)buttonLikeTappedWithState:(BOOL)state;
- (void)avatarUserLikeTappedWith:(FZUser *)userInfo;
- (void)avatarUserCellTapped:(NSArray *)userList;
@end

@interface WishlistBrandTableViewCell : UITableViewCell
@property (weak, nonatomic) id<WishlistBrandTableViewCellDelegate> delegate;
- (void)initCellWithBrand:(FZBrand *)brand;
- (void)updateNbLikes:(NSNumber*)nbLikes;
- (void)setFilledHeart;
- (void)setWhistListState:(BOOL)state;
- (void)setEmptyHeart;
- (void)initializeFriendListWith:(NSString *)brandId;
- (void)startLoader;
- (void)stopLoader;
@end
