//
//  ClubOfferRedeemHistoryTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubOfferRedeemHistoryTableViewCell.h"

@implementation ClubOfferRedeemHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.ivStore withCornerRadius:2.0f];
}

- (void)setCell:(NSDictionary *)dict{
    
    if (dict) {
        
        self.lbOfferName.text = dict[@"name"];
        
        FZBrand *brand = [FZData getBrandById:dict[@"brand_id"]];
        self.lbBrandName.text = brand != nil ? brand.name : @"";
        
        if (dict[@"image_url"] && ![dict[@"image_url"] isKindOfClass:[NSNull class]]) {
            [self.ivStore sd_setImageWithURL:dict[@"image_url"] placeholderImage:[UIImage imageNamed:@"category-placeholder"]];
        } else {
            self.ivStore.image = [UIImage imageNamed:@"category-placeholder"];
        }
        
        NSDictionary *redemptionDetail = dict[@"redemption_details"];
        if (redemptionDetail && ![redemptionDetail isKindOfClass:[NSNull class]]) {
            self.lbRedeemedDate.text = [NSString stringWithFormat:@"Redeemed %@", [[GlobalConstants clubOfferRedeemDateFormatter] stringFromDate:[[GlobalConstants standardFormatter] dateFromString:redemptionDetail[@"redeemed_at"]]]];
        } else {
            self.lbRedeemedDate.text = @"";
        }

         self.lbSaving.attributedText = [CommonUtilities getFormattedCashbackValue:dict[@"estimated_savings"] fontSize:12.0f smallFontSize:12.0f];

    }
}

@end
