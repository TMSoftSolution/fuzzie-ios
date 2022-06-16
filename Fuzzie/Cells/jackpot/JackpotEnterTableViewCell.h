//
//  JackpotEnterTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/7/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kJackpotEnterCellModeNormal,
    kJackpotEnterCellModePack,
} kJackpotEnterCellMode;

@protocol JackpotEnterTableViewCellDelegate <NSObject>

- (void)jackpotEnterCellTapped:(FZCoupon*)coupon brand:(FZBrand*)brand;

@end

@interface JackpotEnterTableViewCell : UITableViewCell

@property (weak, nonatomic) id<JackpotEnterTableViewCellDelegate> delegate;
@property (strong, nonatomic) FZCoupon *coupon;
@property (strong, nonatomic) FZBrand *brand;

@property (weak, nonatomic) IBOutlet UIImageView *ivBrand;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbBrandName;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketCount;
@property (weak, nonatomic) IBOutlet UILabel *lbSoldOut;
@property (weak, nonatomic) IBOutlet UIView *cashbackContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;
@property (weak, nonatomic) IBOutlet UIImageView *ivClubMember;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponNameCenterAnchor;

- (void)setCell:(FZCoupon*)coupon;
- (void)setCell:(FZCoupon*)coupon mode:(NSUInteger)mode;

@end
