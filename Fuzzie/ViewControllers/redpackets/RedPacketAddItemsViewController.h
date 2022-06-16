//
//  RedPacketAddItemsViewController.h
//  Fuzzie
//
//  Created by Joma on 3/28/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketAddItemsViewController : FZBaseViewController

@property (strong, nonatomic) FZUser *user;
@property (strong, nonatomic) NSNumber *quantity;
@property (strong, nonatomic) NSNumber *creditAmount;
@property (strong, nonatomic) NSNumber *ticketCount;
@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) BOOL isRandomMode;

@end
