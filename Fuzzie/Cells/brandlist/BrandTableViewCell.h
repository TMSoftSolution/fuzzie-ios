//
//  BrandTableViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrandTableViewCellDelegate <NSObject>

@optional
- (void)likeClickedForBrand:(FZBrand *)brand atIndexPath:(NSIndexPath *)indexPath;
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state cell:(UITableViewCell *)cell;

@end

@interface BrandTableViewCell : UITableViewCell

@property (weak, nonatomic) id<BrandTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) FZBrand *brand;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIImageView *ivPromo;

@property (weak, nonatomic) IBOutlet UIView *cashbackPowerUpContainer;
@property (weak, nonatomic) IBOutlet TKRoundedView *cashbackContainer;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackZeroWidthConstraint;
@property (weak, nonatomic) IBOutlet TKRoundedView *powerUpContainer;
@property (weak, nonatomic) IBOutlet UILabel *powerUpLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerUpZeroWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *ivPowerUp;

@property (weak, nonatomic) IBOutlet UILabel *nbLikesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *ivClubMember;

- (void)setupWithBrand:(FZBrand *)brand;

@end
