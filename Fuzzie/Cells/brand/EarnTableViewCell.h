//
//  EarnTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/14/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EarnTableViewCellDelegate <NSObject>

- (void)linkTapped;
- (void)powerUpBannerClicked;

@end

@interface EarnTableViewCell : UITableViewCell <MDHTMLLabelDelegate>

@property (weak, nonatomic) id<EarnTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet TKRoundedView *cashbackContainer;
@property (weak, nonatomic) IBOutlet TKRoundedView *powerupContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerupContainerHeightAnchor;
@property (weak, nonatomic) IBOutlet UILabel *powerupPercentage;
@property (weak, nonatomic) IBOutlet UILabel *cashbackPercentage;

@property (weak, nonatomic) IBOutlet UILabel *earnLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *lbLearn;

- (void)setCell:(FZBrand*)brand earnValue:(NSNumber*)earnValue;
- (void)setEarnCashback:(NSNumber*)earnValue;

@property (assign, nonatomic) BOOL isSettedOnceTime;

@end
