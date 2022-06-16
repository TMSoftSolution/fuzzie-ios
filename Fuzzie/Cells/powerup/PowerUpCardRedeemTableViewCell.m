//
//  PowerUpCardRedeemTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 3/23/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "PowerUpCardRedeemTableViewCell.h"

@implementation PowerUpCardRedeemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.btnActivate withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
}

- (void)setCellWith:(NSDictionary *)giftDict{
    
    if (giftDict) {
        
        self.lbOrderNumber.text = [NSString stringWithFormat:@"%@" , giftDict[@"order_number"]];
        
        if (giftDict[@"used"] && [giftDict[@"used"] boolValue]){

            [CommonUtilities setView:self.btnActivate withBackground:[UIColor colorWithHexString:@"#D7D7D7"] withRadius:2.0f];
            self.btnActivate.enabled = NO;
            [self.btnActivate setTitle:@"REDEEMED" forState:UIControlStateNormal];
            
            if (giftDict[@"redeemed_time"]
                && ![giftDict[@"redeemed_time"] isKindOfClass:[NSNull class]]
                && ![giftDict[@"redeemed_time"] isEqualToString:@""]) {
                
                NSDate *tempDate = [[GlobalConstants standardFormatter] dateFromString:giftDict[@"redeemed_time"]];
                self.lbValid.text = [NSString stringWithFormat:@"Redeemed on %@" , [[GlobalConstants redeemStartEndFormatter] stringFromDate:tempDate]];
                self.lbValid.backgroundColor = [UIColor colorWithRed:1.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.41f];
                self.lbValid.textColor = [UIColor colorWithHexString:HEX_COLOR_RED];
                
            }
            
        } else {
            
            NSDate *expiryDate = [[GlobalConstants standardFormatter] dateFromString:giftDict[@"expiration_date"]];
            self.lbValid.text = [NSString stringWithFormat:@"Valid till %@" , [[GlobalConstants redeemStartEndFormatter] stringFromDate:expiryDate]];
            
            if (giftDict[@"expired"] && [giftDict[@"expired"] boolValue]){
                
                [CommonUtilities setView:self.btnActivate withBackground:[UIColor colorWithHexString:@"#D7D7D7"] withRadius:2.0f];
                self.btnActivate.enabled = NO;
                [self.btnActivate setTitle:@"EXPIRED" forState:UIControlStateNormal];
                
                self.lbValid.backgroundColor = [UIColor colorWithRed:1.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.41f];
                self.lbValid.textColor = [UIColor colorWithHexString:HEX_COLOR_RED];
            }
        }
    }

}

- (IBAction)activateButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(activateButtonPressed)]) {
        [self.delegate activateButtonPressed];
    }
}

@end
