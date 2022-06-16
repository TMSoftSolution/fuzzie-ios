//
//  PowerUpRewardTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 3/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PowerUpRewardTableViewCellDelegate <NSObject>

- (void)chooseButtonPressed:(FZCoupon*)coupon;
- (void)learnMoreButtonPressed;

@end

@interface PowerUpRewardTableViewCell : UITableViewCell <MDHTMLLabelDelegate>

@property (weak, nonatomic) id<PowerUpRewardTableViewCellDelegate> delegate;

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
