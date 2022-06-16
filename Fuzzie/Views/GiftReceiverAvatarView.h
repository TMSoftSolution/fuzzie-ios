//
//  GiftReceiverAvatarView.h
//  Fuzzie
//
//  Created by mac on 6/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZFacebookFriend.h"

@interface GiftReceiverAvatarView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *facebookIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftAnchor;

- (void)setReceiverView:(FZFacebookFriend*)receiver;

@end
