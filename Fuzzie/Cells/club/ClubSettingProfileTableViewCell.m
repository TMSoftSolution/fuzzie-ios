//
//  ClubSettingProfileTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSettingProfileTableViewCell.h"

@implementation ClubSettingProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.btnExtend withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:2.0f];
    [CommonUtilities setView:self.ivAvatar withCornerRadius:self.ivAvatar.frame.size.width/2];
    
    FZUser *user = [UserController sharedInstance].currentUser;
    
    [self.ivAvatar sd_setImageWithURL:[NSURL URLWithString:user.profileImage] placeholderImage:[UIImage imageNamed:@"profile-image"]];
    self.lbName.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    NSDate *subDate = [[GlobalConstants dateApiFormatter] dateFromString:user.clubSubscribeDate];
    self.lbDate.text = [NSString stringWithFormat:@"Member since %@", [[GlobalConstants redeemStartEndFormatter] stringFromDate:subDate]];
    
    NSDate *expDate = [NSDate dateWithYear:subDate.year + 1 month:subDate.month day:subDate.day];
    self.lbDate1.text = [[GlobalConstants redeemStartEndFormatter] stringFromDate:expDate];
}

- (IBAction)extendButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(extendButtonPressed)]) {
        [self.delegate extendButtonPressed];
    }
}
@end
