//
//  RedPacketReceiveDetailsInfoTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "RedPacketReceiveDetailsInfoTableViewCell.h"

@implementation RedPacketReceiveDetailsInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.ivAvatar withCornerRadius:20.0f];
}

- (void)setCell:(NSDictionary *)redPacket{
    
    if (redPacket) {
        
        NSString *senderImageUrl = redPacket[@"sender"][@"avatar"];
        if (senderImageUrl && ![senderImageUrl isKindOfClass:[NSNull class]] && ![senderImageUrl isEqualToString:@""]){
            
            [self.ivAvatar sd_setImageWithURL:[NSURL URLWithString:senderImageUrl] placeholderImage:[UIImage imageNamed:@"profile-image"]];
            
        } else {
            
            self.ivAvatar.image = [UIImage imageNamed:@"profile-image"];
        }
        
        self.lbName.text = redPacket[@"sender"][@"name"];
        
        NSString *message = redPacket[@"message"];
        if (message && message.length > 0) {
            
            self.lbMessage.text = [NSString stringWithFormat:@"%@", message];
            
        } else {
            
            self.lbMessage.text = @"";
            
        }

    }
}

@end
