//
//  JackpotPayViewController.h
//  Fuzzie
//
//  Created by mac on 9/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JackpotPayViewController : FZBaseViewController

@property (strong, nonatomic) FZCoupon *coupon;
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
