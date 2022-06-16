//
//  FriendsTableViewCell.m
//  Fuzzie
//
//  Created by mac on 6/12/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatar.clipsToBounds = NO;
    self.avatar.layer.cornerRadius = 35/2.0;
    self.avatar.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    self.clipsToBounds = NO;
}

- (void)setInfo:(FZUser *)userInfo {
    
    self.userInfo = userInfo;
    
    if (userInfo.profileImage) {
        [self.avatar.avatarImage sd_setImageWithURL:[NSURL URLWithString:userInfo.profileImage]
                                       placeholderImage:[UIImage imageNamed:userInfo.bearAvatar]];
    } else {
        self.avatar.avatarImage.image = [UIImage imageNamed:userInfo.bearAvatar];
    }
    
    NSString *name = @"";
    if (userInfo.firstName) {
        name = userInfo.firstName;
    }
    
    if (userInfo.lastName) {
        name = [NSString stringWithFormat:@"%@ %@",name,userInfo.lastName];
    }
    self.name.text = name;
    
    if (userInfo.birthday) {
        
        NSDate *birthdayDate = [GlobalConstants.dateApiFormatter dateFromString:userInfo.birthday];
        
        self.birth.text = [NSString stringWithFormat:@"Born %@",
                                   [GlobalConstants.dateBirthdayShortStringFormatter stringFromDate:birthdayDate]];
    } else {
        self.birth.text = @"";
    }
    
    if ([userInfo.isFriend isEqual:@1])  {
        self.avatar.iconImageView.hidden = NO;
        self.avatar.iconImageView.image = [UIImage imageNamed:@"icon-avatar-fb"];
    } else{
        self.avatar.iconImageView.hidden = YES;
        
    }
    
    self.avatar.clipsToBounds = NO;
}

- (void)cellTapped {
    if ([self.delegate respondsToSelector:@selector(cellTapped:)]) {
        if (self.userInfo) {
            [self.delegate cellTapped:self.userInfo];
        }
    }
}

@end
