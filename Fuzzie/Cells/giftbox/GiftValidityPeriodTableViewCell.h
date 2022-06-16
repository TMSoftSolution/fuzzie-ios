//
//  GiftValidityPeriodTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 12/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftValidityPeriodTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *offerView;
@property (weak, nonatomic) IBOutlet UILabel *lbRedeemStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lbRedeemEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lbOrderNumber;

- (void) setCellWith:(NSDictionary*)dict;

@end
