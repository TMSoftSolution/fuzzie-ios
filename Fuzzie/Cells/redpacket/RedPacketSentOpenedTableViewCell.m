//
//  RedPacketSentOpenedTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketSentOpenedTableViewCell.h"

@implementation RedPacketSentOpenedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.ivAvatar withCornerRadius:20.0f];
}

- (void)setCellWith:(NSDictionary *)redPacket{
    [self setCell:redPacket isMe:false];
}

- (void)setCell:(NSDictionary *)redPacket isMe:(BOOL)isMe{
    
    if (redPacket) {
        
        NSString *senderImageUrl = redPacket[@"user"][@"avatar"];
        if (senderImageUrl && ![senderImageUrl isKindOfClass:[NSNull class]] && ![senderImageUrl isEqualToString:@""]){
            
            [self.ivAvatar sd_setImageWithURL:[NSURL URLWithString:senderImageUrl] placeholderImage:[UIImage imageNamed:@"profile-image"]];
            
        } else {
            
            self.ivAvatar.image = [UIImage imageNamed:@"profile-image"];
        }
        
        if (isMe) {
            self.lbName.text = [NSString stringWithFormat:@"%@ (you)", redPacket[@"user"][@"name"]];
        } else {
            self.lbName.text = redPacket[@"user"][@"name"];
        }

        self.lbCredits.attributedText = [CommonUtilities getFormattedValueWithPrice:redPacket[@"value"] mainFontName:FONT_NAME_LATO_BLACK mainFontSize:16.0f secondFontName:FONT_NAME_LATO_BLACK secondFontSize:13.0f symboFontName:FONT_NAME_LATO_BLACK symbolFontSize:16.0f];
        
        self.lbTickets.text = [NSString stringWithFormat:@"X%@", redPacket[@"number_of_jackpot_tickets"]];
        
        self.markChampion.hidden = ![redPacket[@"champion"] boolValue];
        if ([redPacket[@"champion"] boolValue]) {
            [CommonUtilities setView:self.ivAvatar withCornerRadius:20.0f withBorderColor:[UIColor colorWithHexString:@"#FBAD2C"] withBorderWidth:1.0f];
        } else {
            [CommonUtilities setView:self.ivAvatar withCornerRadius:20.0f];
        }
        
    }
}

@end
