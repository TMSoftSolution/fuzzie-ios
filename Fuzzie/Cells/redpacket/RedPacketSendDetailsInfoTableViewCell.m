//
//  RedPacketSendDetailsInfoTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketSendDetailsInfoTableViewCell.h"

@implementation RedPacketSendDetailsInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCell:(NSDictionary *)dictionary{
    
    if (dictionary) {
      
        self.llbQuantity.text = [NSString stringWithFormat:@"%@", dictionary[@"number_of_red_packets"]];
        self.lbLuck.attributedText = [CommonUtilities getFormattedValueWithPrice:dictionary[@"value"] mainFontName:FONT_NAME_LATO_BOLD mainFontSize:16.0f secondFontName:FONT_NAME_LATO_BOLD secondFontSize:12.0f symboFontName:FONT_NAME_LATO_BOLD symbolFontSize:16.0f];
        
        NSString *message = dictionary[@"message"];
        if (message && message.length > 0) {
            self.lbMessage.text = [NSString stringWithFormat:@"%@", message];
        } else{
            self.lbMessage.text = @"";
        }
        
        self.lbOpened.text = [NSString stringWithFormat:@"%@", dictionary[@"opened_packets_count"]];
        
        NSNumber *ticketCount = dictionary[@"number_of_jackpot_tickets"];
        NSNumber *quantity = dictionary[@"number_of_red_packets"];
        self.lbTicket.text = [NSString stringWithFormat:@"%d", ticketCount.intValue * quantity.intValue];
    }
}

@end
