//
//  CheckoutViewController.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 2/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuzzieViewController.h"

@protocol CheckoutViewControllerDelegate <NSObject>

- (void)checkoutViewDidAddGiftToShoppingBag:(NSDictionary *)giftDict;

@end

@interface CheckoutViewController : FuzzieViewController

@property (weak, nonatomic) id<CheckoutViewControllerDelegate> delegate;

@property (strong, nonatomic) FZBrand *brand;
@property (strong, nonatomic) NSDictionary *giftDict;

@end
