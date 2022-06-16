//
//  RedPacketSentUnopenedTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedPacketSentUnopenedTableViewCellDelegate <NSObject>

- (void)sendButtonPressed;

@end

@interface RedPacketSentUnopenedTableViewCell : UITableViewCell

@property (weak, nonatomic) id<RedPacketSentUnopenedTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *lbNote;

- (void)setCell:(NSDictionary*)dict;

@end
