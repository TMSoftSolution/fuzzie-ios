//
//  BrandListCollectionViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrandListCollectionViewCellDelegate <NSObject>
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state;
@end

@interface BrandListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet TKRoundedView *cashbackContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackContainerWidthAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerupContainerWidthAnchor;
@property (weak, nonatomic) IBOutlet TKRoundedView *powerUpContainer;
@property (weak, nonatomic) IBOutlet UILabel *powerUpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ivPowerUp;
@property (weak, nonatomic) IBOutlet UILabel *nbLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promoIcon;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *ivClubMember;

@property (weak, nonatomic) id<BrandListCollectionViewCellDelegate> delegate;
@property (strong, nonatomic) NSString *brandId;
@property (strong, nonatomic) FZBrand *brand;

- (void)setEmptyHeart;
- (void)setFilledHeart;
- (void)updateNbLikes:(NSNumber *)nbLike;
- (void)setDataBrandBy:(NSString *)brandId;
- (void)setDataWith:(FZBrand *)brand;

@end
