//
//  PackageViewController.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PackageViewController.h"
#import "Social/Social.h"
#define kItemWidth 80.0f
#define kSpacing 10.0f

#import "GiftCollectionViewCell.h"
#import "BrandListTableViewCell.h"
#import "CardViewController.h"

#import "PackageListViewController.h"
#import "CheckoutViewController.h"
#import "AppDelegate.h"
#import "MiniBannerCell.h"
#import "BrandSliderCell.h"
#import "BrandPackageTitleTableViewCell.h"
#import "ClubMemberExclusiveTableViewCell.h"
#import "AboutBrandTableViewCell.h"
#import "EarnTableViewCell.h"
#import "RedeemValidTableViewCell.h"
#import "MainActionBrandTableViewCell.h"
#import "WishlistBrandTableViewCell.h"
#import "TripAdvisorBrandTableViewCell.h"
#import "InfoBrandTableViewCell.h"
#import "HowToRedeemViewController.h"
#import "TermsAndConditionsTableViewController.h"
#import "FZWebView2Controller.h"
#import "PackageBrandDetailTableViewCell.h"
#import "UserLikeBrandListViewController.h"
#import "UserProfileViewController.h"
#import "StoreTableViewController.h"
#import "GiftItViewController.h"
#import "BrandValidOptionTableViewCell.h"
#import "BrandJackpotTableViewCell.h"
#import "BrandJackpotViewController.h"
#import "PowerUpPackViewController.h"

@interface PackageViewController () <UITableViewDelegate, UITableViewDataSource, BrandListTableViewCellDelegate, AboutBrandTableViewCellDelegate, EarnTableViewCellDelegate, InfoBrandTableViewCellDelegate, TripAdvisorBrandTableViewCellDelegate, MiniBannerSliderCellDelegate, MainActionBrandTableViewCellDelegate, WishlistBrandTableViewCellDelegate, MDHTMLLabelDelegate, BrandJackpotTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *bagLabel;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)bagButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int heightAboutBrand;
@end

typedef enum : NSUInteger {
    packageBrandSectionBanner,
    packageBrandSectionBrandPackageTitle,
    packageBrandSectionClubExclusive,
    packageBrandSectionMainAction,
    packageBrandSectionEarn,
    packageBrandSectionRedeemValid,
    packageBrandSectionValid,
    packageBrandSectionWishlist,
    packageBrandSectionJackpot,
    packageBrandSectionPackageDetail,
    packageBrandSectionBrandAboutBrand,
    packageBrandSectionTripAdvisor,
    packageBrandSectionMiniBanner,
    packageBrandSectionInfoConditions,
    packageBrandSectionInfoRedeem,
    packageBrandSectionStoreLocation,
    packageBrandSectionRecommended,
    packageBrandSectionCount
} packageBrandSection;


@implementation PackageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateBagCount];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == packageBrandSectionMiniBanner && [self.miniBannerArray count] == 0) {
        
        return 0;
        
    } else if (section == packageBrandSectionClubExclusive) {
        
        if ([self.brand.isClubOnly boolValue]) {
            
            return 1;
            
        } else{
            
            return 0;
        }
        
    } else if(section == packageBrandSectionTripAdvisor ) {
        
        if (self.brand.tripadvisorLink && ![self.brand.tripadvisorLink isEqualToString:@""] && self.brand.tripadvisorReviewCount && [self.brand.tripadvisorReviewCount intValue] > 0) {
            return 1;
        } else{
            return 0;
        }
        
    } else if (section == packageBrandSectionValid &&
        self.brand.textOptionGiftCard.count < 1) {
        return 0;
        
    } else if (section == packageBrandSectionJackpot &&
        !([FZData sharedInstance].enableJackpot && [self.brand.jackpotCouponsPresent boolValue])) {
        return 0;
        
    } else if (section == packageBrandSectionPackageDetail) {
        if (!(self.packageDict && self.packageDict[@"description"] && [self.packageDict[@"description"] isKindOfClass:[NSString class]] && ![self.packageDict[@"description"] isEqualToString:@""])) {
            return 0;
        }
        
    } else if (section == packageBrandSectionStoreLocation &&
        self.brand.stores.count < 1) {
        return 0;
        
    } else if (section == packageBrandSectionEarn && self.brand.percentage.floatValue <= 0){
        return 0;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return packageBrandSectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==  packageBrandSectionBanner) {
        
        BrandSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandSliderCell" forIndexPath:indexPath];
        [cell initSliderIfNeeded];
        [cell setBrandInfo:self.brand withMode:BrandSliderCellModePackage package:self.packageDict showSoldOut:true];
        return cell;
        
    } else if (indexPath.section == packageBrandSectionBrandPackageTitle) {
        
        BrandPackageTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandPackageTitleCell" forIndexPath:indexPath];
        [cell setBrandInfo:self.brand andPackageInfo:self.packageDict];
        return cell;
        
    } else if (indexPath.section == packageBrandSectionClubExclusive){
        
        ClubMemberExclusiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubExclusiveCell"];
        
        return cell;
        
    } else if (indexPath.section == packageBrandSectionEarn) {
        
        EarnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EarnCell" forIndexPath:indexPath];
        cell.delegate = self;
        
        if (self.brand.percentage.floatValue <= 0) {
            cell.contentView.hidden = YES;
        } else {
            cell.contentView.hidden = NO;
            
            if ([UserController sharedInstance].currentUser.powerUpExpiryDate || [self.brand.powerUp boolValue]) {
                
                if (self.packageDict && self.packageDict[@"price"] && self.packageDict[@"price"][@"value"]) {
                    
                    NSNumber *giftPrice = self.packageDict[@"price"][@"value"];
                    NSNumber *cashback = [NSNumber numberWithFloat:giftPrice.floatValue * self.brand.percentage.floatValue / 100];
                    [cell setCell:self.brand earnValue:cashback];
                    
                }
                
            } else {
                
                if (self.packageDict && self.packageDict[@"cash_back"] && self.packageDict[@"cash_back"][@"value"]) {
                    [cell setCell:self.brand earnValue:self.packageDict[@"cash_back"][@"value"]];
                }
            }

        }
        return cell;
        
    }  else if (indexPath.section == packageBrandSectionRedeemValid){
        
        RedeemValidTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RedeemValidCell"];
        NSString *redeemEndDate = self.packageDict[@"redemption_end_date"];
        [cell setCell:redeemEndDate];
        return cell;
        
    } else if (indexPath.section == packageBrandSectionMainAction) {
        
        MainActionBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainActionBrandCell" forIndexPath:indexPath];
        cell.delegate = self;
        if (self.packageDict && [self.packageDict[@"sold_out"] isEqual:@(YES)]) {
            [cell disabledButtonsWithAnimation:NO];
        }
        return cell;
        
    } else if (indexPath.section == packageBrandSectionValid){
        
        BrandValidOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValidCell"];
        cell.options = self.brand.textOptionGiftCard;
        return cell;
        
    } else if (indexPath.section == packageBrandSectionWishlist) {
        
        WishlistBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WishlistBrandCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell initCellWithBrand:self.brand];
        return cell;
        
    } else if (indexPath.section == packageBrandSectionJackpot){
        
        BrandJackpotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JackpotCell"];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section ==  packageBrandSectionPackageDetail) {
        
        PackageBrandDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackageBrandDetailCell" forIndexPath:indexPath];
        [cell setPackageBrandDetailText:self.packageDict[@"description"]];
        return cell;
        
    } else if (indexPath.section ==  packageBrandSectionBrandAboutBrand) {
        
        AboutBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = NO;
        cell.bottomSeparator.hidden = NO;
        cell.delegate = self;
        [cell setAboutBrandTextWithBrand:self.brand];
        return cell;
        
    } else if (indexPath.section == packageBrandSectionTripAdvisor) {
        TripAdvisorBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripAdvisorBrandCell" forIndexPath:indexPath];
        if(self.brand.tripadvisorLink) {
            [cell getTripAdvisorInfoWithBrandId:self.brand];
            cell.delegate = self;
        }
        return cell;
    } else if (indexPath.section == packageBrandSectionMiniBanner) {
        
        MiniBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MiniBannerCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell initSliderIfNeeded];
        [cell setBanner:self.miniBannerArray];
        return cell;
        
    } else if (indexPath.section ==  packageBrandSectionInfoConditions) {
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = NO;
        cell.typeCell = InfoBrandTypeCondition;
        cell.delegate = self;
        cell.infoBrandLabel.text = @"Terms and conditions";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-terms-condition"]];
        return cell;
        
    } else if (indexPath.section ==  packageBrandSectionInfoRedeem) {
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = YES;
        if (self.brand.stores && self.brand.stores.count > 0){
            cell.bottomSeparator.hidden = YES;
        } else{
            cell.bottomSeparator.hidden = NO;
        }
        cell.typeCell = InfoBrandTypeRedeem;
        cell.delegate = self;
        cell.infoBrandLabel.text = @"How to redeem";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-how-to-redeem"]];
        return cell;
        
    } else if (indexPath.section ==  packageBrandSectionStoreLocation) {
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = YES;
        cell.bottomSeparator.hidden = NO;
        cell.delegate = self;
        cell.typeCell = InfoBrandTypeStoreLocator;
        cell.infoBrandLabel.text = @"Store location & contact";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-store-location"]];
        return cell;
        
    } else if (indexPath.section == packageBrandSectionRecommended) {
        
        BrandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandListCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.viewAllButton.hidden = YES;
        [cell getOtherBrandsBy:self.brand.brandId];
        cell.delegate = self;
        cell.titleLabel.text = @"OTHERS ALSO BOUGHT";
        cell.type = BrandListTableViewCellTypeOtherAlsoBought;
        return cell;
        
    } else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   if (indexPath.section == packageBrandSectionValid) {
        return 70.0f;
        
    } else if (indexPath.section ==  packageBrandSectionWishlist) {
        return 130.0f;

    } else if (indexPath.section == packageBrandSectionJackpot) {
        return [UIScreen mainScreen].bounds.size.width * 220.0f / 320.0f ;
        
    } else if (indexPath.section ==  packageBrandSectionBrandAboutBrand) {
        return self.heightAboutBrand;
        
    } else if (indexPath.section ==  packageBrandSectionTripAdvisor) {
        return 60.0f;
        
    } else if (indexPath.section == packageBrandSectionMiniBanner) {
        return 80.0f;
        
    } else if (indexPath.section ==  packageBrandSectionInfoConditions ||
               indexPath.section ==  packageBrandSectionInfoRedeem ||
               indexPath.section ==  packageBrandSectionStoreLocation) {
        return 62.0f;
        
    } else if (indexPath.section ==  packageBrandSectionRecommended) {
        return 280.0f;
        
    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case  packageBrandSectionMiniBanner:
            if (self.miniBannerArray && self.miniBannerArray.count > 1) {
                return 10.0f;
            } else {
                return 0.0f;
            }
        case  packageBrandSectionRecommended:
            return 10.0f;
            break;
        case  packageBrandSectionJackpot:
            if ([FZData sharedInstance].enableJackpot && [self.brand.jackpotCouponsPresent boolValue]) {
                return 10.0f;
            } else{
                return 0.0f;
            }
        case  packageBrandSectionBrandAboutBrand:
        case  packageBrandSectionPackageDetail:
        case  packageBrandSectionInfoConditions:
            return 10.0f;
            break;
            
        default:
            return 0.0f;
            break;
    }
}

#pragma -mark WhishlistcellDelegate

- (void)buttonLikeTappedWithState:(BOOL)state {
    [self likeBrand:self.brand withState:state];
}


- (void)buttonWhishListTappedWithState:(BOOL)state {
    [self wishListBrand:self.brand withState:state];
}

- (void)avatarUserCellTapped:(NSArray *)userList {
    [self performSegueWithIdentifier:@"pushToUserLikeList" sender:@{@"userList":userList}];
}

- (void)avatarUserLikeTappedWith:(NSDictionary *)userInfo {
    [self performSegueWithIdentifier:@"pushToUserProfile" sender:@{@"userInfo":userInfo}];
}

- (void)buttonShareTapped {
    
    NSString *textToShare = @"";
    
    if (self.packageDict && self.brand.cashbackPercentage && self.brand.powerupPercentage) {
        
        
        if (!self.packageDict[@"name"] &&
            !self.packageDict[@"cash_back"] &&
            !self.packageDict[@"cash_back"][@"value"] &&
            !self.packageDict[@"cash_back"][@"power_up_percentage"] &&
            !self.packageDict[@"cash_back"][@"cash_back_percentage"] &&
            !self.packageDict[@"price"][@"value"] &&
            !self.packageDict[@"discounted_price"]) {
            return;
        }
        
        CGFloat originalPrice = [self.packageDict[@"price"][@"value"] floatValue];
        CGFloat discountedPrice = [self.packageDict[@"discounted_price"] floatValue];
        NSNumber *cashbackPercent = self.packageDict[@"cash_back"][@"cash_back_percentage"];
        NSNumber *powerupPercent = self.packageDict[@"cash_back"][@"power_up_percentage"];
        
        
        if (originalPrice > discountedPrice) {
            textToShare = [NSString stringWithFormat:@"%@ %@ $%.0f (Usual $%.0f)",
                           self.brand.name,
                           self.packageDict[@"name"],
                           discountedPrice, originalPrice];
        } else {
            textToShare = [NSString stringWithFormat:@"%@ %@",
                           self.brand.name,
                           self.packageDict[@"name"]];
        }
        
        
        if (cashbackPercent.floatValue + powerupPercent.floatValue > 0) {
            
            textToShare = [NSString stringWithFormat:@"%@ + %@%% INSTANT Cashback",
                           textToShare,
                           self.packageDict[@"cash_back"][@"value"]];
            
            if (powerupPercent.floatValue > 0) {
                textToShare = [NSString stringWithFormat:@"%@ + %.0f%% bonus Cashback", textToShare, powerupPercent.floatValue];
            }
            
            textToShare = [NSString stringWithFormat:@"%@ Get it on FUZZIE now: http://fuzzie.com.sg/", textToShare];
        }
        
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.brand.backgroundImage]]];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *items = @[textToShare,responseObject];
            
            // build an activity view controller
            UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
            
            // exclude several items
            NSArray *excluded = @[];
            controller.excludedActivityTypes = excluded;
            
            [self presentViewController:controller animated:YES completion:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
        
    }
}



#pragma mark - BrandListTableViewCellDelegate

- (void)brandWasClicked:(FZBrand *)brand type:(BrandListTableViewCellType)type{
    
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

- (void)wishlistButtonTappedOn:(NSString *)brandId isInWishList:(BOOL)state {
    //[self updateWishListState:state onBrandId:brandId];
}

#pragma mark - Button Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bagButtonPressed:(id)sender {
    
    UIViewController *shoppingBagView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"ShoppingBagView"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shoppingBagView];
    navigationController.navigationBarHidden = YES;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *BrandSliderCellNib = [UINib nibWithNibName:@"BrandSliderCell" bundle:nil];
    [self.tableView registerNib:BrandSliderCellNib forCellReuseIdentifier:@"BrandSliderCell"];
    
    UINib *BrandPackageTitleTableViewCellNib = [UINib nibWithNibName:@"BrandPackageTitleTableViewCell" bundle:nil];
    [self.tableView registerNib:BrandPackageTitleTableViewCellNib forCellReuseIdentifier:@"BrandPackageTitleCell"];
    
    UINib *clubExclusiveNib = [UINib nibWithNibName:@"ClubMemberExclusiveTableViewCell" bundle:nil];
    [self.tableView registerNib:clubExclusiveNib forCellReuseIdentifier:@"ClubExclusiveCell"];
    
    UINib *AboutbrandCellNib = [UINib nibWithNibName:@"AboutBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:AboutbrandCellNib forCellReuseIdentifier:@"AboutBrandCell"];
    self.heightAboutBrand =  150;
    
    UINib *TripAdvisorBrandNib = [UINib nibWithNibName:@"TripAdvisorBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:TripAdvisorBrandNib forCellReuseIdentifier:@"TripAdvisorBrandCell"];
    
    UINib *InfoBrandTableViewCellNib = [UINib nibWithNibName:@"InfoBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:InfoBrandTableViewCellNib forCellReuseIdentifier:@"InfoBrandCell"];
    
    UINib *EarnTableViewCelNib = [UINib nibWithNibName:@"EarnTableViewCell" bundle:nil];
    [self.tableView registerNib:EarnTableViewCelNib forCellReuseIdentifier:@"EarnCell"];
    
    UINib *redeemValidCellNib = [UINib nibWithNibName:@"RedeemValidTableViewCell" bundle:nil];
    [self.tableView registerNib:redeemValidCellNib forCellReuseIdentifier:@"RedeemValidCell"];
    
    UINib *validCellNib = [UINib nibWithNibName:@"BrandValidOptionTableViewCell" bundle:nil];
    [self.tableView registerNib:validCellNib forCellReuseIdentifier:@"ValidCell"];
    
    UINib *MainActionBrandNib = [UINib nibWithNibName:@"MainActionBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:MainActionBrandNib forCellReuseIdentifier:@"MainActionBrandCell"];
    
    UINib *jackpotCellNib = [UINib nibWithNibName:@"BrandJackpotTableViewCell" bundle:nil];
    [self.tableView registerNib:jackpotCellNib forCellReuseIdentifier:@"JackpotCell"];
    
    UINib *WishlistBrandNib = [UINib nibWithNibName:@"WishlistBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:WishlistBrandNib forCellReuseIdentifier:@"WishlistBrandCell"];
    
    UINib *PackageBrandDetailTableViewCellNib = [UINib nibWithNibName:@"PackageBrandDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:PackageBrandDetailTableViewCellNib forCellReuseIdentifier:@"PackageBrandDetailCell"];
    
    UINib *BrandListCellNib = [UINib nibWithNibName:@"BrandListTableViewCell" bundle:nil];
    [self.tableView registerNib:BrandListCellNib forCellReuseIdentifier:@"BrandListCell"];
    
    UINib *MiniBannerCellNib = [UINib nibWithNibName:@"MiniBannerCell" bundle:nil];
    [self.tableView registerNib:MiniBannerCellNib forCellReuseIdentifier:@"MiniBannerCell"];
    
    self.bagLabel.layer.cornerRadius = 10.0f;
    self.bagLabel.layer.masksToBounds = YES;
    self.bagLabel.layer.borderColor = [UIColor colorWithHexString:HEX_COLOR_RED].CGColor;
    self.bagLabel.layer.borderWidth = 3.5f;

    if (self.brand && self.packageDict) {
        self.headerLabel.text = [self.brand.name uppercaseString];
    }
    
    if ([[UserController sharedInstance].currentUser.displayGiftingPage boolValue]) {
        [self showGiftingAvailableView];
    }
    
    if ([self.brand.jackpotCouponsPresent boolValue]) {
        [self loadCouponsArray];
    }
}

- (void)loadCouponsArray{
  
    [JackpotController getCouponTemplateWithBrandId:self.brand.brandId andCompletion:^(NSDictionary *dictionary, NSError *error) {
        if (error && error.code == 417) {
            [AppDelegate logOut];
        }
        
        if (dictionary) {
            
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (NSDictionary *couponDict in dictionary[@"coupons"]) {
                NSError *error = nil;
                FZCoupon *coupon = [MTLJSONAdapter modelOfClass:FZCoupon.class fromJSONDictionary:couponDict error:&error];
                if (error) {
                    DDLogError(@"FZCoupon Error: %@", [error localizedDescription]);
                } else if (coupon) {
                    FZBrand *brand = [FZData getBrandById:coupon.brandId];
                    if (brand) {
                        coupon.brandName = brand.name;
                        coupon.subcategoryId = brand.subcategoryId;
                    }
                    
                    double pricePerTicket = ([coupon.priceValue doubleValue] - [coupon.cashbackValue doubleValue]) / [coupon.ticketCount intValue];
                    coupon.pricePerTicket = [NSNumber numberWithDouble:pricePerTicket];
                    
                    [temp addObject:coupon];
                }
            }
            
            self.couponsArray = temp;
        }
    }];
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

- (BOOL)floatHasDecimals:(CGFloat) f {
    return (f-(int)f != 0);
}

#pragma -mark AboutBrandTableViewCellDelegate 

- (void)aboutBrandCell:(UITableViewCell *)aboutBrandCell tappedWithHeightCell:(int)heightCell {
    NSLog(@"%i",heightCell);
    AboutBrandTableViewCell *aboutBrandCellCast = (AboutBrandTableViewCell *)aboutBrandCell;
    self.heightAboutBrand = heightCell;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [aboutBrandCellCast expandCellContent];
}

- (void)buttonSocialTapped:(NSInteger)buttonSocialType {
    
    NSString *urlString = nil;
    NSString *title = nil;
    if (buttonSocialType == AboutBrandButtonTypeFacebook) {
        urlString = self.brand.facebook;
        title = @"FACEBOOK";
    }
    
    if (buttonSocialType == AboutBrandButtonTypeTwitter) {
        urlString = self.brand.twitter;
        title = @"TWITTER";
    }
    
    if (buttonSocialType == AboutBrandButtonTypeInstagram) {
        urlString = self.brand.instagram;
        title = @"INSTAGRAM";
    }
    
    if (buttonSocialType == AboutBrandButtonTypeWebsite) {
        urlString = self.brand.website;
        title = self.brand.name;
    }
    
    if (urlString) {
        [self performSegueWithIdentifier:@"pushToWebview" sender:@{@"url":urlString,@"title":title}];
    }
    
}

#pragma -mark InfoBrandTableViewCellDelegate
- (void)cellInfoTapped:(NSUInteger)typeInfoCell {
    
    if (typeInfoCell == InfoBrandTypeCondition) {
        [self performSegueWithIdentifier:@"pushToTermConditions" sender:nil];

    }
    
    if (typeInfoCell == InfoBrandTypeRedeem) {
        [self performSegueWithIdentifier:@"pushToRedeem" sender:nil];
    }
    
    if (typeInfoCell == InfoBrandTypeStoreLocator) {
        StoreTableViewController *storeView = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreView"];
        storeView.brand = self.brand;
        [self.navigationController pushViewController:storeView animated:YES];
    }
    
    return;
}

#pragma -mark MainActionBrandTableViewCellDelegate 
- (void)buyItTapped {
    
    if ([self.packageDict[@"sold_out"] isEqual:@(NO)]) {
        
        if ([self.brand.isClubOnly boolValue]) {
            
            if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
                
                [self goCheckoutPage];
                
            } else {
                
                [self showClubExclusiveView];
                
            }
            
        } else {
            
            [self goCheckoutPage];
            
        }
    }
}

- (void)goCheckoutPage{
    
    CheckoutViewController *checkoutView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"CheckoutView"];
    checkoutView.brand = self.brand;
    checkoutView.giftDict = self.packageDict;
    
    [self.navigationController pushViewController:checkoutView animated:YES];
    
}

- (void)giftItTapped{
    
    if ([self.packageDict[@"sold_out"] isEqual:@(NO)]) {
        
        if ([self.brand.isClubOnly boolValue]) {
            
            if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
                
                [self goGiftItPage];
                
            } else {
                
                [self showClubExclusiveView];
                
            }
            
        } else {
            
            [self goGiftItPage];
            
        }
    }
}

- (void)goGiftItPage{
    
    GiftItViewController *giftItView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftItView"];
    giftItView.brand = self.brand;
    giftItView.giftDict = self.packageDict;
    
    [self.navigationController pushViewController:giftItView animated:YES];
}

#pragma - mark EarnTableViewCellDelegate
- (void)linkTapped {
    [self performSegueWithIdentifier:@"pushToCashback" sender:nil];
}

- (void)powerUpBannerClicked{

    PowerUpPackViewController *powerupPackView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"PowerUpPackView"];
    powerupPackView.coupons = [FZData getPowerUpPacks];
    [self.navigationController pushViewController:powerupPackView animated:YES];
}

#pragma - mark TripAdvisorBrandTableViewCellDelegate

- (void)goToTripAdvisorPageWith:(NSString *)URL {
    [self performSegueWithIdentifier:@"pushToWebview" sender:@{@"url":URL,@"title":@"TRIPADVISOR"}];
}

#pragma mark - BrandJackpotTableViewCellDelegate
- (void)jackpotCellTapped{
    
    if (self.brand && self.couponsArray) {

        BrandJackpotViewController *jackpotView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"BrandJackpotView"];
        jackpotView.brand = self.brand;
        jackpotView.couponsArray = self.couponsArray;
        [self.navigationController pushViewController:jackpotView animated:YES];
    }
 
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat heightSlider = screenWidth * 0.75f - 64;
    
    
    int realPosition = scrollView.contentOffset.y+20;
    if (realPosition >= heightSlider) {
        float ratio = realPosition-heightSlider;
        double coef = MIN(1,ratio/32);
        self.backgroundNav.alpha = (float)coef;
    } else {
        self.backgroundNav.alpha = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y < 0) {
        [self disableScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self enableScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y < 0) {
        [self disableScroll];
    }
}

- (void)enableScroll {
    self.tableView.scrollEnabled = YES;
}

- (void)disableScroll {
    self.tableView.scrollEnabled = YES;
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - ClubExclusiveViewDelegate
- (void)clubExclusiveViewExploreButtonPressed{
    
    [super clubExclusiveViewExploreButtonPressed];
    
    UIViewController *viewController = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubSubscribeView"];
    [self.navigationController pushViewController:viewController animated:YES];
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
    
    if ([segue.identifier isEqualToString:@"pushToWebview"]) {
        if ([segue.destinationViewController isKindOfClass:[FZWebView2Controller class]]) {
            FZWebView2Controller *webView2Controller = (FZWebView2Controller *)segue.destinationViewController;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    if ([sender[@"url"] isKindOfClass:[NSString class]]) {
                        webView2Controller.URL = ((NSString *)(NSDictionary *)sender[@"url"]);
                    }
                    if ([sender[@"title"] isKindOfClass:[NSString class]]) {
                        webView2Controller.titleHeader = ((NSString *)(NSDictionary *)sender[@"title"]);
                    }
                }
            }
        }
    }
        
    if ([segue.identifier isEqualToString:@"pushToRedeem"]) {
        if ([segue.destinationViewController isKindOfClass:[HowToRedeemViewController class]]) {
            HowToRedeemViewController *howToRedeemViewController = (HowToRedeemViewController *)segue.destinationViewController;
             howToRedeemViewController.brand = self.brand;
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToTermConditions"]) {
        if ([segue.destinationViewController isKindOfClass:[TermsAndConditionsTableViewController class]]) {
            TermsAndConditionsTableViewController *termsViewController = (TermsAndConditionsTableViewController *)segue.destinationViewController;
            
            if (self.packageDict[@"terms_and_conditions_text"] && [self.packageDict[@"terms_and_conditions_text"] isKindOfClass:[NSArray class]]) {
                termsViewController.termsConditions = self.packageDict[@"terms_and_conditions_text"];
            }
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToUserLikeList"]) {
        if ([segue.destinationViewController isKindOfClass:[UserLikeBrandListViewController class]]) {
            UserLikeBrandListViewController *friendLikeBrandListViewController = (UserLikeBrandListViewController *)segue.destinationViewController;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    if ([sender[@"userList"] isKindOfClass:[NSArray class]]) {
                        friendLikeBrandListViewController.usersLike = ((NSArray *)(NSDictionary *)sender[@"userList"]);
                    }
                }
            }
            
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToUserProfile"]) {
        if ([segue.destinationViewController isKindOfClass:[UserProfileViewController class]]) {
            UserProfileViewController *userProfileViewController = (UserProfileViewController *)segue.destinationViewController;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    if ([sender[@"userInfo"] isKindOfClass:[FZUser class]]) {
                        userProfileViewController.userInfo = ((FZUser *)(NSDictionary *)sender[@"userInfo"]);
                    }
                }
            }
            
        }
    }
}


@end
