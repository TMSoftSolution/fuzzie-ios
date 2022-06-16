//
//  TopUpTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopUpTableViewCellDelegate <NSObject>

- (void)buyButtonPressed:(NSNumber*)price;

@end

@interface TopUpTableViewCell : UITableViewCell

@property (nonatomic) NSNumber* price;
@property (weak, nonatomic) id<TopUpTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *ivFuzzie;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorLeftAnchor;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;

- (IBAction)buyButtonPressed:(id)sender;

- (void)setCell:(NSNumber*)price position:(NSInteger)position;

@end
