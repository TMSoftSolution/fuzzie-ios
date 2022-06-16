//
//  JackpotTicketsPastTableViewCell.h
//  Fuzzie
//
//  Created by joma on 4/25/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotTicketsPastTableViewCellDelegate <NSObject>

- (void)viewPastResultPressed;

@end

@interface JackpotTicketsPastTableViewCell : UITableViewCell

@property (weak, nonatomic) id<JackpotTicketsPastTableViewCellDelegate> delegate;

@end
