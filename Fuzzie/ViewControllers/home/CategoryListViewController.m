//
//  CategoryListViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 24/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "CategoryListViewController.h"
#import "CategoryCollectionViewCell.h"

#import "BrandListViewController.h"

@interface CategoryListViewController ()

@property (strong, nonatomic) NSArray *categoryArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation CategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    NSDictionary *categoryDict = self.categoryArray[indexPath.row];
    
    cell.titleLabel.text = [categoryDict[@"name"] uppercaseString];
    
    NSURL *imageURL = [NSURL URLWithString:categoryDict[@"picture"]];
    [cell.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"category-placeholder"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellWidth = (collectionView.frame.size.width - 15.0f - 15.0f - 10.0f) / 2.0f;
    
    return CGSizeMake(cellWidth, cellWidth);
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *categoryDict = self.categoryArray[indexPath.row];
    
    BrandListViewController *brandListView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"BrandListView"];
    brandListView.headerTitle = categoryDict[@"name"];
    brandListView.brandArray = categoryDict[@"brands"];
    brandListView.showFilter = YES;
    brandListView.isCategory = YES;
    
    [self.navigationController pushViewController:brandListView animated:YES];
    
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCell"];
    
    self.categoryArray = [FZData sharedInstance].categoryArray;
    [self.collectionView reloadData];
}

@end
