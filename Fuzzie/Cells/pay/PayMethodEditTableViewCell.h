//
//  PayMethodEditTableViewCell.h
//  Fuzzie
//
//  Created by mac on 8/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayMethodEditTableViewCellDelegate <NSObject>

- (void)cellTapped:(NSDictionary*)itemDict position:(int)position;
- (void)deleteButtonPressed:(NSDictionary*)itemDict;

@end

@interface PayMethodEditTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PayMethodEditTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *itemDict;
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) int position;

@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;
@property (weak, nonatomic) IBOutlet UIImageView *ivCard;
@property (weak, nonatomic) IBOutlet UILabel *lbCard;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIImageView *ivSelect;

- (void)setCell:(NSDictionary*)itemDict isSelected:(BOOL)isSelected isEditing:(BOOL)isEditing position:(int)position;

@end
