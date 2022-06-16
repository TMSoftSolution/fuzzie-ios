//
//  RedPacketHistoryReceiveTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketHistoryReceiveTableViewCell.h"

@implementation RedPacketHistoryReceiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.ivAvatar withCornerRadius:20.0f];
    [CommonUtilities setView:self.redMarkView withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:5.0f];
    [CommonUtilities setView:self.btnOpen withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:10.0f];
    
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:gusture];
}

- (void)setCell:(NSDictionary *)redPacket{
    
    if (redPacket) {
        self.redPacket = redPacket;
        
        NSString *senderImageUrl = redPacket[@"sender"][@"avatar"];
        
        if (senderImageUrl && ![senderImageUrl isKindOfClass:[NSNull class]] && ![senderImageUrl isEqualToString:@""]){
            
            [self.ivAvatar sd_setImageWithURL:[NSURL URLWithString:senderImageUrl] placeholderImage:[UIImage imageNamed:@"profile-image"]];
            
        } else {
            
            self.ivAvatar.image = [UIImage imageNamed:@"profile-image"];
        }
      
        self.lbName.text = redPacket[@"sender"][@"name"];
        
        self.used = [redPacket[@"used"] boolValue];
        
        self.btnOpen.hidden = self.used;
        self.redMarkView.hidden = self.used;
        self.ivArrow.hidden = !self.used;
        
        NSString *receivedDate = redPacket[@"created_at"];
        
        if (receivedDate && ![receivedDate isKindOfClass:[NSNull class]] && ![receivedDate isEqualToString:@""]) {
            
            NSDate *date = [[GlobalConstants standardFormatter] dateFromString:receivedDate];
            self.lbDate.text = [NSString stringWithFormat:@"Received %@", [[date timeAgoSinceDate:[NSDate date] numericDates:YES] lowercaseString]];
            
        } else {
            
            self.lbDate.text = @"";
        }
    }
}

- (IBAction)openButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(openButtonPressed:)]) {
        [self.delegate openButtonPressed:self.redPacket];
    }
}

- (void)cellTapped{
    
    if (self.used) {
        if ([self.delegate respondsToSelector:@selector(receivedRedPacketPressed:)]) {
            [self.delegate receivedRedPacketPressed:self.redPacket];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(openButtonPressed:)]) {
            [self.delegate openButtonPressed:self.redPacket];
        }
    }

}

@end
