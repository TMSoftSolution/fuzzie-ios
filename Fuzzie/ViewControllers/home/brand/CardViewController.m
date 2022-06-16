//
//  CardViewController.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "CardViewController.h"
#import "Social/Social.h"
#define kItemWidth 80.0f
#define kSpacing 10.0f

#import "GiftCollectionViewCell.h"
#import "BrandListTableViewCell.h"

#import "PackageListViewController.h"
#import "CheckoutViewController.h"
#import "AppDelegate.h"
#import "MiniBannerCell.h"
#import "BrandSliderCell.h"
#import "BrandCardTitleCell.h"
#import "ClubMemberExclusiveTableViewCell.h"
#import "AboutBrandTableViewCell.h"
#import "PricesCardTableViewCell.h"
#import "EarnTableViewCell.h"
#import "RedeemValidTableViewCell.h"
#import "MainActionBrandTableViewCell.h"
#import "WishlistBrandTableViewCell.h"
#import "TripAdvisorBrandTableViewCell.h"
#import "InfoBrandTableViewCell.h"
#import "HowToRedeemViewController.h"
#import "TermsAndConditionsTableViewController.h"
#import "FZWebView2Controller.h"
#import "PackageViewController.h"
#import "UserLikeBrandListViewController.h"
#import "UserProfileViewController.h"
#import "StoreTableViewController.h"
#import "GiftItViewController.h"
#import "BrandValidOptionTableViewCell.h"
#import "BrandJackpotTableViewCell.h"
#import "BrandJackpotViewController.h"
#import "PowerUpPackViewController.h"

@interface CardViewController () <UITableViewDelegate, UITableViewDataSource, BrandListTableViewCellDelegate, AboutBrandTableViewCellDelegate, PricesCardTableViewCellDelegate, EarnTableViewCellDelegate, InfoBrandTableViewCellDelegate, TripAdvisorBrandTableViewCellDelegate, MiniBannerSliderCellDelegate, MainActionBrandTableViewCellDelegate, WishlistBrandTableViewCellDelegate, MDHTMLLabelDelegate, BrandJackpotTableViewCellDelegate>
@property (strong, nonatomic) NSArray *giftArray;
@property (assign, nonatomic) NSInteger activeIndex;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *bagLabel;

@property (assign, nonatomic) BOOL currentGiftCardSoldOut;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)bagButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int heightAboutBrand;

@end

typedef enum : NSUInteger {
    kBrandSectionBanner,
    kBrandSectionBrandCardTitle,
    kBrandSectionClubExclusive,
    kBrandSectionBrandPricesCard,
    kBrandSectionMainAction,
    kBrandSectionEarn,
    kBrandSectionRedeemValid,
    kBrandSectionValid,
    kBrandSectionWishlist,
    kBrandSectionJackpot,
    kBrandSectionBrandAboutBrand,
    kBrandSectionTripAdvisor,
    kBrandSectionMiniBanner,
    kBrandSectionInfoConditions,
    kBrandSectionInfoRedeem,
    kBrandSectionStoreLocation,
    kBrandSectionRecommended,
    kBrandSectioncount
} kBrandSection;


@implementation CardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.activeIndex = -1;
    [self setStyling];
    [self saveBrandView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateBagCount];
}

- (void)saveBrandView{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY]) {
        [BrandController saveBrandView:self.brand.brandId];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == kBrandSectionMiniBanner && [self.miniBannerArray count] == 0) {
        
        return 0;
        
    } else if (section == kBrandSectionClubExclusive) {
        
        if ([self.brand.isClubOnly boolValue]) {
            
            return 1;
            
        } else{
            
            return 0;
        }
        
    } else if(section == kBrandSectionTripAdvisor) {
      
        if (self.brand.tripadvisorLink && ![self.brand.tripadvisorLink isEqualToString:@""] && self.brand.tripadvisorReviewCount && [self.brand.tripadvisorReviewCount intValue] > 0) {
            return 1;
        } else{
            return 0;
        }
        
    } else if (section == kBrandSectionValid &&
        self.brand.textOptionGiftCard.count < 1) {
        return 0;
        
    } else if (section == kBrandSectionJackpot &&
        !([FZData sharedInstance].enableJackpot && [self.brand.jackpotCouponsPresent boolValue])) {
        return 0;
        
    } else if (section == kBrandSectionStoreLocation &&
        self.brand.stores.count < 1) {
        return 0;
    
    } else if (section == kBrandSectionEarn && self.brand.percentage.floatValue <= 0){
        return 0;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kBrandSectioncount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == kBrandSectionBanner) {
        
        BrandSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandSliderCell" forIndexPath:indexPath];
        [cell setBrandInfo:self.brand withMode:BrandSliderCellModeGiftCard showSoldOut:true];
        [cell initSliderIfNeeded];
        return cell;
        
    } else if (indexPath.section == kBrandSectionBrandCardTitle) {
        
        BrandCardTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandCardTitleCell" forIndexPath:indexPath];
        [cell setBrandInfo:self.brand];
        return cell;
        
    }  else if (indexPath.section == kBrandSectionClubExclusive){
        
        ClubMemberExclusiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubExclusiveCell"];
        
        return cell;
        
    } else if (indexPath.section == kBrandSectionBrandPricesCard) {
        
        PricesCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PricesCardCell" forIndexPath:indexPath];
        cell.delegate = self;
        if (self.activeIndex != -1) {
            cell.alreadySelected = true;
        }
        [cell setPriceCard:self.brand.giftCards];
        return cell;
        
    } else if (indexPath.section == kBrandSectionEarn) {
        
        EarnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EarnCell" forIndexPath:indexPath];
        cell.delegate = self;
        
        if (self.brand.percentage.floatValue <= 0) {
            cell.contentView.hidden = YES;
        } else{
            cell.contentView.hidden = NO;
            if (![cell isSettedOnceTime]){
                if(self.brand.giftCards) {
                    if ([self.brand.giftCards count]) {
                        NSInteger scrollIndex = 0;
                        if (self.brand.giftCards.count == 2) {
                            scrollIndex = 1;
                        } else if (self.brand.giftCards.count == 3) {
                            scrollIndex = 1;
                        } else if (self.brand.giftCards.count > 3) {
                            scrollIndex = 2;
                        }
                        
                        if ([UserController sharedInstance].currentUser.powerUpExpiryDate || [self.brand.powerUp boolValue]) {
                            
                            NSNumber *giftPrice = self.brand.giftCards[scrollIndex][@"price"][@"value"];
                            NSNumber *cashback = [NSNumber numberWithFloat:giftPrice.floatValue * self.brand.percentage.floatValue / 100];
                            [cell setCell:self.brand earnValue:cashback];
                            
                        } else {
                            [cell setCell:self.brand earnValue:self.brand.giftCards[scrollIndex][@"cash_back"][@"value"]];
                        }

                    }
                }
            }
        }
        return cell;
        
    } else if (indexPath.section == kBrandSectionRedeemValid){
        
        RedeemValidTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RedeemValidCell"];
        NSString *redeemEndDate = self.brand.giftCards[self.activeIndex][@"redemption_end_date"];
        [cell setCell:redeemEndDate];
        return cell;
        
    } else if(indexPath.section == kBrandSectionValid){
        
        BrandValidOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValidCell"];
        cell.options = self.brand.textOptionGiftCard;
        return cell;
        
    } else if (indexPath.section == kBrandSectionMainAction) {
        
        MainActionBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainActionBrandCell" forIndexPath:indexPath];
        cell.delegate = self;
        if (self.currentGiftCardSoldOut) {
            [cell disabledButtonsWithAnimation:false];
        } else {
            [cell enabledButtonsWithAnimation:false];
        }
        return cell;
        
    } else if (indexPath.section == kBrandSectionWishlist) {
        
        WishlistBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WishlistBrandCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell initCellWithBrand:self.brand];
        return cell;
        
    } else if (indexPath.section == kBrandSectionBrandAboutBrand) {
        
        AboutBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = NO;
        cell.bottomSeparator.hidden = NO;
        cell.delegate = self;
        [cell setAboutBrandTextWithBrand:self.brand];
        return cell;
        
    } else if (indexPath.section == kBrandSectionJackpot){
        BrandJackpotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JackpotCell"];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == kBrandSectionTripAdvisor) {
        TripAdvisorBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripAdvisorBrandCell" forIndexPath:indexPath];
        if(self.brand.tripadvisorLink) {
            [cell getTripAdvisorInfoWithBrandId:self.brand];
            cell.delegate = self;
        }
        return cell;
    } else if (indexPath.section == kBrandSectionMiniBanner) {
        
        MiniBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MiniBannerCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell initSliderIfNeeded];
        [cell setBanner:self.miniBannerArray];
        return cell;
        
    } else if (indexPath.section == kBrandSectionInfoConditions) {
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = NO;
        cell.typeCell = InfoBrandTypeCondition;
        cell.delegate = self;
        cell.infoBrandLabel.text = @"Terms and conditions";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-terms-condition"]];
        return cell;
        
    } else if (indexPath.section == kBrandSectionInfoRedeem) {
        
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
        
    } else if (indexPath.section == kBrandSectionStoreLocation) {
        
        InfoBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBrandCell" forIndexPath:indexPath];
        cell.topSeparator.hidden = YES;
        cell.bottomSeparator.hidden = NO;
        cell.delegate = self;
        cell.typeCell = InfoBrandTypeStoreLocator;
        cell.infoBrandLabel.text = @"Store location & contact";
        [cell.ivIcon setImage:[UIImage imageNamed:@"icon-store-location"]];
        return cell;
        
    } else if (indexPath.section == kBrandSectionRecommended) {
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

    if (indexPath.section == kBrandSectionBrandPricesCard) {
        return 68.0f;
        
    } else if (indexPath.section == kBrandSectionValid) {
        return 70.0f;
        
    } else if (indexPath.section == kBrandSectionWishlist) {
        return 130.0f;
        
    } else if (indexPath.section == kBrandSectionJackpot) {
        return [UIScreen mainScreen].bounds.size.width * 220.0f / 320.0f ;
        
    } else if (indexPath.section == kBrandSectionBrandAboutBrand) {
        return self.heightAboutBrand;
        
    } else if (indexPath.section == kBrandSectionTripAdvisor) {
        return 60.0f;
        
    } else if (indexPath.section == kBrandSectionMiniBanner) {
        return 80.0f;
        
    } else if (indexPath.section == kBrandSectionInfoConditions ||
               indexPath.section == kBrandSectionInfoRedeem ||
               indexPath.section == kBrandSectionStoreLocation) {
        return 62.0f;
        
    } else if (indexPath.section == kBrandSectionRecommended) {
        return 280.0f;
    }

    return UITableViewAutomaticDimension;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case  kBrandSectionMiniBanner:
            if (self.miniBannerArray && self.miniBannerArray.count > 1) {
                return 10.0f;
            } else {
                return 0.0f;
            }
        case kBrandSectionRecommended:
            return 10.0f;
            break;
        case kBrandSectionJackpot:
            if ([FZData sharedInstance].enableJackpot && [self.brand.jackpotCouponsPresent boolValue]) {
                return 10.0f;
            } else{
                return 0.0f;
            }
        case kBrandSectionBrandAboutBrand:
        case kBrandSectionInfoConditions:
            return 10.0f;
            break;
            
        default:
            return 0.0f;
            break;
    }
}

#pragma -mark WhishlistcellDelegate

- (void)buttonWhishListTappedWithState:(BOOL)state {
    [self wishListBrand:self.brand withState:state];
}


- (void)buttonLikeTappedWithState:(BOOL)state {
    [self likeBrand:self.brand withState:state];
}

- (void)buttonShareTapped {
    
    
    NSString *textToShare = @"";
    
    if (self.brand.cashbackPercentage && self.brand.powerupPercentage) {
        
        NSNumber *cashbackPercent = self.brand.cashbackPercentage;
        NSNumber *powerupPercent = self.brand.powerupPercentage;
        
        
        if (cashbackPercent.floatValue + powerupPercent.floatValue > 0) {
            
            textToShare = [NSString stringWithFormat:@"%@ gift card + %@%% INSTANT Cashback", self.brand.name, self.brand.cashbackPercentage];
            
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



- (void)avatarUserLikeTappedWith:(NSDictionary *)userInfo {
    [self performSegueWithIdentifier:@"pushToUserProfile" sender:@{@"userInfo":userInfo}];
}

- (void)avatarUserCellTapped:(NSArray *)userList {
    [self performSegueWithIdentifier:@"pushToUserLikeList" sender:@{@"userList":userList}];
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

- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state {
    [self likeBrand:brand withState:state];
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

- (IBAction)cashbackButtonPressed:(id)sender {

    UIViewController *cashbackView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"CashbackView"];
    [self presentViewController:cashbackView animated:YES completion:nil];
}


#pragma mark - Helper Functions

- (void)setStyling {
 
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    

    UINib *BrandSliderCellNib = [UINib nibWithNibName:@"BrandSliderCell" bundle:nil];
    [self.tableView registerNib:BrandSliderCellNib forCellReuseIdentifier:@"BrandSliderCell"];
    
    UINib *BrandCardTitleCellNib = [UINib nibWithNibName:@"BrandCardTitleCell" bundle:nil];
    [self.tableView registerNib:BrandCardTitleCellNib forCellReuseIdentifier:@"BrandCardTitleCell"];
    
    UINib *clubExclusiveNib = [UINib nibWithNibName:@"ClubMemberExclusiveTableViewCell" bundle:nil];
    [self.tableView registerNib:clubExclusiveNib forCellReuseIdentifier:@"ClubExclusiveCell"];
    
    UINib *jackpotCellNib = [UINib nibWithNibName:@"BrandJackpotTableViewCell" bundle:nil];
    [self.tableView registerNib:jackpotCellNib forCellReuseIdentifier:@"JackpotCell"];
    
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
    
    UINib *WishlistBrandNib = [UINib nibWithNibName:@"WishlistBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:WishlistBrandNib forCellReuseIdentifier:@"WishlistBrandCell"];
    
    UINib *BrandListCellNib = [UINib nibWithNibName:@"BrandListTableViewCell" bundle:nil];
    [self.tableView registerNib:BrandListCellNib forCellReuseIdentifier:@"BrandListCell"];
    
    UINib *MiniBannerCellNib = [UINib nibWithNibName:@"MiniBannerCell" bundle:nil];
    [self.tableView registerNib:MiniBannerCellNib forCellReuseIdentifier:@"MiniBannerCell"];
    
    self.bagLabel.layer.cornerRadius = 10.0f;
    self.bagLabel.layer.masksToBounds = YES;
    self.bagLabel.layer.borderColor = [UIColor colorWithHexString:HEX_COLOR_RED].CGColor;
    self.bagLabel.layer.borderWidth = 3.5f;

    if (self.brand) {
        self.giftArray = self.brand.giftCards;
        
        self.headerLabel.text = [self.brand.name uppercaseString];

    }
    
    NSInteger scrollIndex = 0;
    if (self.giftArray.count == 2) {
        scrollIndex = 1;
    } else if (self.giftArray.count == 3) {
        scrollIndex = 1;
    } else if (self.giftArray.count > 3) {
        scrollIndex = 2;
    }
    
    if ([self.brand isAllSoldOutOnlyCard]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kBrandSectionMainAction]];
        
        if ([cell isKindOfClass:[MainActionBrandTableViewCell class]]) {
            MainActionBrandTableViewCell *mainActionCell =  (MainActionBrandTableViewCell*)cell;
            [mainActionCell disabledButtonsWithAnimation:YES];
        }
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

#pragma -mark PricesCardTableViewCellDelegate
- (void)giftCardSelected:(NSDictionary *)giftCard WithIndexCard:(NSInteger)indexCard {
    
    self.activeIndex = indexCard;
    
    
    NSDictionary *giftDict = self.giftArray[self.activeIndex];
    
    if (!giftDict) {
        return;
        // No Gift
    }
    
    self.currentGiftCardSoldOut =  ([[giftDict allKeys] containsObject:@"sold_out"] && [giftDict[@"sold_out"] isEqual: @(YES)]);
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kBrandSectionMainAction]];
    
    if ([cell isKindOfClass:[MainActionBrandTableViewCell class]]) {
        MainActionBrandTableViewCell *mainActionCell =  (MainActionBrandTableViewCell*)cell;
        if (self.currentGiftCardSoldOut) {
            [mainActionCell disabledButtonsWithAnimation:YES];
        } else {
            [mainActionCell enabledButtonsWithAnimation:YES];
        }
    }
    
    if (self.brand.percentage.floatValue > 0) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kBrandSectionEarn]];
        
        if ([cell isKindOfClass:[EarnTableViewCell class]]) {
            if (giftCard) {
                EarnTableViewCell *earnCell =  (EarnTableViewCell*)cell;
                
                if ([UserController sharedInstance].currentUser.powerUpExpiryDate || [self.brand.powerUp boolValue]) {
                    
                    NSNumber *giftPrice = giftCard[@"price"][@"value"];
                    NSNumber *cashback = [NSNumber numberWithFloat:giftPrice.floatValue * self.brand.percentage.floatValue / 100];
                    [earnCell setEarnCashback:cashback];
                    
                } else {
                    
                    [earnCell setEarnCashback:giftCard[@"cash_back"][@"value"] ];
                    
                }
            }
        }
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

        StoreTableViewController *storeView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"StoreView"];
        storeView.brand = self.brand;
        
        [self.navigationController pushViewController:storeView animated:YES];
    }
    
    
    return;
}

#pragma -mark MainActionBrandTableViewCellDelegate 
- (void)buyItTapped {
    
    NSDictionary *giftDict = self.giftArray[self.activeIndex];
    if (!giftDict) {
        return;
        // No Gift
    }
    
    if ([[giftDict allKeys] containsObject:@"sold_out"] && [giftDict[@"sold_out"] isEqual: @(YES)]) {
        return;
    }
    
    if ([self.brand.isClubOnly boolValue]) {
        
        if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
            
            [self goCheckoutPage:giftDict];
            
        } else {
            
            [self showClubExclusiveView];
            
        }
        
    } else {
        
        [self goCheckoutPage:giftDict];
        
    }

}

- (void)goCheckoutPage:(NSDictionary*)dict{
    
    CheckoutViewController *checkoutView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"CheckoutView"];
    checkoutView.brand = self.brand;
    checkoutView.giftDict = dict;
    
    [self.navigationController pushViewController:checkoutView animated:YES];
    
}

- (void)giftItTapped{
    
    NSDictionary *giftDict = self.giftArray[self.activeIndex];
    if (!giftDict) {
        return;
        // No Gift
    }
    
    if ([[giftDict allKeys] containsObject:@"sold_out"] && [giftDict[@"sold_out"] isEqual: @(YES)]) {
        return;
    }
    
    if ([self.brand.isClubOnly boolValue]) {
        
        if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
            
            [self goGiftItPage:giftDict];
            
        } else {
            
            [self showClubExclusiveView];
            
        }
        
    } else {
        
        [self goGiftItPage:giftDict];
        
    }
}

- (void)goGiftItPage:(NSDictionary*)dict{
    
    GiftItViewController *giftItView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftItView"];
    giftItView.brand = self.brand;
    giftItView.giftDict = dict;
    
    [self.navigationController pushViewController:giftItView animated:YES];
}

#pragma -mark EarnTableViewCellDelegate
- (void)linkTapped {
    [self performSegueWithIdentifier:@"pushToCashback" sender:nil];
}

- (void)powerUpBannerClicked{

    PowerUpPackViewController *powerupPackView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"PowerUpPackView"];
    powerupPackView.coupons = [FZData getPowerUpPacks];
    [self.navigationController pushViewController:powerupPackView animated:YES];
}

#pragma -mark TripAdvisorBrandTableViewCellDelegate 

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

#pragma mark - UIScrollViewDelegate
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
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
            TermsAndConditionsTableViewController *howToRedeemViewController = (TermsAndConditionsTableViewController *)segue.destinationViewController;
            if (self.brand.giftCards && [self.brand.giftCards count] > 0) {
                howToRedeemViewController.termsConditions = self.brand.termsAndConditions;
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

#pragma mark - ClubExclusiveViewDelegate
- (void)clubExclusiveViewExploreButtonPressed{
    
    [super clubExclusiveViewExploreButtonPressed];
    
    UIViewController *viewController = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubSubscribeView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - MiniBannerSliderCellDelegate
- (void)miniBannerClicked:(NSDictionary *)bannerDict{
    
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}



@end
