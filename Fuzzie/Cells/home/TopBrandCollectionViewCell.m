//
//  TopBrandCollectionViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 3/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "TopBrandCollectionViewCell.h"


@interface TopBrandCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *brandImage;
@property (weak, nonatomic) IBOutlet TKRoundedView *cashbackContainerView;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;
@property (weak, nonatomic) IBOutlet TKRoundedView *powerUpContainer;
@property (weak, nonatomic) IBOutlet UILabel *powerUpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ivPowerUp;
@property (weak, nonatomic) FZBrand *brand;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashContainerWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerupContainerWidthConstraint;

@end

@implementation TopBrandCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.superview.superview.clipsToBounds = NO;
    self.superview.clipsToBounds = NO;
}

- (void)setupWithBrand:(FZBrand *)brand {
    
    self.brand = brand;
    
    NSURL *imageURL = [NSURL URLWithString:brand.customImage];
    [self.brandImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    
    if (brand.cashbackPercentage && brand.powerupPercentage) {
        
        NSNumber *cashbackPercent = brand.cashbackPercentage;
        NSNumber *powerupPercent = brand.powerupPercentage;
        
        if (cashbackPercent.floatValue + powerupPercent.floatValue > 0) {
            
            if (cashbackPercent.floatValue > 0 && powerupPercent.floatValue > 0) {
                
                [self roundedCashbackContainer];
                [self roundedPowerupContainer];
                
            } else {
                
                if (cashbackPercent.floatValue > 0) {
                    
                    [self fullRoundedCashbackContainer];
                    
                } else if (powerupPercent.floatValue > 0){
                    
                    [self fullRoundedPowerupContainer];
                }
            }
            
            if (cashbackPercent.floatValue > 0) {
                self.cashbackLabel.attributedText = [CommonUtilities getFormattedCashbackPercentage:cashbackPercent fontSize:13 decimalFontSize:13];
                self.cashContainerWidthConstraint.priority = 200;
            } else {
                self.cashbackLabel.text = @"";
                self.cashContainerWidthConstraint.priority = 999;
            }
            
            if (powerupPercent.floatValue > 0) {
                self.powerUpLabel.attributedText = [CommonUtilities getFormattedPowerUpPercentage:powerupPercent fontSize:13 decimalFontSize:13];
                self.powerupContainerWidthConstraint.priority = 200;
            } else {
                self.powerUpLabel.text = @"";
                self.powerupContainerWidthConstraint.priority = 999;
            }
            
        } else {
            
            self.cashbackLabel.text = @"";
            self.cashContainerWidthConstraint.priority = 999;
            self.powerUpLabel.text = @"";
            self.powerupContainerWidthConstraint.priority = 999;
            
            if (brand.brandLink && [brand.brandLink[@"type"] isEqualToString:@"jackpot_coupon"]) {
                
                FZCoupon *coupon = [FZData getCouponById:brand.brandLink[@"jackpot_coupon_template_id"]];
                
                if (coupon && coupon.cashbackPercentage && coupon.cashbackPercentage.floatValue > 0.0f) {
                    
                    self.cashbackLabel.attributedText = [CommonUtilities getFormattedCashbackPercentage:coupon.cashbackPercentage fontSize:13 decimalFontSize:13];
                    self.cashContainerWidthConstraint.priority = 200;
                    [self fullRoundedCashbackContainer];
                }
            }
        }
        
    } else {
        
        self.cashbackLabel.text = @"";
        self.cashContainerWidthConstraint.priority = 999;
        self.powerUpLabel.text = @"";
        self.powerupContainerWidthConstraint.priority = 999;
    }
}

- (void)roundedCashbackContainer {

    self.cashbackContainerView.roundedCorners = TKRoundedCornerTopLeft | TKRoundedCornerBottomLeft;
    self.cashbackContainerView.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainerView.cornerRadius = 2.0f;
}

- (void)fullRoundedCashbackContainer{
    
    self.cashbackContainerView.roundedCorners = TKRoundedCornerAll;
    self.cashbackContainerView.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainerView.cornerRadius = 2.0f;
}

- (void)roundedPowerupContainer{
    
    self.powerUpContainer.roundedCorners = TKRoundedCornerTopRight | TKRoundedCornerBottomRight;
    self.powerUpContainer.drawnBordersSides =  TKDrawnBorderSidesTop | TKDrawnBorderSidesRight | TKDrawnBorderSidesBottom;
    self.powerUpContainer.fillColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.powerUpContainer.cornerRadius = 2.0f;
    self.powerUpContainer.borderWidth = 1.0f;
    
    if ([UserController sharedInstance].currentUser.powerUpExpiryDate || [self.brand.powerUp boolValue]) {
        self.powerUpContainer.borderColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lightning-icon"];
    } else {
        self.powerUpContainer.borderColor = [UIColor colorWithHexString:@"#939393"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#939393"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lighting-icon-grey"];
    }
    
}

- (void)fullRoundedPowerupContainer{
    
    self.powerUpContainer.roundedCorners = TKRoundedCornerAll;
    self.powerUpContainer.fillColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.powerUpContainer.cornerRadius = 2.0f;
    self.powerUpContainer.borderWidth = 1.0f;
    
    if ([UserController sharedInstance].currentUser.powerUpExpiryDate || [self.brand.powerUp boolValue]) {
        self.powerUpContainer.borderColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lightning-icon"];
    } else {
        self.powerUpContainer.borderColor = [UIColor colorWithHexString:@"#939393"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#939393"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lighting-icon-grey"];
    }
}

@end
