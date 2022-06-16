//
//  ClubViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 19/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "ClubViewController.h"
#import "ClubSubscibeTableViewCell.h"
#import "ClubStoreViewController.h"
#import "ClubStoreTableViewCell.h"
#import "ClubTopTableViewCell.h"
#import "BannerSliderCell.h"
#import "ClubEarnTableViewCell.h"
#import "ClubStoreViewController.h"
#import "ClubStoreListViewController.h"
#import "ClubOfferViewController.h"
#import "ClubCategoryTableViewCell.h"
#import "ClubCategoryViewController.h"
#import "ClubSearchViewController.h"
#import "BrandJackpotViewController.h"
#import "JackpotCardViewController.h"
#import "PowerUpPackCardViewController.h"
#import "ClubFavoriteViewController.h"
#import "ClubStoreLocationViewController.h"
#import "MiniBannerCell.h"
#import "BrandListTableViewCell.h"
#import "BrandListViewController.h"
#import "PackageListViewController.h"
#import "CardViewController.h"
#import "PackageViewController.h"

typedef enum :NSUInteger{
    kClubSectionSubscribe,
    kClubSectionEarn,
    kClubSectionBanner,
    kClubSectionCategory,
    kClubSectionNear,
    kClubSectionTop,
    kClubSectionTrending,
    kClubSectionMiniBanner,
    kClubSectionBrand,
    kClubSectionNew,
    kClubSectionCount,
    kClubSectionFlash,
} kClubSection;

@interface ClubViewController () <UITableViewDataSource, UITableViewDelegate, ClubSubscibeTableViewCellDelegate, ClubEarnTableViewCellDelegate, ClubStoreTableViewCellDelegate, ClubCategoryTableViewCellDelegate, ClubTopTableViewCellDelegate, BannerSliderCellDelegate, MiniBannerSliderCellDelegate, BrandListTableViewCellDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *subscribeView;
@property (weak, nonatomic) IBOutlet UIButton *btnReferral;

- (IBAction)subscribebuttonPressed:(id)sender;
- (IBAction)inviteButtonPressed:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;
- (IBAction)favoriteButtonPressed:(id)sender;

@property (assign, nonatomic) BOOL clubHomeLoaded;

@end

@implementation ClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clubSubscribeSuccess) name:CLUB_SUBSCRIBE_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clubOfferRedeemed) name:CLUB_OFFER_REDEEMED object:nil];

    
    [self setStyling];
    
    [self loadClubHome:YES];
    [self loadRedeemedClubOffer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[AppDelegate sharedAppDelegate] startLocationService];
}

- (void)clubSubscribeSuccess{
    
    [self.tableView reloadData];
    self.subscribeView.alpha = 0.0f;
    self.btnReferral.hidden = NO;
}

- (void)clubOfferRedeemed{
    
    [self loadClubHome:NO];
    [self loadRedeemedClubOffer];
}

- (void)loadClubHome:(BOOL)showLoader{
    
    if ([FZData sharedInstance].currentLocation) {
        [[APIClient sharedInstance] setLocation:[FZData sharedInstance].currentLocation];
    }
    
    if (showLoader) {
        
         [self showLoaderToWindow];
    }
   
    [ClubController getClubHome:^(NSDictionary *dictionary, NSError *error) {
        
        [self hideLoaderFromWindow];
        
        if (dictionary) {
            
            self.clubHomeLoaded = YES;
            
            if (dictionary[@"trending_stores"]) {
                
                [FZData sharedInstance].trendingStores = dictionary[@"trending_stores"];
            }
            
            if (dictionary[@"nearby_stores"]) {
                
                [FZData sharedInstance].nearByStores = dictionary[@"nearby_stores"];
            }
            
            if (dictionary[@"new_stores"]) {
                
                [FZData sharedInstance].freshStores = dictionary[@"new_stores"];
            }
            
            if (dictionary[@"flash_sale_offers"]) {
                
                [FZData sharedInstance].flashSales = dictionary[@"flash_sale_offers"];
            }
            
            if (dictionary[@"top_brands"]) {
            
                NSArray *array = dictionary[@"top_brands"];
                NSMutableArray *topArray = [NSMutableArray new];
                
                for (NSDictionary *topDict in array) {
                    
                    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"brandId LIKE[cd] %@", topDict[@"brand_id"]];
                    NSArray *brandArray = [[FZData sharedInstance].brandArray filteredArrayUsingPredicate:predicate];
                    
                    if (brandArray.count > 0) {
                        FZBrand *brand = [brandArray.firstObject copy];
                        brand.customImage = topDict[@"image"];
                        brand.brandLink = topDict[@"link_to"];
                        [topArray addObject:brand];
                    }
                }
                
                [FZData sharedInstance].topBrands = topArray;
            }
            
            if (dictionary[@"categories"]) {
                
                [FZData sharedInstance].clubCategories = dictionary[@"categories"];
            }
            
            if (dictionary[@"brand_types"]) {
                
                [FZData sharedInstance].clubBrandTypes = dictionary[@"brand_types"];
            }
            
            if (dictionary[@"stores"]) {
                
                [FZData sharedInstance].clubStores = dictionary[@"stores"];
            }
            
            if (dictionary[@"places"]) {
                
                [FZData sharedInstance].clubPlaces = dictionary[@"places"];
            }
            
            if (dictionary[@"banners"]) {
                
                [FZData sharedInstance].clubBanners = dictionary[@"banners"];
            }
            
            if (dictionary[@"mini_banners"]) {
                
                [FZData sharedInstance].clubMiniBanners = dictionary[@"mini_banners"];
            }
            
            if (dictionary[@"faqs"]) {
                
                [FZData sharedInstance].clubFaqs = dictionary[@"faqs"];
            }
            
            if (dictionary[@"terms"]) {
                
                [FZData sharedInstance].clubTerms = dictionary[@"terms"];
            }
            
            [self.tableView reloadData];
            
        } else {
            
            if (error && error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            
            if (error) {
                
                [self showEmptyError:error.localizedDescription window:YES];
            }
            
        }
    }];
}

- (void)loadRedeemedClubOffer{
    
    [ClubController getRedeemedClubOffers:^(NSArray *array, NSError *error) {
        
        if (array) {
            
            [FZData sharedInstance].redeemedClubOffers = array;
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.clubHomeLoaded) {
        
        return kClubSectionCount;
        
    } else {
        
        return 0;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case kClubSectionSubscribe:{
            
            if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
                return 0;
            } else{
                return 1;
            }
            
            break;
        }
        case kClubSectionEarn:{
            
            if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
                return 1;
            } else{
                return 0;
            }
            
            break;
        }
        case kClubSectionBanner:{
            
            if ([FZData sharedInstance].clubBanners.count > 0) {
                return 1;
            } else{
                return 0;
            }
            break;
        }
        case kClubSectionCategory:{
            
            if ([FZData sharedInstance].clubBrandTypes.count > 0) {
                return 1;
            } else{
                return 0;
            }

            break;
        }
        case kClubSectionFlash:{
            
            if ([FZData sharedInstance].flashSales.count > 0) {
                return 1;
            } else{
                return 0;
            }
            
            break;
        }

        case kClubSectionNear:{
            
            if ([FZData sharedInstance].nearByStores.count > 0) {
                return 1;
            } else {
                return 0;
            }

            break;
        }

        case kClubSectionTop:{
            
            if ([FZData sharedInstance].topBrands.count > 0) {
                return 1;
            } else{
                return 0;
            }
            
            break;
        }

        case kClubSectionTrending:{
            
            if ([FZData sharedInstance].trendingStores.count > 0) {
                return 1;
            } else {
                return 0;
            }
            
            break;
        }
            
        case kClubSectionBrand:{
            
            if ([FZData sharedInstance].clubBrandArray.count > 0) {
                return 1;
            } else{
                return 0;
            }
            
            break;
        }

        case kClubSectionNew:{
            
            if ([FZData sharedInstance].freshStores.count > 0) {
                return 1;
            } else {
                return 0;
            }
            
            break;
        }
            
        case kClubSectionMiniBanner:{
            
            if ([FZData sharedInstance].clubMiniBanners.count > 0) {
                return 1;
            } else {
                return 0;
            }
            
            break;
        }

        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case kClubSectionSubscribe:
            return 170.0f;
            break;
        case kClubSectionEarn:
            return 80.0f;
            break;
        case kClubSectionBanner:
            return [UIScreen mainScreen].bounds.size.width * 0.75;
            break;
        case kClubSectionCategory:
            return 115.0f;
            break;
        case kClubSectionFlash:
            return 235.0f;
            break;
        case kClubSectionNear:
            return 280.0f;
            break;
        case kClubSectionTop:{
            
            int topBrandColumn = 4;
            int topBrandRow = (int)(ceil(MIN([FZData sharedInstance].topBrands.count, 8) / (float)topBrandColumn));
            
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            CGFloat width = (screenSize.width - 15 * 2 - 10 * (topBrandColumn - 1)) / topBrandColumn;
           
            return width * topBrandRow + 10 * (topBrandRow - 1) + 79;
            break;
        }
        case kClubSectionTrending:
            return 280.0f;
            break;
        case kClubSectionMiniBanner:
            return [UIScreen mainScreen].bounds.size.width * 100 /320;
            break;
        case kClubSectionBrand:
            return 280.0f;
            break;
        case kClubSectionNew:
            return 280.0f;
            break;
        default:
            return 0.0f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case kClubSectionSubscribe:{
         
            ClubSubscibeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubscribeCell"];
            cell.delegate = self;
            return cell;
            break;
        }
        case kClubSectionEarn:{
            
            ClubEarnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EarnCell"];
            cell.delegate = self;
            if ([UserController sharedInstance].currentUser && [UserController sharedInstance].currentUser.clubSavings) {
                cell.lbSaving.attributedText = [CommonUtilities getFormattedValue:[UserController sharedInstance].currentUser.clubSavings fontSize:18.0f smallFontSize:14.0f];
            }
            return cell;
            break;
        }
        case kClubSectionBanner:{
            
            BannerSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BannerSliderCell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell initSliderIfNeeded];
            [cell setBanner:[FZData sharedInstance].clubBanners];
            return cell;
        }
        case kClubSectionCategory:{
            
            ClubCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
            [cell setCell:[FZData sharedInstance].clubBrandTypes];
            cell.delegate = self;
            return cell;
        }
        case kClubSectionFlash:{
            
            ClubStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            [cell setCellWithOffers:[FZData sharedInstance].flashSales];
            cell.delegate = self;
            cell.lbType.text = @"FLASH SALES";
            return cell;
        }
        case kClubSectionNear:{
            
            ClubStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            [cell setCellWithStores:[FZData sharedInstance].nearByStores];
            cell.delegate = self;
            cell.lbType.text = @"NEARBY STORES";
            return cell;
        }
        case kClubSectionTop:{
            
            ClubTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell"];
            [cell setCell:[FZData sharedInstance].topBrands];
            cell.delegate = self;
            return cell;
        }
        case kClubSectionTrending:{
            
            ClubStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            [cell setCellWithStores:[FZData sharedInstance].trendingStores];
            cell.delegate = self;
            cell.lbType.text = @"TRENDING";
            return cell;
        }
        case kClubSectionMiniBanner:{
            
            MiniBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MiniBannerCell" forIndexPath:indexPath];
            [cell initSliderIfNeeded];
            [cell setBanner:[FZData sharedInstance].clubMiniBanners];
            cell.delegate = self;
            
            return cell;
        
        }
        case kClubSectionBrand:{
            
            BrandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandListCell" forIndexPath:indexPath];
            [cell setCell:[FZData sharedInstance].clubBrandArray title:@"CASHBACK FOR MEMBERS-ONLY" limit:10 type:BrandListTableViewCellTypeClub showViewAll:YES];
            cell.delegate = self;
            
            return cell;
            
        }
        case kClubSectionNew:{
            
            ClubStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            [cell setCellWithStores:[FZData sharedInstance].freshStores];
            cell.delegate = self;
            cell.lbType.text = @"NEW ON THE CLUB";
            return cell;
        }
        default:
            return nil;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kClubSectionBanner:{
            
            if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
                return 0.0f;
            } else{
                return 10.0f;
            }
            break;
        }
        case kClubSectionCategory:
            return 10.0f;
            break;
        case kClubSectionFlash:
            return 10.0f;
            break;
        case kClubSectionNear:
            return 10.0f;
            break;
        case kClubSectionTop:
            return 10.0f;
            break;
        case kClubSectionTrending:
            return 10.0f;
            break;
        case kClubSectionMiniBanner:{
            
            if ([FZData sharedInstance].clubMiniBanners.count > 0) {
                return 10.0f;
            } else{
                return 0.0f;
            }
            break;
        }
        case kClubSectionBrand:
            return 10.0f;
            break;
        case kClubSectionNew:
            return 10.0f;
            break;
        default:
            return 0.0f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10.0f)];
    spacerView.backgroundColor = [UIColor clearColor];
    
    return spacerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshClubData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    
    UINib *subscribeNib = [UINib nibWithNibName:@"ClubSubscibeTableViewCell" bundle:nil];
    [self.tableView registerNib:subscribeNib forCellReuseIdentifier:@"SubscribeCell"];
    
    UINib *earnNib = [UINib nibWithNibName:@"ClubEarnTableViewCell" bundle:nil];
    [self.tableView registerNib:earnNib forCellReuseIdentifier:@"EarnCell"];
    
    UINib *bannerNib = [UINib nibWithNibName:@"BannerSliderCell" bundle:nil];
    [self.tableView registerNib:bannerNib forCellReuseIdentifier:@"BannerSliderCell"];
    
    UINib *categoryNib = [UINib nibWithNibName:@"ClubCategoryTableViewCell" bundle:nil];
    [self.tableView registerNib:categoryNib forCellReuseIdentifier:@"CategoryCell"];
    
    UINib *storeNib = [UINib nibWithNibName:@"ClubStoreTableViewCell" bundle:nil];
    [self.tableView registerNib:storeNib forCellReuseIdentifier:@"StoreCell"];
    
    UINib *brandNib = [UINib nibWithNibName:@"BrandListTableViewCell" bundle:nil];
    [self.tableView registerNib:brandNib forCellReuseIdentifier:@"BrandListCell"];
    
    UINib *topNib = [UINib nibWithNibName:@"ClubTopTableViewCell" bundle:nil];
    [self.tableView registerNib:topNib forCellReuseIdentifier:@"TopCell"];
    
    UINib *miniBannerCell = [UINib nibWithNibName:@"MiniBannerCell" bundle:nil];
    [self.tableView registerNib:miniBannerCell forCellReuseIdentifier:@"MiniBannerCell"];
    
    [self setShadowForSubscribeView];
    
}

- (void)setShadowForSubscribeView{
    
    self.subscribeView.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
    self.subscribeView.layer.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f].CGColor;
    self.subscribeView.layer.shadowOpacity = 1.0f;
    self.subscribeView.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    self.subscribeView.layer.shadowRadius = 8.0f;
    self.subscribeView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.subscribeView.bounds].CGPath;
}


- (void) refreshClubData{
    
    [self.refreshControl endRefreshing];
    [self loadClubHome:YES];
}

- (void)goSubscribe{
    
    UIViewController *viewController = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubSubscribeView"];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (![[UserController sharedInstance].currentUser.clubMember boolValue]) {
        
        CGFloat heightSlider = 170;
        
        int realPosition = scrollView.contentOffset.y+20;
        if (realPosition >= heightSlider) {
            float ratio = realPosition-heightSlider;
            double coef = MIN(1,ratio/32);
            self.subscribeView.alpha = (float)coef;
        } else {
            self.subscribeView.alpha = 0;
        }
    }
}

#pragma mark - MiniBannerSliderCellDelegate
- (void)miniBannerClicked:(NSDictionary *)bannerDict{
    [self bannerClicked:bannerDict];
}


#pragma mark - BannerSliderCellDelegate
- (void)bannerClicked:(NSDictionary *)bannerDict {
    
    if (!bannerDict) return;
    
    if ([bannerDict[@"banner_type"] isEqualToString:@"Web-linked"]) {
        
        NSURL *url = [NSURL URLWithString:bannerDict[@"link"]];
        FZWebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
        webView.URL = url;
        webView.title = bannerDict[@"title"];
        webView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webView animated:YES];
        
    } else if ([bannerDict[@"banner_type"] isEqualToString: @"ClubBrand"]){
        
        NSArray *clubStores = bannerDict[@"club_brand_stores"];
        if (clubStores.count > 0) {
            
            if (clubStores.count != 1) {
                
                ClubStoreViewController *storeView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubStoreView"];
                storeView.dict = [clubStores firstObject];
                storeView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:storeView animated:YES];
                
            } else {
                
                ClubStoreLocationViewController *locationView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubStoreLocationView"];
                locationView.clubStores = clubStores;
                locationView.showStore = YES;
                locationView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:locationView animated:YES];
            }
        }
        
    } else if ([bannerDict[@"banner_type"] isEqualToString: @"ClubOffer"]){
        
        
    } else if ([bannerDict[@"banner_type"] isEqualToString:@"Referral Page"]) {
        
        UIViewController *viewController = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubInviteView"];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
                
    }
}


#pragma mark - ClubSubscibeTableViewCellDelegate
- (void)subscribeButtonPressed{
    
    [self goSubscribe];
}

#pragma mark - ClubEarnTableViewCellDelegate
- (void)settingButtonPressed{
    
    UIViewController *settingView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubSettingView"];
    settingView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingView animated:YES];
    
}

#pragma mark - ClubCategoryTableViewCellDelegate
- (void)categoryCellTapped:(NSDictionary *)dict{
    
    ClubCategoryViewController *categoryView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubCategoryView"];
    categoryView.brandType = dict;
    categoryView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:categoryView animated:YES];
    
}

#pragma mark - ClubStoreTableViewCellDelegate
- (void)clubStoreCellTapped:(NSDictionary *)dict flashMode:(BOOL)flashMode{
    
    if (flashMode) {
        
        ClubOfferViewController *offerView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubOfferView"];
        offerView.offer = dict;
        offerView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:offerView animated:YES];
        
    } else {
     
        ClubStoreViewController *storeView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubStoreView"];
        storeView.dict = dict;
        storeView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:storeView animated:YES];
    }
}

- (void)viewAllButtonPressed:(NSArray *)array title:(NSString *)title flashMode:(BOOL)flashMode{
    
    ClubStoreListViewController *storeListView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubStoreListView"];
    storeListView.array = array;
    storeListView.titleString = title;
    storeListView.flashMode = flashMode;
    storeListView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:storeListView animated:YES];
}

#pragma mark - ClubTopTableViewCellDelegate
- (void)brandWasClicked:(FZBrand *)brand{
    
    if (brand.brandLink) {
        
        if (brand.brandLink[@"type"] && [brand.brandLink[@"type"] isEqualToString:@"club"] && brand.brandLink[@"club_store_ids"]) {
            
            NSArray *clubStoreIds = brand.brandLink[@"club_store_ids"];
            
            if (clubStoreIds.count > 0) {
                
                NSMutableArray *clubStores = [[NSMutableArray alloc] init];
                
                for (NSString *clubStoreId in clubStoreIds) {
                    
                    NSDictionary *clubStore = [FZData getClubStore:clubStoreId stores:[FZData sharedInstance].clubStores];
                    if (clubStore) {
                        [clubStores addObject:clubStore];
                    }
                    
                }

                if (clubStores.count > 0) {
                    
                    if (clubStores.count == 1) {
                        
                        ClubStoreViewController *storeView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubStoreView"];
                        storeView.dict = clubStores.firstObject;
                        storeView.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:storeView animated:YES];
                        
                    } else {
                        
                        ClubStoreListViewController *storeListView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubStoreListView"];
                        storeListView.array = clubStores;
                        storeListView.titleString = brand.name;
                        storeListView.flashMode = NO;
                        storeListView.hideFilter = YES;
                        storeListView.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:storeListView animated:YES];
                    }
                }
            }
        }
    }
    
}

#pragma mark - BrandListTableViewCellDelegate
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state {
    [self likeBrand:brand withState:state];
}

- (void)brandWasClicked:(FZBrand *)brand type:(BrandListTableViewCellType)type{
    
    if (type == BrandListTableViewCellTypeClub) {
        
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
                                
                                JackpotCardViewController *cardView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotCardView"];
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

- (void)viewAllWasClickedForTitle:(BrandListTableViewCellType)type{
    
    BrandListViewController *brandListView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"BrandListView"];
    
    if (type == BrandListTableViewCellTypeClub) {
        
        brandListView.headerTitle = @"CLUB BRANDS";
        brandListView.brandArray = [FZData sharedInstance].clubBrandArray;
        brandListView.showFilter = NO;
    }
    
    brandListView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:brandListView animated:YES];
}

- (void)goNormalBrand:(FZBrand*)brand{
    
    if (brand.giftCards && brand.giftCards.count > 0 && brand.services && brand.services.count > 0) {
        
        PackageListViewController *packageListView = [self.storyboard instantiateViewControllerWithIdentifier:@"PackageListView"];
        packageListView.brand = brand;
        packageListView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:packageListView animated:YES];
        
    } else if (brand.giftCards && brand.giftCards.count > 0) {
        
        CardViewController *cardView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"CardViewController"];
        cardView.brand = brand;
        cardView.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:cardView animated:YES];
        
    } else if (brand.services && brand.services.count == 1) {
        
        NSDictionary *packageDict = [brand.services firstObject];
    
        PackageViewController *packageView = [[GlobalConstants brandStoryboard] instantiateViewControllerWithIdentifier:@"PackageViewController"];
        packageView.brand = brand;
        packageView.packageDict = packageDict;
        packageView.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:packageView animated:YES];
        
        
    } else if (brand.services && brand.services.count > 1) {
        
        PackageListViewController *packageListView = [self.storyboard instantiateViewControllerWithIdentifier:@"PackageListView"];
        packageListView.brand = brand;
        packageListView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:packageListView animated:YES];
        
    }
}

#pragma mark - IBAction Help
- (IBAction)subscribebuttonPressed:(id)sender {
    
    [self goSubscribe];
}

- (IBAction)inviteButtonPressed:(id)sender {
    
    if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
        
        UIViewController *inviteView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubInviteView"];
        inviteView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inviteView animated:YES];
        
    } else {
        
        [self showError:@"Join the Club to activate your referral rewards." headerTitle:@"JOIN THE CLUB" buttonTitle:@"LEARN MORE" image:@"bear-club" window:YES];
        self.popView.btnCancel.hidden = NO;
        [self.popView.btnCancel setTitle:@"Close" forState:UIControlStateNormal];
        
    }

}

- (IBAction)searchButtonPressed:(id)sender {
    
    ClubSearchViewController *searchView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubSearchView"];
    searchView.clubStores = [FZData sharedInstance].clubStores;
    searchView.clubPlaces = [FZData sharedInstance].clubPlaces;
    searchView.hidesBottomBarWhenPushed = YES;
    UINavigationController *searchNavigation = [[UINavigationController alloc] initWithRootViewController:searchView];
    searchNavigation.navigationBarHidden = YES;
    [self presentViewController:searchNavigation animated:YES completion:nil];
}

- (IBAction)favoriteButtonPressed:(id)sender{
    
    ClubFavoriteViewController *favoriteView =  [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubFavoriteView"];
    favoriteView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:favoriteView animated:YES];
}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    
    [super okButtonClicked];
    
    [self goSubscribe];
}

@end
