//
//  PayViewController.h
//  Fuzzie
//
//  Created by mac on 8/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : FZBaseViewController

@property (strong, nonatomic) NSArray *brandArray;
@property (strong, nonatomic) NSArray *itemArray;
@property (assign, nonatomic) BOOL shoppingBag;
@property (assign, nonatomic) BOOL gifted;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) FZFacebookFriend *receiver;

@property (strong, nonatomic) FZUser *user;
@property (strong, nonatomic) NSDictionary *paymentMethodDict;
@property (strong, nonatomic) NSString *currencySymbol;
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
