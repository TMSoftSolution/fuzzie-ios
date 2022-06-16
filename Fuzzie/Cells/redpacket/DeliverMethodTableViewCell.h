//
//  DeliverMethodTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DeliveryMethodTypeWhatsapp,
    DeliveryMethodTypeMessenger,
    DeliveryMethodTypeSMS,
    DeliveryMethodTypeEmail,
    DeliveryMethodTypeCopyLink
} DeliveryMethodType;

@protocol DeliverMethodTableViewCellDelegate <NSObject>

- (void)deliveryRedPacket:(DeliveryMethodType)type;

@end

@interface DeliverMethodTableViewCell : UITableViewCell

@property (weak, nonatomic) id<DeliverMethodTableViewCellDelegate> delegate;
@property (assign, nonatomic) DeliveryMethodType type;

@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbName;

- (void)setCell:(DeliveryMethodType)type;

@end
