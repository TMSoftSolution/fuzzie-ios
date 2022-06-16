//
//  PaymentSuccessViewController.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 28/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentSuccessViewController : UIViewController

@property (assign, nonatomic) BOOL showCashback;
@property (strong, nonatomic) NSDictionary *successDict;
@property (assign, nonatomic) BOOL gifted;
@property (strong, nonatomic) FZFacebookFriend *receiver;
@property (assign, nonatomic) BOOL topUp;
@property (assign, nonatomic) BOOL fromJackpot;
@property (assign, nonatomic) BOOL isPowerUpPack;
@property (assign, nonatomic) BOOL fromRedPacket;

@end
