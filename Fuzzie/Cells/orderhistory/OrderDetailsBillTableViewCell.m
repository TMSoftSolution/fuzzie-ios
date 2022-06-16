//
//  OrderDetailsBillTableViewCell.m
//  Fuzzie
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "OrderDetailsBillTableViewCell.h"

@implementation OrderDetailsBillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setCellWithDict:(NSDictionary *)dict withLast:(BOOL)isLast{
    
    if (dict) {
        
        self.dict = dict;
        self.isLast = isLast;
        
        [self.lbBrandName setText:dict[@"display_name"]];
        self.lbPrice.attributedText = [CommonUtilities getFormattedCashbackValue:dict[@"price"] fontSize:16.0f smallFontSize:12.0f];
        
        NSNumber *cashbackPercent = dict[@"cash_back_percentage"];
        NSNumber *powerupPercent = dict[@"power_up_percentage"];
        
        if (cashbackPercent.floatValue + powerupPercent.floatValue > 0) {
            
            if (cashbackPercent.floatValue > 0 && powerupPercent.floatValue > 0) {
                
                [self roundedCashbackContainer];
                [self roundedPowerupContainer];
                
            } else {

                if (cashbackPercent.floatValue > 0) {
                    
                    [self fullRoundedCashbackContainer];
                }
                
                if (powerupPercent.floatValue > 0) {
                    
                    [self fullRoundedPowerupContainer];
                }
            }
            
            self.cashbackViewHeightAnchor.constant = 40.0f;
            
            if (cashbackPercent.floatValue > 0) {
                self.lbCashback.attributedText = [CommonUtilities getFormattedCashbackPercentage:cashbackPercent fontSize:14 decimalFontSize:14];
                self.cashbackZeroWidthConstraint.priority = 200;
            } else {
                self.lbCashback.text = @"";
                self.cashbackZeroWidthConstraint.priority = 999;
            }
            if (powerupPercent.floatValue > 0) {
                self.lbPowerUp.attributedText = [CommonUtilities getFormattedPowerUpPercentage:powerupPercent fontSize:14 decimalFontSize:14];
                self.powerUpZeroWidthConstraint.priority = 200;
            } else {
                self.lbPowerUp.text = @"";
                self.powerUpZeroWidthConstraint.priority = 999;
                
            }
        } else {
            self.lbCashback.text = @"";
            self.cashbackZeroWidthConstraint.priority = 999;
            self.lbPowerUp.text = @"";
            self.powerUpZeroWidthConstraint.priority = 999;
            self.cashbackViewHeightAnchor.constant = 0.0f;
        }
        
        self.lbCashbackEarned.attributedText = [CommonUtilities getFormattedCashbackValue:dict[@"cash_back_value"] fontSize:12.0f smallFontSize:9.0f];
        
        if (isLast) {
            self.dividerLeftAnchor.constant = 0.0f;
        } else{
            self.dividerLeftAnchor.constant = 16.0f;
        }
    }

}

- (void)setCell:(NSDictionary *)dict{
    
    if (dict) {
        
        self.dividerLeftAnchor.constant = 0.0f;
        
        if ([dict[@"type"] isEqualToString:@"TopUp"]) {
            
            self.lbBrandName.text = @"Credits top up";
            
        } else if ([dict[@"type"] isEqualToString:@"RedPacket"]){
            
            self.lbBrandName.text = @"Lucky Packet";
            
        } else{
            
            self.lbBrandName.text = @"";
            
        }
        
        self.lbPrice.attributedText = [CommonUtilities getFormattedCashbackValue:dict[@"total_price"] fontSize:16.0f smallFontSize:12.0f];
        
        self.lbPowerUp.text = @"";
        self.powerUpZeroWidthConstraint.priority = 999;
        
        [self fullRoundedCashbackContainer];
        
        NSNumber *cashback = dict[@"total_cash_back"];
        if (cashback.floatValue > 0.0f) {
            
            self.cashbackViewHeightAnchor.constant = 40.0f;
            
            CGFloat cashbackPercent = cashback.floatValue / [dict[@"total_price"] floatValue] * 100;
            
            self.lbCashback.attributedText = [CommonUtilities getFormattedCashbackPercentage:[NSNumber numberWithFloat:cashbackPercent] fontSize:14 decimalFontSize:14];
            self.cashbackZeroWidthConstraint.priority = 200;
            
        } else {
            
            self.cashbackViewHeightAnchor.constant = 0.0f;
            
            self.lbCashback.text = @"";
            self.cashbackZeroWidthConstraint.priority = 999;
        }
        
    }
}

- (void)roundedCashbackContainer {
    
    self.cashbackContainer.roundedCorners = TKRoundedCornerTopLeft | TKRoundedCornerBottomLeft;
    self.cashbackContainer.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainer.cornerRadius = 2.0f;
}

- (void)fullRoundedCashbackContainer{
    
    self.cashbackContainer.roundedCorners = TKRoundedCornerAll;
    self.cashbackContainer.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainer.cornerRadius = 2.0f;
}

- (void)roundedPowerupContainer{
    
    self.powerupContainer.roundedCorners = TKRoundedCornerTopRight | TKRoundedCornerBottomRight;
    self.powerupContainer.drawnBordersSides =  TKDrawnBorderSidesTop | TKDrawnBorderSidesRight | TKDrawnBorderSidesBottom;
    self.powerupContainer.fillColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.powerupContainer.cornerRadius = 2.0f;
    self.powerupContainer.borderWidth = 1.0f;
    self.powerupContainer.borderColor = [UIColor colorWithHexString:@"#3B93DA"];

}

- (void)fullRoundedPowerupContainer{
    
    self.powerupContainer.roundedCorners = TKRoundedCornerAll;
    self.powerupContainer.fillColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.powerupContainer.cornerRadius = 2.0f;
    self.powerupContainer.borderWidth = 1.0f;
    self.powerupContainer.borderColor = [UIColor colorWithHexString:@"#3B93DA"];

}

@end
