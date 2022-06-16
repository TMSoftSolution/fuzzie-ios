//
//  OrderDetailsPaymentMethodTableViewCell.m
//  Fuzzie
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "OrderDetailsPaymentMethodTableViewCell.h"

@implementation OrderDetailsPaymentMethodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWithDict:(NSDictionary *)dict cellType:(NSUInteger)cellType{

    if (dict){
        
        if (cellType == CellTypeCredits) {
            
            [self.ivCardType setImage:[UIImage imageNamed:@"fuzzieCredit-icon"]];
            [self.lbCardNumber setText:@"Fuzzie Credits Used"];
            
            self.lbPrice.attributedText = [CommonUtilities getFormattedCashbackValue:dict[@"paid_with_credits"] fontSize:16.0f smallFontSize:12.0f];
            
        } else if (cellType == CellTypeCard){
            
            NSString *paymentType = dict[@"payment_instrument_type"];
            if (paymentType) {
                if ([paymentType isEqualToString:@"apple_pay_card"]) {
                    
                    [self.ivCardType setImage:[UIImage imageNamed:@"icon-payment-apple"]];
                    [self.lbCardNumber setText:@"Apple Pay"];
                    
                } else if ([paymentType isEqualToString:@"android_pay_card"]){
                    
                    [self.ivCardType setImage:[UIImage imageNamed:@"icon-payment-android"]];
                    [self.lbCardNumber setText:@"Android Pay"];
                    
                } else{
                    
                    [self.ivCardType setImage:[UIImage imageNamed:@"icon-payment-uob"]];
                    NSString *cardNumber = dict[@"card_number"];
                    if (cardNumber.length > 4) {
                        [self.lbCardNumber setText:[NSString stringWithFormat:@"••••••• %@", [cardNumber substringFromIndex:cardNumber.length - 4]]];
                    } else{
                        [self.lbCardNumber setText:@""];
                    }
                    
                }
            }
            
            self.lbPrice.attributedText = [CommonUtilities getFormattedCashbackValue:dict[@"paid_with_card"] fontSize:16.0f smallFontSize:12.0f];
        }

    }
}

@end
