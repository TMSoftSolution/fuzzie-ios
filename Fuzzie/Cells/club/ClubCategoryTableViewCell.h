//
//  ClubCategoryTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubCategoryTableViewCellDelegate <NSObject>

- (void)categoryCellTapped:(NSDictionary*)dict;

@end

@interface ClubCategoryTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<ClubCategoryTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSArray *brandTypes;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)setCell:(NSArray*)brandTypes;

@end
