//
//  OrderDetailsDateTableViewCell.h
//  Fuzzie
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailsDateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbOrderNumber;

- (void)setCellWithDict:(NSDictionary*)dict;
@end
