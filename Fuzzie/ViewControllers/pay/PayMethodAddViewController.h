//
//  PayMethodAddViewController.h
//  Fuzzie
//
//  Created by mac on 8/16/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayMethodAddViewControllerDelegate <NSObject>

@optional
- (void) paymentMethodAdded:(NSDictionary*)methodDict;

@end

@interface PayMethodAddViewController : FZBaseViewController

@property (weak, nonatomic) id<PayMethodAddViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL enableCardNumber;
@property (assign, nonatomic) BOOL enableExprire;
@property (assign, nonatomic) BOOL enableCCV;

@property (assign, nonatomic) BOOL fromPaymentPage;
@property (assign, nonatomic) BOOL newCardAdded;
@property (assign, nonatomic) BOOL prePay;

@property (strong, nonatomic) NSDictionary *cardInfo;

@end
