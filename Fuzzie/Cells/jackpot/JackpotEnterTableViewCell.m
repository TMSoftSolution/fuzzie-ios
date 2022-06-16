//
//  JackpotEnterTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotEnterTableViewCell.h"

@implementation JackpotEnterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:guesture];
    
    [CommonUtilities setView:self.ivBrand withCornerRadius:2.0f];
    [CommonUtilities setView:self.lbSoldOut withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:2.0f];
    [CommonUtilities setView:self.cashbackContainerView withBackground:[UIColor colorWithHexString:@"#3B93DA"] withRadius:2.0f];
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#282828"];

}

- (void)setCell:(FZCoupon *)coupon{
    
    [self setCell:coupon mode:kJackpotEnterCellModeNormal];

}

- (void)setCell:(FZCoupon *)coupon mode:(NSUInteger)mode{
    
    if (coupon) {
        self.coupon = coupon;
        self.brand = [FZData getBrandById:coupon.brandId];
        
        if (mode == kJackpotEnterCellModeNormal) {
            
            self.lbName.text = coupon.name;
            self.lbBrandName.text = self.brand.name;
            [self.ivBrand sd_setImageWithURL:[NSURL URLWithString:coupon.backgroundImage] placeholderImage:[UIImage imageNamed:@"category-placeholder"]];
            
            self.ivClubMember.hidden = !(self.brand && [self.brand.isClubOnly boolValue]);
        
        } else if (mode == kJackpotEnterCellModePack){
            
            self.lbName.text = self.coupon.name;
            self.lbBrandName.text = @"Fuzzie";
            [self.ivBrand setImage:[UIImage imageNamed:@"placeholder-power-up-pack"]];
            
            self.ivClubMember.hidden = YES;
            
        }
        
        
            
        int ticketsCount = [coupon.ticketCount intValue];
        if (ticketsCount == 1) {
            self.lbTicketCount.text = [NSString stringWithFormat:@"+%d FREE JACKPOT TICKET", ticketsCount];
        } else{
            self.lbTicketCount.text = [NSString stringWithFormat:@"+%d FREE JACKPOT TICKETS", ticketsCount];
        }
        
        self.lbPrice.attributedText = [CommonUtilities getFormattedValueWithPrice:coupon.priceValue mainFontName:FONT_NAME_LATO_BOLD mainFontSize:16.0f secondFontName:FONT_NAME_LATO_BOLD secondFontSize:10.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:16.0f];
        
        if ([self.coupon.soldOut boolValue]) {
            self.lbSoldOut.hidden = NO;
            self.cashbackContainerView.hidden = YES;
        } else {
            self.lbSoldOut.hidden = YES;
            
            if ([self.coupon.cashbackPercentage floatValue] > 0) {
                
                self.cashbackContainerView.hidden = NO;
                self.lbCashback.attributedText = [CommonUtilities getFormattedCashbackPercentage:self.coupon.cashbackPercentage fontSize:12 decimalFontSize:12];
                
            } else{
                
                self.cashbackContainerView.hidden = YES;
                
            }
        }
        
    }
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(jackpotEnterCellTapped:brand:)]) {
        [self.delegate jackpotEnterCellTapped:self.coupon brand:self.brand];
    }
}

@end
