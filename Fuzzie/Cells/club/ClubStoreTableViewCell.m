//
//  ClubStoreTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreTableViewCell.h"
#import "ClubStoreCollectionViewCell.h"
#import "ClubFlashCollectionViewCell.h"

@implementation ClubStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"ClubStoreCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    
    UINib *flashCellNib = [UINib nibWithNibName:@"ClubFlashCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:flashCellNib forCellWithReuseIdentifier:@"FlashCell"];
}

- (void)setCellWithStores:(NSArray *)stores{
    
    if (stores) {
        
        self.stores = stores;
        self.flashMode = NO;
        
        [self.collectionView reloadData];
    }
}

- (void)setCellWithOffers:(NSArray *)offers{
    
    if (offers) {
        
        self.offers = offers;
        self.flashMode = YES;
        
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.flashMode) {
        
        return self.offers.count;
        
    } else {
        
        return self.stores.count;
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.flashMode) {
      
        ClubFlashCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlashCell" forIndexPath:indexPath];
        [cell setCell:self.offers[indexPath.row]];
        return cell;
        
    } else {
      
        ClubStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        [cell setCell:self.stores[indexPath.row]];
        return cell;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.flashMode) {
        
        return CGSizeMake(270.0f, 150.0f);
        
    } else {
        
        return CGSizeMake(210.0f, 190.0f);

    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(clubStoreCellTapped:flashMode:)]) {
        NSDictionary *dict;
        if (self.flashMode){
            dict = self.offers[indexPath.row];
        } else {
            dict = self.stores[indexPath.row];
        }
        [self.delegate clubStoreCellTapped:dict flashMode:self.flashMode];
    }
}

- (IBAction)viewAllButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(viewAllButtonPressed:title:flashMode:)]) {
        if (self.flashMode) {
            [self.delegate viewAllButtonPressed:self.offers title:self.lbType.text flashMode:self.flashMode];
        } else {
            [self.delegate viewAllButtonPressed:self.stores title:self.lbType.text flashMode:self.flashMode];
        }
    }
}
@end
