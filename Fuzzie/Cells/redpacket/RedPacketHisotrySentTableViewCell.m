//
//  RedPacketHisotrySentTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketHisotrySentTableViewCell.h"

@implementation RedPacketHisotrySentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:gusture];
}

- (void)cellTapped{
    if ([self.delegate respondsToSelector:@selector(sentRedPacketPressed:)]) {
        [self.delegate sentRedPacketPressed:self.redPacketBundle];
    }
}

- (void)setCell:(NSDictionary *)redPacketBundle{
    
    if (redPacketBundle) {
        
        self.redPacketBundle = redPacketBundle;
        
        int count = [redPacketBundle[@"number_of_red_packets"] intValue];
        if (count > 1) {
            self.lbCount.text = [NSString stringWithFormat:@"%d Lucky Packets", count];
        } else {
            self.lbCount.text = [NSString stringWithFormat:@"%d Lucky Packet", count];
        }
        
        NSString *receivedDate = redPacketBundle[@"created_at"];
        
        if (receivedDate && ![receivedDate isKindOfClass:[NSNull class]] && ![receivedDate isEqualToString:@""]) {
            
            NSDate *date = [[GlobalConstants standardFormatter] dateFromString:receivedDate];
            self.lbDate.text = [NSString stringWithFormat:@"Bought %@", [[date timeAgoSinceDate:[NSDate date] numericDates:YES] lowercaseString]];
            
        } else {
            
            self.lbDate.text = @"";
        }
    }
}

@end
