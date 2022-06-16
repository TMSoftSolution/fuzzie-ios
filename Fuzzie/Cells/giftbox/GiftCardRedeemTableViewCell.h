//
//  GiftCardRedeemTableViewCell.h
//  Fuzzie
//
//  Created by mac on 5/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GiftCardRedeemTableViewCellDelegate <NSObject>
- (void)redeemButtonClicked;
@end

@interface GiftCardRedeemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redemButtonHeightAnchor;
@property (strong, nonatomic) IBOutlet UIButton *redeemButton;
@property (weak, nonatomic) IBOutlet UIView *valideView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *validViewHeightAnchor;
@property (strong, nonatomic) IBOutlet UILabel *validDate;
@property (weak, nonatomic) IBOutlet UIView *onlineValidateView;
@property (weak, nonatomic) IBOutlet UILabel *onlineRedeemDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onlineValidateViewHeightAnchor;
@property (strong, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UIView *redemptionStartView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redemptionStartViewHeightAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbRedemption;


@property (weak, nonatomic) id<GiftCardRedeemTableViewCellDelegate> delegate;

- (void)setCellWith:(NSDictionary*)giftDict;

@end
