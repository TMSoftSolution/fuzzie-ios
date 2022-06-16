//
//  GiftReceiverAvatarView.m
//  Fuzzie
//
//  Created by mac on 6/21/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftReceiverAvatarView.h"

@implementation GiftReceiverAvatarView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2.0;
    self.avatar.layer.masksToBounds = YES;
    
    self.clipsToBounds = YES;
}

- (void)setReceiverView:(FZFacebookFriend *)receiver{
    
    if (receiver.profileImage && ![receiver.profileImage isEqualToString:@""]) {
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:receiver.profileImage]];
        self.avatarWidthAnchor.constant = 40;
        self.nameLeftAnchor.constant = 8;
        self.facebookIcon.hidden = NO;
    } else{
        self.avatarWidthAnchor.constant = 0;
        self.nameLeftAnchor.constant = -4;
        self.facebookIcon.hidden = YES;
    }
    if (receiver.name) {
       [self.name setText:receiver.name];
    } else{
        [self.name setText:@""];
    }
    
}

@end
