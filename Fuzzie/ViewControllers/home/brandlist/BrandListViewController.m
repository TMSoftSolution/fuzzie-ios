//
//  BrandListViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "BrandListViewController.h"
#import "BrandTableViewCell.h"

#import "PackageListViewController.h"
#import "JoinViewController.h"
#import "CardViewController.h"
#import "PackageViewController.h"
#import "BrandListSortViewController.h"
#import "BrandListRefineViewController.h"
#import "BrandListCategoryFilterViewController.h"
#import "BrandJackpotViewController.h"
#import "JackpotCardViewController.h"
#import "PowerUpPackCardViewController.h"

@interface BrandListViewController () <UITableViewDataSource,UITableViewDelegate,BrandTableViewCellDelegate, BrandListSortViewControllerDelegate, BrandListRefineViewControllerDelegate, BrandListCategoryFilterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *bagLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *powerUpView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerUpViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *powerUpTimerLabel;
@property (strong, nonatomic) NSTimer *powerUpTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterViewHeightAnchor;
@property (weak, nonatomic) IBOutlet UILabel *lbSortBy;
@property (weak, nonatomic) IBOutlet UILabel *lbRefine;
@property (weak, nonatomic) IBOutlet UILabel *lbCount;

@property (strong, nonatomic) NSSortDescriptor *sortDescriptor;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)bagButtonPressed:(id)sender;
- (IBAction)sortButtonPressed:(id)sender;
- (IBAction)refineButtonPressed:(id)sender;

@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setStyling];
}

- (void)initData{
    [FZData sharedInstance].selectedSortIndex = 0;
    [FZData sharedInstance].selectedCategoryIds = [[NSMutableSet alloc] init];
    [FZData sharedInstance].selectedRefineSubCategoryIds = [[NSMutableSet alloc] init];
    self.sortedBrandArray = self.brandArray;
    self.filteredBrandArray = self.brandArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateBagCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.powerUpTimer invalidate];
}

#pragma mark - Button Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bagButtonPressed:(id)sender {
    if ([UserController sharedInstance].currentUser) {

        UIViewController *shoppingBagView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"ShoppingBagView"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shoppingBagView];
        navigationController.navigationBarHidden = YES;
        [self presentViewController:navigationController animated:YES completion:nil];
        
    } else {

        JoinViewController *joinView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"JoinView"];
        joinView.showCloseButton = YES;
        UINavigationController *joinNavigation = [[UINavigationController alloc] initWithRootViewController:joinView];
        [self presentViewController:joinNavigation animated:YES completion:nil];
    }
}

- (void)sortButtonPressed:(id)sender{
    
    BrandListSortViewController *sortView = [[GlobalConstants brandFilterStoryboard] instantiateViewControllerWithIdentifier:@"BrandListSortView"];
    sortView.hidesBottomBarWhenPushed = YES;
    sortView.delegate = self;
    [self.navigationController pushViewController:sortView animated:YES];
    
}

- (void)refineButtonPressed:(id)sender{

    if (self.isCategory) {
        
        BrandListRefineViewController *refineView = [[GlobalConstants brandFilterStoryboard] instantiateViewControllerWithIdentifier:@"BrandListRefineView"];
        refineView.subCategories = [FZData getSubCategoriesWith:self.sortedBrandArray];
        refineView.delegate = self;
        refineView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:refineView animated:YES];
        
    } else{
        
        BrandListCategoryFilterViewController *categoryView = [[GlobalConstants brandFilterStoryboard] instantiateViewControllerWithIdentifier:@"BrandListCategoryFilterView"];
        categoryView.categoriesArray = [FZData getCategoriesWith:self.sortedBrandArray];
        categoryView.delegate = self;
        categoryView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:categoryView animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredBrandArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    FZBrand *brand = self.filteredBrandArray[indexPath.row];
    [cell setupWithBrand:brand];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240.0f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FZBrand *brand = self.filteredBrandArray[indexPath.row];
    
    if ([self.headerTitle isEqualToString:@"TOP BRANDS"] || [self.headerTitle isEqualToString:@"NEW BRANDS"]) {
        
        if (brand.brandLink) {
            
            if ([brand.brandLink[@"type"] isEqualToString:@"brand"]) {
                
                [self goNormalBrand:brand];
                
            } else if ([brand.brandLink[@"type"] isEqualToString:@"jackpot_coupon_list"]){
                
                if ([FZData sharedInstance].coupons && [FZData sharedInstance].coupons.count > 0) {
                    
                    NSArray *couponIds = brand.brandLink[@"jackpot_coupon_template_ids"];
                    if (couponIds && couponIds.count > 0) {
                        
                        NSMutableArray *coupons = [[NSMutableArray alloc] init];
                        for (NSString *couponId in couponIds) {
                            
                            FZCoupon *coupon = [FZData getCouponById:couponId];
                            if (coupon) {
                                [coupons addObject:coupon];
                            }
                        }
                        
                        if (coupons.count > 0) {
                            
                            BrandJackpotViewController *jackpotView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"BrandJackpotView"];
                            jackpotView.couponsArray = coupons;
                            if (brand.brandLink[@"title"] && [brand.brandLink[@"title"] isKindOfClass:[NSString class]]) {
                                jackpotView.titleString = brand.brandLink[@"title"];
                            }
                            jackpotView.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:jackpotView animated:YES];
                        }
                    }
                }
                
            } else if ([brand.brandLink[@"type"] isEqualToString:@"jackpot_coupon"]){
                
                if ([FZData sharedInstance].coupons && [FZData sharedInstance].coupons.count > 0) {
                    
                    NSString *couponId = brand.brandLink[@"jackpot_coupon_template_id"];
                    FZCoupon *coupon = [FZData getCouponById:couponId];
                    
                    if (coupon) {
                        
                        if (coupon.powerUpPack) {
                            
                            PowerUpPackCardViewController *cardView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"PowerUpPackCardView"];
                            cardView.coupon = coupon;
                            cardView.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:cardView animated:YES];
                            
                        } else {
                            
                            FZBrand *brand = [FZData getBrandById:coupon.brandId];
                            if (brand) {
                                
                                JackpotCardViewController *cardView = (JackpotCardViewController*)[[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotCardView"];
                                cardView.coupon = coupon;
                                cardView.brand = brand;
                                cardView.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:cardView animated:YES];
                            }
                        }
                    }
                }
            }
            
        } else {
            
            [self goNormalBrand:brand];
        }
        
    } else {
        
        [self goNormalBrand:brand];
    }
 
}

- (void)goNormalBrand:(FZBrand*)brand{
    
    if (brand.giftCards && brand.giftCards.count > 0 && brand.services && brand.services.count > 0) {
        
        PackageListViewController *packageListView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"PackageListView"];
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

        PackageListViewController *packageListView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"PackageListView"];
        packageListView.brand = brand;
        packageListView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:packageListView animated:YES];
        
    }
}

#pragma mark - BrandTableViewCellDelegate

- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state {
    [self likeBrand:brand withState:state];
}

#pragma mark - BrandListSortViewControllerDelegate
- (void)changeSortItem{
    [self updateSortBy];
}

#pragma mark - Sort By Update
- (void)updateSortBy{
    self.lbSortBy.text = [[FZData sharedInstance].brandListSortItemArray objectAtIndex:[FZData sharedInstance].selectedSortIndex];
    
    [self reloadTableWithSort];
}

- (void)reloadTableWithSort{
    switch ([FZData sharedInstance].selectedSortIndex) {
        case 0:
            self.sortDescriptor = nil;
            self.sortedBrandArray = self.brandArray;
            break;
            
        case 1:
        {
            self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"likersCount" ascending:NO];
            self.sortedBrandArray = [self.brandArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
            break;
            
        }
            
        case 2:
        {
            self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cashbackPercentage" ascending:NO];
            self.sortedBrandArray = [self.brandArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
            break;

        }
        case 3:
        {
            self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            self.sortedBrandArray = [self.brandArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
            
            break;
        }
        default:
            self.sortedBrandArray = self.brandArray;
            break;
    }
    
    if (self.isCategory) {
        [self reloadTableViewWithRefine];
    } else{
        [self reloadTableViewWithFilter];
    }
}


#pragma mark - Refine Update
- (void)updateRefine{
    if (self.isCategory) {
        if ([FZData sharedInstance].selectedRefineSubCategoryIds.count == 0) {
            self.lbRefine.text = @"All";
            self.lbCount.hidden = YES;
        } else{
            self.lbRefine.text = @"Subcategories";
            self.lbCount.hidden = NO;
            self.lbCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[FZData sharedInstance].selectedRefineSubCategoryIds.count];
        }
        
    } else{
        if ([FZData sharedInstance].selectedCategoryIds.count == 0) {
            self.lbRefine.text = @"Categories";
            self.lbCount.hidden = YES;
        } else{
            self.lbRefine.text = @"Categories";
            self.lbCount.hidden = NO;
            self.lbCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[FZData sharedInstance].selectedCategoryIds.count];
        }
    }
}

- (void)reloadTableViewWithRefine{
    if ([FZData sharedInstance].selectedRefineSubCategoryIds.count == 0) {
        self.filteredBrandArray = self.sortedBrandArray;
    } else{
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSNumber *subId in [FZData sharedInstance].selectedRefineSubCategoryIds) {
            for (FZBrand *brand in self.sortedBrandArray) {
                if ([subId isEqual:brand.subcategoryId]) {
                    [tempArray addObject:brand];
                }
            }
        }
        if (self.sortDescriptor) {
            self.filteredBrandArray = [tempArray sortedArrayUsingDescriptors:@[self.sortDescriptor]];
        } else{
            self.filteredBrandArray = tempArray;
        }
  
    }
    
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.tableView reloadData];
}

- (void)reloadTableViewWithFilter{
    if ([FZData sharedInstance].selectedCategoryIds.count == 0) {
        self.filteredBrandArray = self.sortedBrandArray;
    } else{
        NSMutableSet *temp = [[NSMutableSet alloc] init];
        for (NSNumber *categoryId in [FZData sharedInstance].selectedCategoryIds) {
            NSString *stringId = [categoryId stringValue];
            for (FZBrand *brand in self.sortedBrandArray) {
                if ([brand.categoryIds containsObject:stringId]) {
                    [temp addObject:brand];
                }
            }
        }
        
        if (self.sortDescriptor) {
            self.filteredBrandArray = [temp sortedArrayUsingDescriptors:@[self.sortDescriptor]];
        } else{
            self.filteredBrandArray = [temp allObjects];
        }
        
    }
    
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.tableView reloadData];
}

#pragma mark - BrandListRefineViewControllerDelegate
- (void)refineViewDoneButtonPressed{
    [self updateRefine];
    [self reloadTableWithSort];
}

#pragma mark - BrandListCategoryFilterViewControllerDelegate
- (void)filterViewDoneButtonPressed{
    [self updateRefine];
    [self reloadTableWithSort];
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    [CommonUtilities setView:self.lbCount withCornerRadius:8.0f];
    self.lbCount.hidden = YES;
    
    if (self.showFilter) {
        self.filterViewHeightAnchor.constant = 60.0f;
        [self updateSortBy];
        [self updateRefine];
    } else{
        self.filterViewHeightAnchor.constant = 0.0f;
    }
    
    if (self.headerTitle) {
        self.headerLabel.text = [self.headerTitle uppercaseString];
    } else{
        self.headerLabel.text = @"";
    }
    
    UINib *brandCellNib = [UINib nibWithNibName:@"BrandTableViewCell" bundle:nil];
    [self.tableView registerNib:brandCellNib forCellReuseIdentifier:@"BrandCell"];
    
    self.bagLabel.layer.cornerRadius = 10.0f;
    self.bagLabel.layer.masksToBounds = YES;
    self.bagLabel.layer.borderColor = [UIColor colorWithHexString:HEX_COLOR_RED].CGColor;
    self.bagLabel.layer.borderWidth = 3.5f;
    
    self.powerUpTimer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0f block:^(NSTimer *timer) {
        if ([UserController sharedInstance].currentUser && [UserController sharedInstance].currentUser.powerUpExpiryDate) {
            NSDate *expiryDate = [UserController sharedInstance].currentUser.powerUpExpiryDate;
            NSDate *now = [NSDate date];
            
            if ([expiryDate secondsFrom:now] > 0) {
                int hours = [expiryDate hoursFrom:now];
                int minutes = [expiryDate minutesFrom:now];
                minutes %= 60;
                int seconds = [expiryDate secondsFrom:now];
                seconds %= 60;
                self.powerUpTimerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
                self.powerUpViewHeightConstraint.constant = 40.0f;
                self.powerUpView.hidden = NO;
                [CommonUtilities setView:self.powerUpView withBackground:[UIColor colorWithHexString:@"#3B93DA"] withRadius:0.0f withBorderColor:[UIColor colorWithHexString:@"#2E72AA"] withBorderWidth:1.0f];
            } else {
                self.powerUpViewHeightConstraint.constant = 0.0f;
                self.powerUpView.hidden = YES;
            }
            
        } else {
            self.powerUpViewHeightConstraint.constant = 0.0f;
            self.powerUpView.hidden = YES;
        }
    } repeats:YES];
}

- (void)updateBagCount {
    NSDictionary *bagDict = [FZData sharedInstance].bagDict;
    if (bagDict) {
        NSArray *bagItems = bagDict[@"items"];
        if (bagItems.count > 0) {
            self.bagLabel.text = [NSString stringWithFormat:@"%d",(int)bagItems.count];
            self.bagLabel.hidden = NO;
        } else {
            self.bagLabel.hidden = YES;
        }
    } else {
        self.bagLabel.hidden = YES;
    }
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
