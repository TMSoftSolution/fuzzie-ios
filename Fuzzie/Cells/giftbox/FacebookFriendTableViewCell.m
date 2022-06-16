//
//  FacebookFriendTableViewCell.m
//  Fuzzie
//
//  Created by mac on 6/20/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FacebookFriendTableViewCell.h"

@implementation FacebookFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2.0;
    self.avatar.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
}

- (void)setCell:(FZFacebookFriend *)facebookFriend{
    
    self.facebookFriend = facebookFriend;
    
    if (facebookFriend.profileImage) {
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:facebookFriend.profileImage]];
    }
    
    [self.name setText:facebookFriend.name];
    
}

- (void)cellTapped {
    if ([self.delegate respondsToSelector:@selector(cellTapped:)]) {
        if (self.facebookFriend) {
            [self.delegate cellTapped:self.facebookFriend];
        }
    }
}

@end
