//
//  UserLikeTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "UserLikeTableViewCell.h"
#import "AppDelegate.h"
#import "AvatarUserView.h"
#import "FZUser.h"

@interface UserLikeTableViewCell()
@property (weak, nonatomic) IBOutlet AvatarUserView *avatarUser;
@property (weak, nonatomic) IBOutlet UILabel *nameUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) FZUser *userInfo;
@property (strong, nonatomic) NSArray *bearAvatarList;

@end

@implementation UserLikeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bearAvatarList = @[[UIImage imageNamed:@"avatar-bear-1"],
                            [UIImage imageNamed:@"avatar-bear-2"],
                            [UIImage imageNamed:@"avatar-bear-3"],
                            [UIImage imageNamed:@"avatar-bear-4"],
                            [UIImage imageNamed:@"avatar-bear-5"],
                            [UIImage imageNamed:@"avatar-bear-6"],
                            [UIImage imageNamed:@"avatar-bear-7"]];
    
    self.avatarUser.clipsToBounds = NO;
    self.avatarUser.layer.cornerRadius = 35/2.0;
    self.avatarUser.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapGesture.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    self.clipsToBounds = NO;
}

- (void)setInfo:(FZUser *)userInfo {
    
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
    self.nameUserLabel.text = name;
    
    if (userInfo.birthday) {
        
        NSDateFormatter *dateApiFormat = [[NSDateFormatter alloc] init];
        [dateApiFormat setDateFormat:@"YYYY-dd-MM"];
        
        NSDate *birthdayDate = [GlobalConstants.dateApiFormatter dateFromString:userInfo.birthday];
        
        self.birthdayLabel.text = [NSString stringWithFormat:@"Born %@",
                                   [GlobalConstants.dateBirthdayShortStringFormatter stringFromDate:birthdayDate]];
    } else {
        self.birthdayLabel.text = @"";
    }
    
    if ([userInfo.isFriend isEqual:@1])  {
        self.avatarUser.iconImageView.hidden = NO;
        self.avatarUser.iconImageView.image = [UIImage imageNamed:@"icon-avatar-fb"];
    } else{
        self.avatarUser.iconImageView.hidden = YES;

    }
    
    self.avatarUser.clipsToBounds = NO;
}
                                   
                      

- (void)cellTapped {
    if ([self.delegate respondsToSelector:@selector(cellTapped:)]) {
        if (self.userInfo) {
            [self.delegate cellTapped:self.userInfo];
        }
    }
}

@end
