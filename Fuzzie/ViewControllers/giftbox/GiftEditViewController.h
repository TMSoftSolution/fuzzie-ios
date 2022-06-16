//
//  GiftEditViewController.h
//  Fuzzie
//
//  Created by mac on 7/27/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZRedeemPopView.h"

@interface GiftEditViewController : FZBaseViewController

@property (strong, nonatomic) NSMutableDictionary *giftDict;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UITextField *tfName;

@property (nonatomic, strong) FZRedeemPopView *confirmView;

@property (assign, nonatomic) BOOL showSuccess;

@end
