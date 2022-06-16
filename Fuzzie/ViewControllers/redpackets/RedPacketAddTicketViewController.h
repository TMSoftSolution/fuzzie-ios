//
//  RedPacketAddTicketViewController.h
//  Fuzzie
//
//  Created by Joma on 3/29/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"

@protocol RedPacketAddTicketViewControllerDelegate <NSObject>

- (void)ticketAdded:(NSNumber*)ticketCount;

@end

@interface RedPacketAddTicketViewController : FZBaseViewController

@property (weak, nonatomic) id<RedPacketAddTicketViewControllerDelegate> delegate;

@property (nonatomic, assign) int availableTicketCount;
@property (strong, nonatomic) NSNumber *quantity;
@property (strong, nonatomic) NSNumber *ticketCount;
@property (strong, nonatomic) NSNumber *tempCount;

@end
