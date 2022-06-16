//
//  JackpotTicketUseTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 1/17/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotTicketUseTableViewCellDelegate <NSObject>

- (void)useButtonPressed;
- (void)getJackpotButtonPressed;

@end

@interface JackpotTicketUseTableViewCell : UITableViewCell

@property (strong, nonatomic) id<JackpotTicketUseTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbTickets;
@property (weak, nonatomic) IBOutlet UILabel *lbValid;
@property (weak, nonatomic) IBOutlet UIButton *btnUse;
@property (weak, nonatomic) IBOutlet UIButton *btnGetMore;

- (void)initCell;

@end
