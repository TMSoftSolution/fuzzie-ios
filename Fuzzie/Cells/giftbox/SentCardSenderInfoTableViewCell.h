//
//  SentCardSenderInfoTableViewCell.h
//  Fuzzie
//
//  Created by mac on 7/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SentCardSenderInfoTableViewCellDelegate <NSObject>

- (void)editButtonPressed;

@end

@interface SentCardSenderInfoTableViewCell : UITableViewCell

@property(strong, nonatomic) NSDictionary *giftDict;

@property(weak, nonatomic) id<SentCardSenderInfoTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbSenderName;
@property (weak, nonatomic) IBOutlet UILabel *lbMessage;

-(void)setCellWith:(NSDictionary*)dict;

@end
