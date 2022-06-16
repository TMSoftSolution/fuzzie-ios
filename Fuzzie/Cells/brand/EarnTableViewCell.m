//
//  EarnTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/14/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "EarnTableViewCell.h"

@interface EarnTableViewCell ()
@end

@implementation EarnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lbLearn.htmlText = @"<a href='play'>Learn more about your rewards</a>";
    self.lbLearn.delegate = self;
    self.lbLearn.linkAttributes = @{
                                   NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#A3A3A3"],
                                   NSFontAttributeName: [UIFont fontWithName:FONT_NAME_LATO_BOLD size:12.0f],
                                   NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(powerUpBannerClicked)];
    [self.powerupContainer addGestureRecognizer:gusture];
}

- (void)setCell:(FZBrand *)brand earnValue:(NSNumber *)earnValue{
    
    if (brand && earnValue) {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[CommonUtilities getFormattedTotalValue:earnValue fontSize:14.0f smallFontSize:10.0f symbol:@""]];
        self.earnLabel.attributedText = attributedString;
        
        self.isSettedOnceTime = YES;
        
        FZUser *user = [UserController sharedInstance].currentUser;
        
        if (user.powerUpExpiryDate || [brand.powerUp boolValue]) {
            
            self.cashbackPercentage.text = [NSString stringWithFormat:@"%@%% Instant Cashback", [CommonUtilities getDecimalString:brand.percentage]];
            
        } else {
            
            self.cashbackPercentage.text = [NSString stringWithFormat:@"%@%% Instant Cashback", [CommonUtilities getDecimalString:brand.cashbackPercentage]];
        }
        
        if (brand.powerupPercentage.floatValue <= 0.0f || user.powerUpExpiryDate || [brand.powerUp boolValue]) {
            
            self.powerupContainerHeightAnchor.constant = 0.0f;
       
            [self fullRoundedCashbackContainer];
        
        } else {
            
            [self roundedCashbackContainer];
            [self roundedPowerUpContainer];
            self.powerupPercentage.text = [NSString stringWithFormat:@"Get +%@%% Cashback", [CommonUtilities getDecimalString:brand.powerupPercentage]];
        }
    }
}

- (void)setEarnCashback:(NSNumber *)earnValue {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[CommonUtilities getFormattedTotalValue:earnValue fontSize:14.0f smallFontSize:10.0f symbol:@""]];    
    self.earnLabel.attributedText = attributedString;
    
    self.isSettedOnceTime = YES;
}

- (void)roundedCashbackContainer{
    
    self.cashbackContainer.roundedCorners = TKRoundedCornerTopLeft | TKRoundedCornerTopRight;
    self.cashbackContainer.drawnBordersSides = TKDrawnBorderSidesLeft | TKDrawnBorderSidesTop | TKDrawnBorderSidesRight;
    self.cashbackContainer.borderColor = [UIColor colorWithHexString:@"#E3E3E3"];
    self.cashbackContainer.fillColor = [UIColor whiteColor];
    self.cashbackContainer.borderWidth = 1.0f;
    self.cashbackContainer.cornerRadius = 4.0f;

}

- (void)fullRoundedCashbackContainer{
    
    self.cashbackContainer.roundedCorners = TKRoundedCornerAll;
    self.cashbackContainer.drawnBordersSides = TKDrawnBorderSidesAll;
    self.cashbackContainer.borderColor = [UIColor colorWithHexString:@"#E3E3E3"];
    self.cashbackContainer.fillColor = [UIColor whiteColor];
    self.cashbackContainer.borderWidth = 1.0f;
    self.cashbackContainer.cornerRadius = 4.0f;
    
}

- (void)roundedPowerUpContainer {
    
    self.powerupContainer.roundedCorners = TKRoundedCornerBottomLeft | TKRoundedCornerBottomRight;
    self.powerupContainer.borderWidth = 0.0f;
    self.powerupContainer.cornerRadius = 4.0f;
    self.powerupContainer.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
}

- (void)powerUpBannerClicked{
    if ([self.delegate respondsToSelector:@selector(powerUpBannerClicked)]) {
        [self.delegate powerUpBannerClicked];
    }
    
}

#pragma mark - MDHTMLLabelDelegate
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL{
    if ([self.delegate respondsToSelector:@selector(linkTapped)]) {
        [self.delegate linkTapped];
    }
    
}

@end
