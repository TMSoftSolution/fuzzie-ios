//
//  ClubCategoryTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubCategoryTableViewCell.h"
#import "ClubCategoryCollectionViewCell.h"
#import "ClubCategoryMoreCollectionViewCell.h"

@implementation ClubCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"ClubCategoryCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"Cell"];
    
    UINib *moreNib = [UINib nibWithNibName:@"ClubCategoryMoreCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:moreNib forCellWithReuseIdentifier:@"MoreCell"];
}

- (void)setCell:(NSArray *)brandTypes{
    
    if (brandTypes) {
        
        self.brandTypes = brandTypes;
        
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.brandTypes.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.brandTypes.count) {
        
        ClubCategoryMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreCell" forIndexPath:indexPath];
        return cell;
        
    } else {
        
        ClubCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        [cell setCell:self.brandTypes[indexPath.row]];
        return cell;
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.brandTypes.count) {
        
        return CGSizeMake(130.0f, 75.0f);
        
    } else {
        
        return CGSizeMake(55.0f, 75.0f);
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != self.brandTypes.count) {
        
        if ([self.delegate respondsToSelector:@selector(categoryCellTapped:)]) {
            [self.delegate categoryCellTapped:self.brandTypes[indexPath.row]];
        }
    }

}

@end
