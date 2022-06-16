//
//  OrderDetailsBillTableViewCell.h
//  Fuzzie
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailsBillTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbBrandName;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet TKRoundedView *cashbackContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;
@property (weak, nonatomic) IBOutlet TKRoundedView *powerupContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbPowerUp;
@property (weak, nonatomic) IBOutlet UIStackView *cashbackEarnedContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbCashbackEarned;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackZeroWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerUpZeroWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerLeftAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackViewHeightAnchor;

@property (strong, nonatomic) NSDictionary *dict;
@property (assign, nonatomic) BOOL isLast;

// For Gift
- (void)setCellWithDict:(NSDictionary*)dict withLast:(BOOL)isLast;

// For Non- Gift such as TopUp, Red Packet
- (void)setCell:(NSDictionary*)dict;

@end
