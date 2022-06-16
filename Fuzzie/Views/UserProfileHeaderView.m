//
//  UserProfileHeaderView.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "UserProfileHeaderView.h"


@interface UserProfileHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayUserLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenterAnchor;
@property (strong, nonatomic) NSArray *bearAvatarList;



@end


@implementation UserProfileHeaderView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bearAvatarList = @[[UIImage imageNamed:@"avatar-bear-1"],
                            [UIImage imageNamed:@"avatar-bear-2"],
                            [UIImage imageNamed:@"avatar-bear-3"],
                            [UIImage imageNamed:@"avatar-bear-4"],
                            [UIImage imageNamed:@"avatar-bear-5"],
                            [UIImage imageNamed:@"avatar-bear-6"],
                            [UIImage imageNamed:@"avatar-bear-7"]];
    
    self.clipsToBounds = NO;
    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width/2.0;
    self.avatarImage.layer.masksToBounds = YES;
    [self addSubview:self.avatarImage];
}

- (void)setInfoUser:(FZUser *)userInfo {
    
    if (userInfo.profileImage) {
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:userInfo.profileImage]
                                       placeholderImage:[UIImage imageNamed:userInfo.bearAvatar]];
    } else {
        self.avatarImage.image = [UIImage imageNamed:userInfo.bearAvatar];
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
        self.nameCenterAnchor.constant = -8;
        NSDateFormatter *dateApiFormat = [[NSDateFormatter alloc] init];
        [dateApiFormat setDateFormat:@"YYYY-dd-MM"];
        
        NSDate *birthdayDate = [GlobalConstants.dateApiFormatter dateFromString:userInfo.birthday];
        
        self.birthdayUserLabel.text = [NSString stringWithFormat:@"Born %@",
                                   [GlobalConstants.dateBirthdayShortStringFormatter stringFromDate:birthdayDate]];
    } else {
        self.nameCenterAnchor.constant = 0;
        self.birthdayUserLabel.text = @"";
    }

}

- (IBAction)profilePhotoPressed:(id)sender {
    [self.delegate profilePhotoPressed];
}

@end
