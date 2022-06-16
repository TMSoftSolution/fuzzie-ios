//
//  RedPacketPayViewController.h
//  Fuzzie
//
//  Created by Joma on 2/21/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketPayViewController : FZBaseViewController

@property (assign, nonatomic) BOOL isRandomMode;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSNumber *total;
@property (strong, nonatomic) NSNumber *quantity;
@property (strong, nonatomic) NSNumber *ticketCount;

@property (strong, nonatomic) FZUser *user;
@property (assign, nonatomic) CGFloat creditsToUse;
@property (assign, nonatomic) CGFloat totalPrice;
@property (assign, nonatomic) CGFloat totalCashback;
@property (assign, nonatomic) CGFloat promoCashback;
@property (strong, nonatomic) NSDictionary *promoCodeDict;
@property (assign, nonatomic) BOOL appliedPromoCode;
@property (assign, nonatomic) BOOL usePromoCode;

@property (assign, nonatomic) BOOL topUpPop;
@property (assign, nonatomic) BOOL isDeletePromoCode;
@property (assign, nonatomic) BOOL isUseActivateCode;

@end
