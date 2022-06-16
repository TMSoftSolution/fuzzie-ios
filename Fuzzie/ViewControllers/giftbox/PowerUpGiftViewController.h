//
//  PowerUpGiftViewController.h
//  Fuzzie
//
//  Created by Joma on 2/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandViewController.h"

@interface PowerUpGiftViewController : BrandViewController

@property (strong, nonatomic) NSDictionary *giftDict;
@property (strong, nonatomic) FZCoupon *coupon;

@property (assign, nonatomic) BOOL isPowerUpPack;

@end
