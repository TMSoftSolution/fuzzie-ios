//
//  ClubSubCategoryFilterTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/26/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubSubCategoryFilterTableViewCellDelegate <NSObject>

- (void)categoryCellTapped:(NSDictionary*)category;

@end

@interface ClubSubCategoryFilterTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) id<ClubSubCategoryFilterTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSMutableArray *selectedCategories;

- (void)setCell:(NSArray *)categories selectedCategories:(NSMutableArray*)selectedCategories;

@end
