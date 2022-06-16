//
//  GiftBoxPowerUpCardTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/10/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GiftBoxPowerUpCardTableViewCellDelegate <NSObject>

- (void)powerUpCardCellTapped:(NSDictionary*)giftDict;

@end

@interface GiftBoxPowerUpCardTableViewCell : UITableViewCell

@property (weak, nonatomic) id<GiftBoxPowerUpCardTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *giftDict;

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *ivNew;

- (void)setCell:(NSDictionary*)giftDict;

@end
