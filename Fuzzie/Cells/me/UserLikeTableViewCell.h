//
//  UserLikeTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UserLikeTableViewCellDelegate <NSObject>
- (void)cellTapped:(FZUser *)userInfo;
@end

@interface UserLikeTableViewCell : UITableViewCell
- (void)setInfo:(FZUser *)userInfo;
@property (weak, nonatomic) id<UserLikeTableViewCellDelegate> delegate;
@end
