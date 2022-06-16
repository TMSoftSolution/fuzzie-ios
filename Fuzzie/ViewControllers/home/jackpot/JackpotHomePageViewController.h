//
//  JackpotEnterViewController.h
//  Fuzzie
//
//  Created by mac on 9/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JackpotHomePageViewController : FZBaseViewController

@property (nonatomic, strong) NSArray *couponArray;
@property (nonatomic, strong) NSMutableArray *couponBrandsArray;

@property (nonatomic, strong) NSArray *sortedCouponArray;
@property (nonatomic, strong) NSArray *refinedCouponArray;

@property (strong, nonatomic) NSSortDescriptor *sortDescriptor;

@end
