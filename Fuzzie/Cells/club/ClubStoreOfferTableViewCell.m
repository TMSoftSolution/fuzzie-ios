//
//  ClubStoreOfferTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreOfferTableViewCell.h"

@implementation ClubStoreOfferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.ivStore withCornerRadius:2.0f];
    [CommonUtilities setView:self.vShadow withCornerRadius:2.0f];
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:tapGuesture];
    
}

- (void)setCell:(NSDictionary *)offer{
   
    if (offer) {
        
        self.offer = offer;
        
        self.lbName.text = offer[@"name"];
        self.lbOfferType.text = @"";
        
        if (offer[@"image_url"] && ![offer[@"image_url"] isKindOfClass:[NSNull class]]) {
            
            [self.ivStore sd_setImageWithURL:[NSURL URLWithString:offer[@"image_url"]] placeholderImage:[UIImage imageNamed:@"club-offer-placeholder"]];
        }
        
        NSDictionary *brandType = [FZData getBrandType:offer[@"brand_type_id"]];
        if (brandType) {
            
            NSDictionary *offerType = [FZData getOfferType:offer[@"offer_type_id"] brandType:brandType];
            
            if (offerType) {
                
                self.lbOfferType.text = offerType[@"name"];
            }
        }
        
        NSDictionary *redeemDetails = offer[@"redemption_details"];
        
        if (redeemDetails && ![redeemDetails isKindOfClass:[NSNull class]]) {
            
            if (redeemDetails[@"redeemed_at"] && ![redeemDetails[@"redeemed_at"] isKindOfClass:[NSNull class]]) {
                
                self.lbSave.text = [NSString stringWithFormat:@"Redeemed %@", [[GlobalConstants clubOfferRedeemDateFormatter] stringFromDate:[[GlobalConstants standardFormatter] dateFromString:redeemDetails[@"redeemed_at"]]]];
            } else {
                
                self.lbSave.text = @"";
                
            }
            self.lbSave.textColor = [UIColor colorWithHexString:@"#939393"];
            
            self.vShadow.hidden = NO;
            
        } else {
            
            self.lbSave.text = [[NSString stringWithFormat:@"Estimated savings: S$%.2f", [offer[@"estimated_savings"] floatValue]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.lbSave.textColor = [UIColor colorWithHexString:HEX_COLOR_RED];
            
            self.vShadow.hidden = YES;
        }
        
        
    } else {
        
        self.lbName.text = @"";
        self.lbOfferType.text = @"";
        self.lbSave.text = @"";
        
        self.vShadow.hidden = YES;
    }
}

- (void)cellTapped{
    
    NSDictionary *redeemDetails = self.offer[@"redemption_details"];
    if ([redeemDetails isKindOfClass:[NSNull class]]) {
        
        if ([self.delegate respondsToSelector:@selector(clubStoreOfferCellTapped:)]) {
            
            [self.delegate clubStoreOfferCellTapped:self.offer];
        }
    }
  
}

@end
