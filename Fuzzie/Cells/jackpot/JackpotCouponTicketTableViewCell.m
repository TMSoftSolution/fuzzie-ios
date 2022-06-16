//
//  JackpotCouponTicketTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotCouponTicketTableViewCell.h"

@implementation JackpotCouponTicketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.btnChoose withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:2.0f];
    [CommonUtilities setView:self.container withCornerRadius:4.0f withBorderColor:[UIColor colorWithHexString:@"#E3E3E3"] withBorderWidth:1.0f];
    
    self.lbBody.htmlText = @"<a href='play'>Learn more about your rewards</a>";
    self.lbBody.delegate = self;
    self.lbBody.linkAttributes = @{
                                   NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#A3A3A3"],
                                   NSFontAttributeName: [UIFont fontWithName:FONT_NAME_LATO_BOLD size:12.0f],
                                   NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
}

- (void)setCell:(FZBrand*)brand coupon:(FZCoupon*)coupon{
    
    if (coupon) {
        
        self.coupon = coupon;
        
        self.lbTicketCount.text = [NSString stringWithFormat:@"%@", coupon.ticketCount];
        
        if ([self.coupon.cashbackValue floatValue] > 0.0f) {
            
            self.cashbackViewHeightAnchor.constant = 40.0f;
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[CommonUtilities getFormattedTotalValue:coupon.cashbackValue fontSize:14.0f smallFontSize:10.0f symbol:@""]];
            self.lbCashback.attributedText = attributedString;
            
            self.lbPercentage.text = [NSString stringWithFormat:@"%@%% Instant Cashback", [CommonUtilities getDecimalString:self.coupon.cashbackPercentage]];
            
        } else {
            
            self.cashbackViewHeightAnchor.constant = 0.0f;
        }
        
        if ([coupon.soldOut boolValue]) {
            self.btnChoose.enabled = false;
            [CommonUtilities setView:self.btnChoose withBackground:[UIColor colorWithHexString:@"#B9B9B9"] withRadius:2.0f];
        } else{
            self.btnChoose.enabled = true;
            [CommonUtilities setView:self.btnChoose withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:2.0f];
        }
    }

}

- (IBAction)chooseButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chooseButtonPressed:)]) {
        [self.delegate chooseButtonPressed:self.coupon];
    }
}


#pragma mark - MDHTMLLabelDelegate
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL{
    if ([self.delegate respondsToSelector:@selector(learnMoreButtonPressed)]) {
        [self.delegate learnMoreButtonPressed];
    }
    
}
@end
