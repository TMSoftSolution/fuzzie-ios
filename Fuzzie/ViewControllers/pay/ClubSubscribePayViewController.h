//
//  ClubSubscribePayViewController.h
//  Fuzzie
//
//  Created by joma on 6/18/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"

@interface ClubSubscribePayViewController : FZBaseViewController

@property (strong, nonatomic) FZUser *user;
@property (strong, nonatomic) NSDictionary *paymentMethodDict;
@property (assign, nonatomic) CGFloat creditsToUse;
@property (assign, nonatomic) CGFloat totalPrice;
@property (assign, nonatomic) CGFloat totalCashback;
@property (assign, nonatomic) CGFloat promoCashback;
@property (strong, nonatomic) NSDictionary *promoCodeDict;
@property (assign, nonatomic) BOOL appliedPromoCode;
@property (assign, nonatomic) BOOL usePromoCode;
@property (assign, nonatomic) BOOL isDeletePromoCode;
@property (assign, nonatomic) BOOL isUseActivateCode;
@property (strong, nonatomic) NSString *netsPaymentRef;

@end
