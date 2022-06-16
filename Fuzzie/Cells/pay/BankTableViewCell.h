//
//  BankTableViewCell.h
//  Fuzzie
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BankTableViewCellDelegate <NSObject>

- (void)cellTapped:(NSDictionary*)dict;

@end

@interface BankTableViewCell : UITableViewCell

@property (weak, nonatomic) id<BankTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *cardDict;

@property (weak, nonatomic) IBOutlet UIImageView *ivCard;
@property (weak, nonatomic) IBOutlet UILabel *lbCardName;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;

- (void)setCellWith:(NSDictionary*)cardDict;

@end
