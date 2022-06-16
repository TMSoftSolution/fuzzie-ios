//
//  JackpotCouponViewController.h
//  Fuzzie
//
//  Created by mac on 9/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JackpotCouponViewController : FZBaseViewController

@property (assign, nonatomic) int ticketCount;

@property (nonatomic, strong) NSMutableArray *digitsFilled;
@property (nonatomic, strong) NSMutableArray *digits;
@property (assign, nonatomic) BOOL isRandomize;
@property (assign, nonatomic) BOOL isBack;

@end
