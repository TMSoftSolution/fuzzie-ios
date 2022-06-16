//
//  OrderHistoryTableViewCell.h
//  Fuzzie
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderHistoryTableViewCellDelegate <NSObject>

- (void)cellTapped:(NSDictionary*)dict;

@end

@interface OrderHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) id<OrderHistoryTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalPrice;
@property (weak, nonatomic) IBOutlet UIStackView *cashbackView;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;

- (void)setCellWithDict:(NSDictionary*)dict;

@end
