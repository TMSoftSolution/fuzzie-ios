//
//  DeliverMethodTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 2/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "DeliverMethodTableViewCell.h"

@implementation DeliverMethodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCell:(DeliveryMethodType)type{
    
    self.type = type;
    
    switch (type) {
        case DeliveryMethodTypeWhatsapp:
        {
            self.ivIcon.image = [UIImage imageNamed:@"share_whatsapp"];
            self.lbName.text = @"WhatsApp";
            break;

        }
        case DeliveryMethodTypeMessenger:
        {
            self.ivIcon.image = [UIImage imageNamed:@"share_messenger"];
            self.lbName.text = @"Messenger";
            break;
        }
        case DeliveryMethodTypeSMS:
        {
            self.ivIcon.image = [UIImage imageNamed:@"share_sms"];
            self.lbName.text = @"SMS";
            break;
        }
        case DeliveryMethodTypeEmail:
        {
            self.ivIcon.image = [UIImage imageNamed:@"share_email"];
            self.lbName.text = @"Email";
            break;
        }
        case DeliveryMethodTypeCopyLink:
        {
            self.ivIcon.image = [UIImage imageNamed:@"share_copylink"];
            self.lbName.text = @"Copy link";
            break;
        }
        default:
            break;
    }
}

- (IBAction)deliveryButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deliveryRedPacket:)]) {
        [self.delegate deliveryRedPacket:self.type];
    }
}


@end
