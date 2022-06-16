//
//  RedPacketSendDetailsInfoTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketSendDetailsInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *llbQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lbLuck;
@property (weak, nonatomic) IBOutlet UILabel *lbOpened;
@property (weak, nonatomic) IBOutlet UILabel *lbMessage;
@property (weak, nonatomic) IBOutlet UILabel *lbTicket;

- (void)setCell:(NSDictionary*)dictionary;

@end
