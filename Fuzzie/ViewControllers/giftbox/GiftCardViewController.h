//
//  GiftCardViewController.h
//  Fuzzie
//
//  Created by mac on 5/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandViewController.h"
#import "FZFacebookFriend.h"

@interface GiftCardViewController : BrandViewController
@property (strong, nonatomic) NSDictionary *giftDict;
@property (strong, nonatomic) NSDictionary *giftCardDict;
@property (assign, nonatomic) BOOL gifted;
@property (strong, nonatomic) FZFacebookFriend *sender;
@property (strong, nonatomic) NSString *message;

@end
