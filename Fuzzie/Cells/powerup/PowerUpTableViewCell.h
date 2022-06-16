//
//  PowerUpTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 3/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PowerUpTableViewCellDelegate <NSObject>

- (void)powerupTableCellTapped:(FZCoupon*)coupon;

@end

@interface PowerUpTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PowerUpTableViewCellDelegate> delegate;
@property (strong, nonatomic) FZCoupon *coupon;

@property (weak, nonatomic) IBOutlet TKRoundedView *container;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbCard;
@property (weak, nonatomic) IBOutlet UILabel *lbTicket;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

- (void)setCell:(FZCoupon*)coupon;

@end
