//
//  SentCardActionTableViewCell.h
//  Fuzzie
//
//  Created by mac on 7/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SentCardActionTableViewCellDelegate <NSObject>

- (void)sendButtonPressed;

@end

@interface SentCardActionTableViewCell : UITableViewCell

@property(strong, nonatomic) NSDictionary *giftDict;

@property(weak, nonatomic) id<SentCardActionTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UILabel *lbValideDate;
@property (weak, nonatomic) IBOutlet UILabel *lbSentDate;
@property (weak, nonatomic) IBOutlet UILabel *lbOrderNumber;

- (void)setCellWith:(NSDictionary*)dict;
@end
