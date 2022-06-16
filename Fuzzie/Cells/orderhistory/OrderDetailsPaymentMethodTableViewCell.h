//
//  OrderDetailsPaymentMethodTableViewCell.h
//  Fuzzie
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CellTypeCredits,
    CellTypeCard,
    CellTypeCount
} CellType;

@interface OrderDetailsPaymentMethodTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivCardType;
@property (weak, nonatomic) IBOutlet UILabel *lbCardNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

- (void)setCellWithDict:(NSDictionary*)dict cellType:(NSUInteger) cellType;

@end
