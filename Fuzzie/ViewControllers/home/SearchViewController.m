//
//  SearchViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 24/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "SearchViewController.h"
#import "CategoryCollectionViewCell.h"

#import "BrandListViewController.h"
#import "PackageListViewController.h"
#import "CardViewController.h"
#import "PackageViewController.h"
#import "JackpotCardViewController.h"
#import "BrandJackpotViewController.h"

@interface SearchViewController () <UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *noResultsView;

@property (strong, nonatomic) NSArray *categoryArray;
@property (strong, nonatomic) NSArray *searchArray;

- (IBAction)cancelButtonPressed:(id)sender;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelButtonPressed:) name:SHOULD_DISMISS_VIEW object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOULD_DISMISS_VIEW object:nil];
}

#pragma mark - Button Actions

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *searchTerm = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (searchTerm.length > 0) {
        self.collectionView.hidden = YES;
        self.tableView.hidden = NO;
        
        // Not contain Fuzzie Brand
        NSPredicate *predicate1 =[NSPredicate predicateWithFormat:@"NOT (name LIKE[cd] %@)", @"Fuzzie"];
        NSArray *brandArray = [[FZData sharedInstance].brandArray filteredArrayUsingPredicate:predicate1];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR name LIKE[cd] %@", searchTerm, searchTerm];
        self.searchArray = [brandArray filteredArrayUsingPredicate:predicate];
        
        if (self.searchArray.count == 0) {
            self.tableView.tableFooterView = self.noResultsView;
        } else {
            self.tableView.tableFooterView = nil;
        }
        
        [self.tableView reloadData];
    } else {
        self.collectionView.hidden = NO;
        self.tableView.hidden = YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
    
    BrandListViewController *brandListView = [self.storyboard instantiateViewControllerWithIdentifier:@"BrandListView"];
    brandListView.headerTitle = categoryDict[@"name"];
    brandListView.brandArray = categoryDict[@"brands"];
    brandListView.showFilter = YES;
    brandListView.isCategory = YES;
    
    [self.navigationController pushViewController:brandListView animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FZBrand *brand = self.searchArray[indexPath.row];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BrandCell" forIndexPath:indexPath];
    
    cell.textLabel.text = brand.name;
    
    if ([FZData sharedInstance].subCategoryArray) {
        NSArray *subCategoryArray = [FZData sharedInstance].subCategoryArray;
        for (NSDictionary *categoryDict in subCategoryArray) {
            if (categoryDict[@"id"] && [categoryDict[@"id"] isEqual:brand.subcategoryId]) {
                
                cell.detailTextLabel.text = categoryDict[@"name"];
                
                NSString *imageName = [NSString stringWithFormat:@"sub-category-96-%@",[categoryDict[@"id"] stringValue]];
                cell.imageView.image = [UIImage imageNamed:imageName];
            }
        }
        
    } else {
        cell.detailTextLabel.text = @"";
        cell.imageView.image = nil;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchTextField resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= self.searchArray.count) return;
    
    FZBrand *brand = self.searchArray[indexPath.row];
    
    if (brand.giftCards && brand.giftCards.count > 0 && brand.services && brand.services.count > 0) {
        
        PackageListViewController *packageListView = [self.storyboard instantiateViewControllerWithIdentifier:@"PackageListView"];
        packageListView.brand = brand;
        packageListView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:packageListView animated:YES];
        
    } else if (brand.giftCards && brand.giftCards.count > 0) {

        [self performSegueWithIdentifier:@"pushToBrandCardGift" sender:brand];
        
    } else if (brand.services && brand.services.count == 1) {
        
        NSDictionary *packageDict = [brand.services firstObject];
        
        [self performSegueWithIdentifier:@"pushToPackage"
                                  sender:@{@"brand":brand,@"packageDict":packageDict}];
        
    } else if (brand.services && brand.services.count > 1) {
        
        PackageListViewController *packageListView = [self.storyboard instantiateViewControllerWithIdentifier:@"PackageListView"];
        packageListView.brand = brand;
        packageListView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:packageListView animated:YES];
        
    } else if ([brand.couponOnly boolValue]){
        
        if (brand.coupons.count > 0) {
            
            if (brand.coupons.count == 1) {

                FZCoupon *coupon = brand.coupons[0];
                JackpotCardViewController *cardView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotCardView"];
                cardView.coupon = coupon;
                cardView.brand = brand;
                cardView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cardView animated:YES];

            } else {

                BrandJackpotViewController *jackpotView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"BrandJackpotView"];
                jackpotView.couponsArray = brand.coupons;
                jackpotView.brand = brand;
                jackpotView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:jackpotView animated:YES];
            }
        }
    }
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    self.categoryArray = [FZData sharedInstance].categoryArray;
    
    self.searchContainerView.layer.cornerRadius = 5.0f;
    self.searchContainerView.layer.borderColor = [UIColor colorWithHexString:@"#B42F2F"].CGColor;
    self.searchContainerView.layer.borderWidth = 0.5f;
    self.searchContainerView.layer.masksToBounds = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCell"];
    self.tableView.tableFooterView = nil;
    
    if ([self.searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0f alpha:0.5f]}];
    }
    
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushToBrandCardGift"]) {
        if ([segue.destinationViewController isKindOfClass:[CardViewController class]]) {
            CardViewController *cardViewController = (CardViewController *)segue.destinationViewController;
            cardViewController.hidesBottomBarWhenPushed = YES;
            if (sender){
                if ([sender isKindOfClass:[FZBrand class]]) {
                    cardViewController.brand = (FZBrand *)sender;
                }
            }
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToPackage"]) {
        if ([segue.destinationViewController isKindOfClass:[PackageViewController class]]) {
            PackageViewController *packageViewController = (PackageViewController *)segue.destinationViewController;
            packageViewController.hidesBottomBarWhenPushed = YES;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    packageViewController.brand = [(NSDictionary *)sender objectForKey:@"brand"];
                    packageViewController.packageDict = [(NSDictionary *)sender objectForKey:@"packageDict"];
                }
            }
        }
    }
}


@end
