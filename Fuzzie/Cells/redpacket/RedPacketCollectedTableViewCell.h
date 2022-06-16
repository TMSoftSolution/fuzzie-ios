//
//  RedPacketCollectedTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketCollectedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbCredit;
@property (weak, nonatomic) IBOutlet UILabel *lbTicket;

- (void)setCell:(CGFloat)credit ticket:(int)ticket;

@end
