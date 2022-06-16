//
//  BankListTableViewCell.h
//  Fuzzie
//
//  Created by mac on 8/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BankListTableViewCellDelegate <NSObject>

- (void)cellTapped:(NSDictionary*)dict;

@end

@interface BankListTableViewCell : UITableViewCell

@property (weak, nonatomic) id<BankListTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UIImageView *ivBank;

- (void)setCellWith:(NSDictionary*)dict;

@end
