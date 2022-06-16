//
//  DeliveryMethodViewController.h
//  Fuzzie
//
//  Created by mac on 6/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZFacebookFriend.h"

@interface DeliveryMethodViewController : FZBaseViewController

@property (strong, nonatomic) NSDictionary *giftDict;
@property (strong, nonatomic) NSDictionary *giftCardDict;
@property (strong, nonatomic) NSDictionary *giftServiceDict;
@property (strong, nonatomic) FZFacebookFriend *receiver;
@property (assign, nonatomic) BOOL showBack;
@end
