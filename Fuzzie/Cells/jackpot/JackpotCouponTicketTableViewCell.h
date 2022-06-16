//
//  JackpotCouponTicketTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotCouponTicketTableViewCellDelegate <NSObject>

- (void)chooseButtonPressed:(FZCoupon*)coupon;
- (void)learnMoreButtonPressed;

@end

@interface JackpotCouponTicketTableViewCell : UITableViewCell <MDHTMLLabelDelegate>

@property (weak, nonatomic) id<JackpotCouponTicketTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIButton *btnChoose;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketCount;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentage;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *lbBody;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackViewHeightAnchor;

@property (strong, nonatomic) FZCoupon *coupon;
- (void)setCell:(FZBrand*)brand coupon:(FZCoupon*)coupon;

@end
