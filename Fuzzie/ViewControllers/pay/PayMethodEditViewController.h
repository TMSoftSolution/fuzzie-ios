//
//  PayMethodEditViewController.h
//  Fuzzie
//
//  Created by mac on 8/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMethodEditViewController : FZBaseViewController

@property (assign, nonatomic) int selectedItem;
@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) NSMutableArray *paymentMethods;
@property (strong, nonatomic) NSDictionary *selectedDict;
@property (assign, nonatomic) BOOL fromPaymentPage;
@property (assign, nonatomic) BOOL showNetsInstall;
@property (assign, nonatomic) BOOL dontShowNets;

@end
