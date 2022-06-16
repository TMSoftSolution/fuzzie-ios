//
//  ClubPopularCategoryTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/24/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubPopularCategoryTableViewCellDelegate <NSObject>

- (void)categoryCellTapped:(NSDictionary*)category;

@end

@interface ClubPopularCategoryTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<ClubPopularCategoryTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *categories;

- (void)setCell:(NSArray*)categories;

@end
