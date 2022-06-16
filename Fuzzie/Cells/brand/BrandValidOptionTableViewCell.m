//
//  BrandValidOptionTableViewCell.m
//  Fuzzie
//
//  Created by mac on 9/12/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandValidOptionTableViewCell.h"
#import "BrandValidOptionCollectionViewCell.h"

@implementation BrandValidOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"BrandValidOptionCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.options.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandValidOptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.lbOption.text = [self.options objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *option = [self.options objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:FONT_NAME_LATO_BOLD size:10.0f];
    NSDictionary *fontAttributes = @{NSFontAttributeName:font};
    CGFloat width = [option sizeWithAttributes:fontAttributes].width + 45;
    
    return CGSizeMake(width, 30.0f);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(0, 15, 0, 15);
}

@end
