//
//  BrandPackageTitleTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandPackageTitleTableViewCell.h"
#import "Masonry.h"
@interface BrandPackageTitleTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTitle;
@property (weak, nonatomic) IBOutlet UILabel *brandTitleLabel;


@property (weak, nonatomic) IBOutlet TKRoundedView *cashbackContainerView;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;
@property (weak, nonatomic) IBOutlet TKRoundedView *powerUpContainer;
@property (weak, nonatomic) IBOutlet UILabel *powerUpLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackContainerWidthAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerupContainerWidthAnchor;
@property (weak, nonatomic) IBOutlet UIImageView *ivPowerUp;

@property (assign, nonatomic) BOOL cashbackContainerIsRounded;
@property (weak, nonatomic) IBOutlet UILabel *packagePrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPackagePrice;

@end


@implementation BrandPackageTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self roundedCashbackContainer];
}

- (void)setBrandInfo:(FZBrand *)brand andPackageInfo:(NSDictionary *)packageInfo {
       
    if (brand){
        
        self.brand = brand;
        
        self.brandTitleLabel.text = [NSString stringWithFormat:@"%@ - %@",brand.name,packageInfo[@"name"]];
        
        // tell constraints they need updating
        [self setNeedsUpdateConstraints];
        
        // update constraints now so we can animate the change
        [self updateConstraintsIfNeeded];
        
        NSDictionary *fontAttributes = @{NSFontAttributeName:self.brandTitleLabel.font};
        CGRect rect = [self.brandTitleLabel.text boundingRectWithSize:CGSizeMake(self.brandTitleLabel.frame.size.width, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                           attributes:fontAttributes
                                                              context:nil];
        
        self.heightTitle.constant = rect.size.height;

        
        if (packageInfo[@"cash_back"] && packageInfo[@"cash_back"][@"cash_back_percentage"] && packageInfo[@"cash_back"][@"power_up_percentage"]) {
            
            NSNumber *cashbackPercent = packageInfo[@"cash_back"][@"cash_back_percentage"];
            NSNumber *powerupPercent = packageInfo[@"cash_back"][@"power_up_percentage"];
            
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
            self.powerupContainerWidthAnchor.priority = 200;
        }

        if (packageInfo[@"discounted_price"]) {
            
            CGFloat originalPrice = [packageInfo[@"price"][@"value"] floatValue];
            CGFloat discountedPrice = [packageInfo[@"discounted_price"] floatValue];
            
            self.packagePrice.attributedText = [CommonUtilities getFormattedValueWithPrice:packageInfo[@"discounted_price"] mainFontName:FONT_NAME_LATO_BOLD mainFontSize:17.0f secondFontName:FONT_NAME_LATO_BOLD secondFontSize:13.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:17.0f];
            
            if (originalPrice == discountedPrice) {
                self.oldPackagePrice.text = @"";
            } else {
     
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[CommonUtilities getFormattedValueWithPrice:packageInfo[@"price"][@"value"] mainFontName:FONT_NAME_LATO_BOLD mainFontSize:17.0f secondFontName:FONT_NAME_LATO_BOLD secondFontSize:13.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:17.0f]];
                
                [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attributedString.length)];
                self.oldPackagePrice.attributedText = attributedString;
            }
            
        } else {
            self.oldPackagePrice.text = [NSString stringWithFormat:@"%@%.0f",packageInfo[@"price"][@"currency_symbol"], [packageInfo[@"price"][@"value"] floatValue]];
            self.oldPackagePrice.text = @"";
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
