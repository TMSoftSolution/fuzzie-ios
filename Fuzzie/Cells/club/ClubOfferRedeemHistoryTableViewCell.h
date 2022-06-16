//
//  ClubOfferRedeemHistoryTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubOfferRedeemHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivStore;
@property (weak, nonatomic) IBOutlet UILabel *lbOfferName;
@property (weak, nonatomic) IBOutlet UILabel *lbBrandName;
@property (weak, nonatomic) IBOutlet UILabel *lbRedeemedDate;
@property (weak, nonatomic) IBOutlet UILabel *lbSaving;

- (void)setCell:(NSDictionary*)dict;

@end
