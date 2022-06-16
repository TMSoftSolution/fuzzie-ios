//
//  ReferralUsersTableViewCell.m
//  Fuzzie
//
//  Created by mac on 6/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "ReferralUsersTableViewCell.h"

@implementation ReferralUsersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
       
    self.avatarUser.clipsToBounds = NO;
    self.avatarUser.layer.cornerRadius = 35/2.0;
    self.avatarUser.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    self.clipsToBounds = NO;
}

- (void)setInfo:(FZUser *)userInfo isClubReferral:(BOOL)isClubReferral{
    
    self.userInfo = userInfo;
    
    if (userInfo.profileImage) {
        [self.avatarUser.avatarImage sd_setImageWithURL:[NSURL URLWithString:userInfo.profileImage]
                                       placeholderImage:[UIImage imageNamed:userInfo.bearAvatar]];
    } else {
        self.avatarUser.avatarImage.image = [UIImage imageNamed:userInfo.bearAvatar];
    }
    
    NSString *name = @"";
    if (userInfo.firstName) {
        name = userInfo.firstName;
    }
    
    if (userInfo.lastName) {
        name = [NSString stringWithFormat:@"%@ %@",name,userInfo.lastName];
    }
    self.lbUserName.text = name;
       
    if ([userInfo.isFriend isEqual:@1])  {
        self.avatarUser.iconImageView.hidden = NO;
        self.avatarUser.iconImageView.image = [UIImage imageNamed:@"icon-avatar-fb"];
    } else{
        self.avatarUser.iconImageView.hidden = YES;
        
    }
    
    self.avatarUser.clipsToBounds = NO;
    
    if (userInfo.status) {
        if ([userInfo.status isEqualToString:@"referer_awarded_bonus"]) {
            if (isClubReferral) {
                [self.status setText:@"S$10 Earned"];
            } else{
                [self.status setText:@"S$5 Earned"];
            }
            [self.status setTextColor:[UIColor colorWithHexString:@"#FA3E3F"]];
        } else{
            [self.status setText:@"Pending..."];
            [self.status setTextColor:[UIColor colorWithHexString:@"#BDBDBD"]];
        }
    } else{
        [self.status setText:@""];
    }
}

- (void)cellTapped {
    if ([self.delegate respondsToSelector:@selector(cellTapped:)]) {
        if (self.userInfo) {
            [self.delegate cellTapped:self.userInfo];
        }
    }
}

@end
