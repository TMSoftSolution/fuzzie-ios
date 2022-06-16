//
//  PowerUpPreviewTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 3/25/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import "BrandListCollectionViewCell.h"

@protocol PowerUpPreviewTableViewCellDelegate <NSObject>

- (void)brandWasClicked:(FZBrand *)brand;
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state;
@end

@interface PowerUpPreviewTableViewCell : UITableViewCell  <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BrandListCollectionViewCellDelegate>

@property (weak, nonatomic) id<PowerUpPreviewTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSArray *brandArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *fuzzieLoader;

- (void)startLoader;
- (void)stopLoader;

@end
