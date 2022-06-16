//
//  JackpotCouponTitleTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotCouponTitleTableViewCell.h"

@implementation JackpotCouponTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBrandInfo:(FZBrand *)brand coupon:(FZCoupon *)coupon isPowerUpPackMode:(BOOL)isPowerUpPackMode{
   
    if (isPowerUpPackMode) {
        
        self.brandTitleLabel.text = @"";
        self.couponTopConstraint.constant = 0.0f;
        
    } else {
        
        self.brandTitleLabel.text = brand.name;
        
    }
    
    if (coupon) {
        
        self.lbCouponName.text = coupon.name;

        self.lbPrice.attributedText = [CommonUtilities getFormattedValueWithPrice:coupon.priceValue mainFontName:FONT_NAME_LATO_BLACK mainFontSize:20.0f secondFontName:FONT_NAME_LATO_BLACK secondFontSize:14.0f symboFontName:FONT_NAME_LATO_BLACK symbolFontSize:20.0f];
        
        [self roundedCashbackContainer];

        if (coupon.cashbackPercentage) {
            if (coupon.cashbackPercentage.floatValue > 0) {
                self.cashbackLabel.attributedText = [CommonUtilities getFormattedCashbackPercentage:coupon.cashbackPercentage fontSize:13 decimalFontSize:13];
                self.cashbackContainerWidthAnchor.priority = 200;
            } else {
                self.cashbackLabel.text = @"";
                self.cashbackContainerWidthAnchor.priority = 999;
            }
        } else {
            self.cashbackLabel.text = @"";
            self.cashbackContainerWidthAnchor.priority = 999;
        }
    }
 
}

- (void)roundedCashbackContainer {
    
    self.cashbackContainerView.roundedCorners = TKRoundedCornerAll;
    self.cashbackContainerView.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainerView.cornerRadius = 2.0f;
}

@end
