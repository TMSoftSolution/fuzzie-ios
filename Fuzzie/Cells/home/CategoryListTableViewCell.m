//
//  CategoryListTableViewCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "CategoryListTableViewCell.h"
#import "CategoryCollectionViewCell.h"

@interface CategoryListTableViewCell () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)viewAllButtonPressed:(id)sender;

@end

@implementation CategoryListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCategoryArray:(NSArray *)categoryArray {
    _categoryArray = categoryArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    NSDictionary *categoryDict = self.categoryArray[indexPath.row];

    
    if (!categoryDict[@"name"] || [categoryDict[@"name"] isEqualToString:@""]) {
        
        cell.titleLabel.text = @"";
        cell.gradientView.hidden = YES;
        
    } else{
    
        cell.titleLabel.text = [categoryDict[@"name"] uppercaseString];
        cell.gradientView.hidden = NO;
    }
    
    NSURL *imageURL = [NSURL URLWithString:categoryDict[@"picture"]];
    [cell.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"category-placeholder"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(140.0f, 140.0f);
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *categoryDict = self.categoryArray[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryWasClicked:)]) {
        [self.delegate categoryWasClicked:categoryDict];
    }
}

#pragma mark - Button Actions

- (IBAction)viewAllButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewAllCategoryWasClicked)]) {
        [self.delegate viewAllCategoryWasClicked];
    }
}

@end
