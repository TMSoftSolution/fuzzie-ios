//
//  PowerUpPackPhotoCoverTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerUpPackPhotoCoverTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ivSoldOut;

- (void)setCell:(FZCoupon*)coupon;
- (void)setCellWith:(NSDictionary*)giftDict;

@end
