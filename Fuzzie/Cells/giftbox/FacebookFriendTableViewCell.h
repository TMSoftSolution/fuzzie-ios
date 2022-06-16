//
//  FacebookFriendTableViewCell.h
//  Fuzzie
//
//  Created by mac on 6/20/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZFacebookFriend.h"

@protocol FacebookFriendTableViewCellDelegate <NSObject>
- (void)cellTapped:(FZFacebookFriend *)friendInfo;
@end

@interface FacebookFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) FZFacebookFriend *facebookFriend;

- (void)setCell:(FZFacebookFriend*) facebookFriend;
@property (weak, nonatomic) id<FacebookFriendTableViewCellDelegate> delegate;

@end
