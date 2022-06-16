//
//  RedPacketDeliveryViewController.h
//  Fuzzie
//
//  Created by Joma on 2/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketDeliveryViewController : FZBaseViewController

@property (assign, nonatomic) BOOL fromWalletPage;
@property (strong, nonatomic) NSDictionary *dictionary;

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *redPacketUrl;

@property (strong, nonatomic) NSString *shareMessage;

@end
