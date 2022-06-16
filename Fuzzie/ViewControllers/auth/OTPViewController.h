//
//  OTPViewController.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 21/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPViewController : FZBaseViewController

// Update Date is used for Facebook Sign Ups
@property (assign, nonatomic) BOOL isNumberUpdate;
@property (strong, nonatomic) NSString *phoneNumber;

@end
