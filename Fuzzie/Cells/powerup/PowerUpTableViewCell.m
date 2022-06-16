//
//  PowerUpTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 3/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "PowerUpTableViewCell.h"

@implementation PowerUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:guesture];
    
    NSString *colorKey = @"color";
    NSString *locationKey = @"location";
    NSArray *gradientColorsAndLocations = (@[
                                             @{colorKey: [UIColor colorWithHexString:@"#37A7ED"],locationKey: @(0.0f)},
                                             @{colorKey: [UIColor colorWithHexString:@"#4260BB"],locationKey: @(1.0f)}
                                             ]);
    self.container.fillColor = [UIColor colorWithHexString:@"3B93DA"];
    self.container.cornerRadius = 4.0f;
    self.container.gradientColorsAndLocations = gradientColorsAndLocations;
    self.container.gradientDirection = TKGradientDirectionHorizontal | TKGradientDirectionDown;
}

- (void)setCell:(FZCoupon *)coupon{
    
    if (coupon) {
        
        self.coupon = coupon;
        
        self.lbName.text = [self.coupon.powerUpPack[@"name"] uppercaseString];
        
        int cardCount = [coupon.powerUpPack[@"number_of_codes"] intValue];
        if (cardCount == 1) {
            self.lbCard.text = [NSString stringWithFormat:@"%dx Power Up Card", cardCount];
        } else{
            self.lbCard.text = [NSString stringWithFormat:@"%dx Power Up Cards", cardCount];
        }
        
        int ticketsCount = [coupon.ticketCount intValue];
        if (ticketsCount == 1) {
            self.lbTicket.text = [NSString stringWithFormat:@"%dx Free Jackpot Ticket", ticketsCount];
        } else{
            self.lbTicket.text = [NSString stringWithFormat:@"%dx Free Jackpot Tickets", ticketsCount];
        }
        
        self.lbPrice.attributedText = [CommonUtilities getFormattedValueWithPrice:coupon.priceValue mainFontName:FONT_NAME_LATO_BOLD mainFontSize:16.0f secondFontName:FONT_NAME_LATO_BOLD secondFontSize:10.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:16.0f];
    }
    
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(powerupTableCellTapped:)]) {
        [self.delegate powerupTableCellTapped:self.coupon];
    }
}

@end
