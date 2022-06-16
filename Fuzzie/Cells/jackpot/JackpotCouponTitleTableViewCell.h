//
//  JackpotCouponTitleTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface JackpotCouponTitleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *brandTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbCouponName;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackContainerWidthAnchor;
@property (weak, nonatomic) IBOutlet TKRoundedView *cashbackContainerView;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponTopConstraint;

@property (assign, nonatomic) BOOL cashbackContainerIsRounded;

- (void)setBrandInfo:(FZBrand *)brand coupon:(FZCoupon*)coupon isPowerUpPackMode:(BOOL)isPowerUpPackMode;

@end
