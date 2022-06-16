//
//  RedPacketSentOpenedTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketSentOpenedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbCredits;
@property (weak, nonatomic) IBOutlet UIImageView *markChampion;
@property (weak, nonatomic) IBOutlet UILabel *lbTickets;

- (void)setCellWith:(NSDictionary *)redPacket;
- (void)setCell:(NSDictionary*)redPacket isMe:(BOOL)isMe;

@end
