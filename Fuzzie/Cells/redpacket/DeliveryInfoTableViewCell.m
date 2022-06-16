//
//  DeliveryInfoTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "DeliveryInfoTableViewCell.h"

@implementation DeliveryInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCell:(NSDictionary *)redPacketBundle{
    
    if (redPacketBundle) {
        
        self.lbQuantity.text = [NSString stringWithFormat:@"%@", redPacketBundle[@"number_of_red_packets"]];
        
        NSString *message = redPacketBundle[@"message"];
        if (message && message.length > 0) {
            self.lbMessasge.text = [NSString stringWithFormat:@"%@", message];
        } else{
            self.lbMessasge.text = @"";
        }
        
        self.lbTotal.attributedText = [CommonUtilities getFormattedValueWithPrice:redPacketBundle[@"value"] mainFontName:FONT_NAME_LATO_BOLD mainFontSize:16.0f secondFontName:FONT_NAME_LATO_BOLD secondFontSize:12.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:16.0f];
        
        NSNumber *ticketCount = redPacketBundle[@"number_of_jackpot_tickets"];
        NSNumber *quantity = redPacketBundle[@"number_of_red_packets"];
        self.lbTicket.text = [NSString stringWithFormat:@"%d", ticketCount.intValue * quantity.intValue];
        
    }
    
}

@end
