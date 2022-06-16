//
//  RedPacketHistoryReceiveTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedPacketHistoryReceiveTableViewCellDelegate <NSObject>

- (void)openButtonPressed:(NSDictionary*)redPacket;
- (void)receivedRedPacketPressed:(NSDictionary*)redPacket;

@end

@interface RedPacketHistoryReceiveTableViewCell : UITableViewCell

@property (weak, nonatomic) id<RedPacketHistoryReceiveTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *redPacket;
@property (nonatomic, assign) BOOL used;

@property (weak, nonatomic) IBOutlet UIImageView *ivAvatar;
@property (weak, nonatomic) IBOutlet UIView *redMarkView;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UIButton *btnOpen;
@property (weak, nonatomic) IBOutlet UIImageView *ivArrow;

- (void)setCell:(NSDictionary*)redPacket;

@end
