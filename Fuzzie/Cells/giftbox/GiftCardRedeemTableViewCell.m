//
//  GiftCardRedeemTableViewCell.m
//  Fuzzie
//
//  Created by mac on 5/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "GiftCardRedeemTableViewCell.h"

@implementation GiftCardRedeemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [CommonUtilities setView:self.redeemButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.redemptionStartView withBackground:[UIColor colorWithHexString:@"#D8D8D8"] withRadius:2.0f];
}

- (void)setCellWith:(NSDictionary *)giftDict{

    NSDateFormatter *validityFormatter;
    if (!validityFormatter) {
        validityFormatter = [NSDateFormatter new];
        [validityFormatter setDateFormat:@"d MMM yyyy"];
    }
    
    NSDateFormatter *redeemFormatter;
    if (!redeemFormatter) {
        redeemFormatter = [NSDateFormatter new];
        [redeemFormatter setDateFormat:@"d MMM yyyy, h.mma"];
        [redeemFormatter setAMSymbol:@"am"];
        [redeemFormatter setPMSymbol:@"pm"];
    }
    
    if (giftDict[@"redeem_timer_started_at"] && [giftDict[@"redeem_timer_started_at"] isKindOfClass:[NSString class]]){

        [self.redeemButton setTitle:@"VIEW CODE" forState:UIControlStateNormal];
        
        if (giftDict[@"redeemed_time"] && [giftDict[@"redeemed_time"] isKindOfClass:[NSString class]]) {
            
            self.valideView.hidden = NO;
            self.validViewHeightAnchor.constant = 20;
            NSDate *expiryDate = [[GlobalConstants standardFormatter] dateFromString:giftDict[@"expiration_date"]];
            self.validDate.text = [NSString stringWithFormat:@"%@" , [validityFormatter stringFromDate:expiryDate]];
            
            NSDate *redeemDate = [[GlobalConstants standardFormatter] dateFromString:giftDict[@"redeemed_time"]];
            self.onlineRedeemDate.text = [NSString stringWithFormat:@"%@" , [redeemFormatter stringFromDate:redeemDate]];
            
        } else{
            
            self.valideView.hidden = YES;
            self.validViewHeightAnchor.constant = 0;
            
            self.onlineValidateViewHeightAnchor.constant = 20;
            self.onlineValidateView.hidden = NO;
            NSDate *redeemDate = [[GlobalConstants standardFormatter] dateFromString:giftDict[@"redeem_timer_started_at"]];
            self.onlineRedeemDate.text = [NSString stringWithFormat:@"%@" , [redeemFormatter stringFromDate:redeemDate]];
            
        }
        
        if (giftDict[@"expired"] && [giftDict[@"expired"] boolValue]) {
            self.redeemButton.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
            [self.redeemButton setTitle:@"EXPIRED" forState:UIControlStateNormal];
            self.redeemButton.enabled = NO;
        } else{
            self.redeemButton.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
            self.redeemButton.enabled = YES;
        }
        
        
        self.orderNumber.text = [NSString stringWithFormat:@"%@" , giftDict[@"order_number"]];
        
    } else{
        
        if (giftDict[@"used"] && [giftDict[@"used"] boolValue]){
            
            self.onlineValidateViewHeightAnchor.constant = 20;
            self.onlineValidateView.hidden = NO;
            
            self.validViewHeightAnchor.constant = 0;
            self.valideView.hidden = YES;
            
            self.redeemButton.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
            self.redeemButton.enabled = NO;
            [self.redeemButton setTitle:@"REDEEMED" forState:UIControlStateNormal];
            
            if ([giftDict[@"redeemed_time"] isKindOfClass:[NSString class]]) {
                
                NSDate *tempDate = [[GlobalConstants standardFormatter] dateFromString:giftDict[@"redeemed_time"]];
                self.onlineRedeemDate.text = [redeemFormatter stringFromDate:tempDate];
                
            }
            
        } else{
            
            self.onlineValidateViewHeightAnchor.constant = 0;
            self.onlineValidateView.hidden = YES;
            
            if (giftDict[@"expired"] && [giftDict[@"expired"] boolValue]) {
                
                self.redeemButton.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
                [self.redeemButton setTitle:@"EXPIRED" forState:UIControlStateNormal];
                self.redeemButton.enabled = NO;
                
            } else{
                
                self.redeemButton.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
                self.redeemButton.enabled = YES;
                
                [self.redeemButton setTitle:@"REDEEM" forState:UIControlStateNormal];
                
            }
            
            NSDate *expiryDate = [[GlobalConstants standardFormatter] dateFromString:giftDict[@"expiration_date"]];
            self.validDate.text = [NSString stringWithFormat:@"%@" , [validityFormatter stringFromDate:expiryDate]];
            
        }
        
        self.orderNumber.text = [NSString stringWithFormat:@"%@" , giftDict[@"order_number"]];
        
    }
    
    if ((giftDict[@"used"] && [giftDict[@"used"] boolValue])) {
        
        self.redemButtonHeightAnchor.constant = 50.0f;
        self.redemptionStartViewHeightAnchor.constant = 0.0f;
        
    } else{
        
        if (giftDict[@"expired"] && [giftDict[@"expired"] boolValue]) {
            
            self.redemButtonHeightAnchor.constant = 50.0f;
            self.redemptionStartViewHeightAnchor.constant = 0.0f;
            
        } else {
            
            if (giftDict[@"redeem_timer_started_at"] && [giftDict[@"redeem_timer_started_at"] isKindOfClass:[NSString class]]) {
                
                self.redemButtonHeightAnchor.constant = 50.0f;
                self.redemptionStartViewHeightAnchor.constant = 0.0f;
                
            } else {
                
                NSDate *now = [NSDate date];
                NSDateFormatter *formatter = [GlobalConstants dateApiFormatter];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Singapore"]];
                NSDate *redeemStartDate = [formatter dateFromString:giftDict[@"redemption_start_date"]];
                
                if ([redeemStartDate isLaterThan:now]) {
                    
                    self.redemButtonHeightAnchor.constant = 0.0f;
                    self.redemptionStartViewHeightAnchor.constant = 60.0f;
                    
                    self.lbRedemption.text = [NSString stringWithFormat:@"Redemption starts on %@", [[GlobalConstants redeemStartEndFormatter] stringFromDate:redeemStartDate]];
                    
                } else {
                    
                    self.redemButtonHeightAnchor.constant = 50.0f;
                    self.redemptionStartViewHeightAnchor.constant = 0.0f;
                    
                }
                
            }
            
        }
        
    }
  
}

- (IBAction)redeemButtonClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(redeemButtonClicked)]) {
        [self.delegate redeemButtonClicked];
    }

}


@end
