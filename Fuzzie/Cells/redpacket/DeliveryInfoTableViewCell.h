//
//  DeliveryInfoTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbMessasge;
@property (weak, nonatomic) IBOutlet UILabel *lbTicket;

- (void)setCell:(NSDictionary*)redPacketBundle;

@end
