//
//  TopUpPayViewController.h
//  Fuzzie
//
//  Created by mac on 9/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopUpPayViewController : FZBaseViewController

@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) FZUser *user;
@property (strong, nonatomic) NSDictionary *paymentMethodDict;
@property (assign, nonatomic) CGFloat promoCashback;
@property (strong, nonatomic) NSDictionary *promoCodeDict;
@property (assign, nonatomic) BOOL appliedPromoCode;
@property (assign, nonatomic) BOOL usePromoCode;
@property (assign, nonatomic) BOOL isDeletePromoCode;
@property (assign, nonatomic) BOOL isUseActivateCode;

@end
