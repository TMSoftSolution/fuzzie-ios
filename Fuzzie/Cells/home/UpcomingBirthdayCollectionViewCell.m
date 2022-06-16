//
//  UpcomingBirthdayCollectionViewCell.m
//  Fuzzie
//
//  Created by mac on 6/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "UpcomingBirthdayCollectionViewCell.h"

@implementation UpcomingBirthdayCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatar.clipsToBounds = NO;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2.0f;
    self.avatar.layer.masksToBounds = YES;
}

- (void)setCellWithUser:(FZUser *)userInfo{
    self.userInfo = userInfo;
    
    if (userInfo.profileImage) {
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:userInfo.profileImage]
                                   placeholderImage:[UIImage imageNamed:userInfo.bearAvatar]];
    } else {
        self.avatar.image = [UIImage imageNamed:userInfo.bearAvatar];
    }
    
    if (userInfo.firstName) {
        [self.lbName setText:userInfo.firstName];
    } else {
        [self.lbName setText:@""];
    }
    
    if (userInfo.birthday) {
        
        NSDate *birthdayDate = [GlobalConstants.dateApiFormatter dateFromString:userInfo.birthday];
        
        self.lbBirth.text = [NSString stringWithFormat:@"%@",
                           [GlobalConstants.dateBirthdayUpcomingFormatter stringFromDate:birthdayDate]];
    } else {
        self.lbBirth.text = @"";
    }
}

@end
