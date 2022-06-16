//
//  RedPacketSentUnopenedTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketSentUnopenedTableViewCell.h"

@implementation RedPacketSentUnopenedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.btnSend withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:12.5f];

    
}

- (void)setCell:(NSDictionary *)dict{
    
    if (dict) {
        
        NSNumber *quantity = dict[@"number_of_red_packets"];
        if (quantity.intValue == 1) {
            
            self.lbNote.htmlText = @"Your Lucky Packet has not been opened yet. You can <font color='#FA3E3F'>send it again to your friend here.</font>";
            
        } else {
            
            self.lbNote.htmlText = @"Some Lucky Packets haven't been opened yet. You can <font color='#FA3E3F'>send them again to your friends here.</font>";
        }
        
        
    }
}

- (IBAction)sendButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendButtonPressed)]) {
        [self.delegate sendButtonPressed];
    }
}


@end
