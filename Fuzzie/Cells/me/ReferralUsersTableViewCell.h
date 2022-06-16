//
//  ReferralUsersTableViewCell.h
//  Fuzzie
//
//  Created by mac on 6/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarUserView.h"

@protocol ReferralUsersTableViewCellDelegate <NSObject>
- (void)cellTapped:(FZUser *)userInfo;
@end

@interface ReferralUsersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AvatarUserView *avatarUser;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (strong, nonatomic) FZUser *userInfo;
@property (strong, nonatomic) NSArray *bearAvatarList;

- (void)setInfo:(FZUser *)userInfo isClubReferral:(BOOL)isClubReferral;
@property (weak, nonatomic) id<ReferralUsersTableViewCellDelegate> delegate;

@end
