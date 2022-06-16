//
//  FriendsTableViewCell.h
//  Fuzzie
//
//  Created by mac on 6/12/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarUserView.h"

@protocol FriendsTableViewCellDelegate <NSObject>
- (void)cellTapped:(FZUser *)userInfo;
@end

@interface FriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AvatarUserView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *birth;

@property (strong, nonatomic) FZUser *userInfo;
- (void)setInfo:(FZUser *)userInfo;
@property (weak, nonatomic) id<FriendsTableViewCellDelegate> delegate;

@end
