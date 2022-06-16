//
//  BrandCardTitleCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandCardTitleCell.h"
#import "Masonry.h"
@interface BrandCardTitleCell()
@property (weak, nonatomic) IBOutlet UILabel *brandTitleLabel;

@property (weak, nonatomic) IBOutlet TKRoundedView *cashbackContainerView;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;
@property (weak, nonatomic) IBOutlet TKRoundedView *powerUpContainer;
@property (weak, nonatomic) IBOutlet UILabel *powerUpLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackContainerWidthAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerupContainerWidthAnchor;
@property (weak, nonatomic) IBOutlet UIImageView *ivPowerUp;

@property (assign, nonatomic) BOOL cashbackContainerIsRounded;

@end


@implementation BrandCardTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self roundedCashbackContainer];
}

- (void)setBrandInfo:(FZBrand *)brand {
 
    if (brand){
        
        self.brand = brand;
        
        //Be careful estimateTitleHeightWith
        self.brandTitleLabel.text = [brand.name stringByAppendingString:@" E-Gift Card"];

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
                    self.cashbackContainerWidthAnchor.priority = 200;
                } else {
                    self.cashbackLabel.text = @"";
                    self.cashbackContainerWidthAnchor.priority = 999;
                }
                if (powerupPercent.floatValue > 0) {
                    self.powerUpLabel.attributedText = [CommonUtilities getFormattedPowerUpPercentage:powerupPercent fontSize:13 decimalFontSize:13];
                    self.powerupContainerWidthAnchor.priority = 200;

                } else {
                    self.powerUpLabel.text = @"";
                    self.powerupContainerWidthAnchor.priority = 999;
                }
            } else {
                self.cashbackLabel.text = @"";
                self.cashbackContainerWidthAnchor.priority = 999;
                self.powerUpLabel.text = @"";
                self.powerupContainerWidthAnchor.priority = 999;
            }
        } else {
            self.cashbackLabel.text = @"";
            self.cashbackContainerWidthAnchor.priority = 999;
            self.powerUpLabel.text = @"";
            self.powerupContainerWidthAnchor.priority = 999;
        }
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
