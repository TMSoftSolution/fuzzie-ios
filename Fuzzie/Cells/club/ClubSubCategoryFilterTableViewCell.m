//
//  ClubSubCategoryFilterTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/26/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSubCategoryFilterTableViewCell.h"
#import "ClubPopluarCategoryCollectionViewCell.h"

@implementation ClubSubCategoryFilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"ClubPopluarCategoryCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"Cell"];
}

- (void)setCell:(NSArray *)categories selectedCategories:(NSMutableArray*)selectedCategories{
    
    if (categories) {
        
        self.categories = categories;
        self.selectedCategories = selectedCategories;
        
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ClubPopluarCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *category = self.categories[indexPath.row];
    [cell setCellWith:category checked:[self.selectedCategories containsObject:category]];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float width = ([UIScreen mainScreen].bounds.size.width - 40.0f) / 2;
    return CGSizeMake(width, width * 70 / 140);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(categoryCellTapped:)]) {
        [self.delegate categoryCellTapped:self.categories[indexPath.row]];
    }
}

@end
