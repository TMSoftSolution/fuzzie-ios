//
//  PowerUpCardRedeemTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 3/23/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PowerUpCardRedeemTableViewCellDelegate <NSObject>

- (void)activateButtonPressed;

@end

@interface PowerUpCardRedeemTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PowerUpCardRedeemTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbOrderNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnActivate;
@property (weak, nonatomic) IBOutlet UILabel *lbValid;

- (void)setCellWith:(NSDictionary*)giftDict;

@end
