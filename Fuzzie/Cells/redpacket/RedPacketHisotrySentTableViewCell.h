//
//  RedPacketHisotrySentTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedPacketHisotrySentTableViewCellDelegate <NSObject>

- (void)sentRedPacketPressed:(NSDictionary*)redPacketBundle;

@end

@interface RedPacketHisotrySentTableViewCell : UITableViewCell

@property (weak, nonatomic) id<RedPacketHisotrySentTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSDictionary *redPacketBundle;

@property (weak, nonatomic) IBOutlet UILabel *lbCount;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;

- (void)setCell:(NSDictionary*)redPacketBundle;

@end
