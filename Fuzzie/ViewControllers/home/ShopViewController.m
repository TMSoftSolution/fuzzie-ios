//
//  ShopViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 19/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "FuzzieViewController.h"
#import "ShopViewController.h"
#import "BannerTableViewCell.h"
#import "BrandListTableViewCell.h"
#import "CategoryListTableViewCell.h"
#import "FZTabBarViewController.h"

#import "JoinViewController.h"
#import "BrandListViewController.h"
#import "PackageListViewController.h"
#import "BannerSliderCell.h"
#import "FZTabBarViewController.h"
#import "CardViewController.h"
#import "AppDelegate.h"
#import "PackageViewController.h"
#import "FuzzieCreditsTableViewCell.h"
#import "MeViewController.h"
#import "InviteFriendsViewController.h"
#import "MiniBannerCell.h"
#import "UpcomingBirthdayTableViewCell.h"
#import "UserProfileViewController.h"
#import "FriendsListViewController.h"
#import "CampaignDetailViewController.h"
#import "FZCoachMarkView.h"
#import "TopUpFuzzieCreditsViewController.h"
#import "HomeJackpotTableViewCell.h"
#import "HomeJackpotTeasingTableViewCell.h"
#import "JackpotHomePageViewController.h"
#import "JackpotDrawHistoryViewController.h"
#import "JackpotLearnMoreViewController.h"
#import "JackpotCardViewController.h"
#import "PowerUpPackViewController.h"
#import "PowerUpPackCardViewController.h"
#import "RedPacketsViewController.h"
#import "BrandJackpotViewController.h"
#import "ClubStoreLocationViewController.h"
#import "ClubStoreViewController.h"

typedef enum : NSUInteger {
    kHomeSectionCredit,
    kHomeSectionBanner,
    kHomeSectionRecommended,
    kHomeSectionClub,
    kHomeSectionReferralMiniBanner,
    kHomeSectionRedPacketMiniBanner,
    kHomeSectionPowerUpPackMiniBanner,
    kHomeSectionJackpot,
    kHomeSectionPopular,
    kHomeSectionUpcomingBirthdays,
    kHomeSectionLatest,
    kHomeSectionTop,
    kHomeSectionCategory,
    kHomeSectionCount
} kHomeSection;

@interface ShopViewController () <UITableViewDataSource,UITableViewDelegate,BrandListTableViewCellDelegate,CategoryListTableViewCellDelegate, BannerSliderCellDelegate,  UINavigationControllerDelegate,UIGestureRecognizerDelegate, UIScrollViewDelegate, FuzzieCreditsTableViewCellDelegate, UpcomingBirthdayTableViewCellDelegate, FZCoachMarkViewDelegate, HomeJackpotTableViewCellDelegate, HomeJackpotTeasingTableViewCellDelegate, MiniBannerSliderCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *bagLabel;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *powerUpView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerUpViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *powerUpTimerLabel;
@property (strong, nonatomic) NSTimer *powerUpTimer;

@property (strong, nonatomic) FZCoachMarkView *coachMarkerView;

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;


- (IBAction)searchButtonPressed:(id)sender;
- (IBAction)bagButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;

@end

@implementation ShopViewController

static int NB_LIMIT_CELL = 10;
static int NB_LIMIT_CELL1 = 8;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStyling];
    
    if (self.isAlreadyInit) {
        self.isAlreadyInit = false;
        return;
    }
    
    [[FZLocalNotificationManager sharedInstance] scheduleMyBirthdayNotification];
    
    [self loadHomeData];
    [self loadBagInfo];
    
    if ([UserController sharedInstance].currentUser.facebookId) {
        [self loadFacebookFriends];
    }
    
    FZTabBarViewController *tabBarController = (FZTabBarViewController*)self.tabBarController;
    if (tabBarController.showNotificationSetting) {
        [self requestPushNotificationPermission];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData) name:SHOULD_RELOAD_HOME_DATA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCredits) name:SHOULD_REFRESH_USER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkRedeeming) name:ACTIVE_GIFTBOX_REFRESHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDrawStart) name:JACKPOT_LIVE_DRAW_START object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDrawEnd) name:JACKPOT_LIVE_DRAW_END object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadJackpotResult) name:JACKPOT_RESULT_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadJackpotResult) name:JACKPOT_LIVE_DRAW_WON object:nil];    

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:RESET_BRAND_SLIDER object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:RESET_MINI_BABBER_SLIDER object:nil];

    [[AppDelegate sharedAppDelegate] stopLocationService];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self updateBagCount];
    if([FZData sharedInstance].goFriendsListFromHome){
        [self.tableView reloadData];
        [FZData sharedInstance].goFriendsListFromHome = false;
    }

    [[AppDelegate sharedAppDelegate] startLocationService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOULD_RELOAD_HOME_DATA object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOULD_REFRESH_USER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTIVE_GIFTBOX_REFRESHED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JACKPOT_LIVE_DRAW_START object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JACKPOT_LIVE_DRAW_END object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JACKPOT_LIVE_DRAW_WON object:nil];
}

#pragma mark - Button Actions

- (IBAction)searchButtonPressed:(id)sender {
    UIViewController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchView"];
    UINavigationController *searchNavigation = [[UINavigationController alloc] initWithRootViewController:searchView];
    searchNavigation.navigationBarHidden = YES;
    [self presentViewController:searchNavigation animated:YES completion:nil];
}

- (IBAction)likeButtonPressed:(id)sender {
    
    if ([UserController sharedInstance].currentUser) {

        [self.tabBarController setSelectedIndex:kTabBarItemMe];
        UINavigationController *navController = [[self.tabBarController viewControllers] objectAtIndex:kTabBarItemMe];
        MeViewController *meView = [[navController viewControllers] objectAtIndex:0];
        meView.fromShop = true;
        
    } else {
        JoinViewController *joinView = [self.storyboard instantiateViewControllerWithIdentifier:@"JoinView"];
        joinView.showCloseButton = YES;
        UINavigationController *joinNavigation = [[UINavigationController alloc] initWithRootViewController:joinView];
        [self presentViewController:joinNavigation animated:YES completion:nil];
    }
    
}

- (IBAction)bagButtonPressed:(id)sender {
    
    if ([UserController sharedInstance].currentUser) {
        UIViewController *shoppingBagView = [self.storyboard instantiateViewControllerWithIdentifier:@"ShoppingBagView"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shoppingBagView];
        navigationController.navigationBarHidden = YES;
        [self presentViewController:navigationController animated:YES completion:nil];

    } else {
        JoinViewController *joinView = [self.storyboard instantiateViewControllerWithIdentifier:@"JoinView"];
        joinView.showCloseButton = YES;
        UINavigationController *joinNavigation = [[UINavigationController alloc] initWithRootViewController:joinView];
        [self presentViewController:joinNavigation animated:YES completion:nil];
    }
    
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self hideEmptyView];
    [self loadHomeData];
    if ([UserController sharedInstance].currentUser.facebookId) {
        [self loadFacebookFriends];
    }
}

- (IBAction)creditsButtonPressed:(id)sender {
    self.tabBarController.selectedIndex = kTabBarItemMe;
}

- (void)refreshCredits{
     if ([UserController sharedInstance].currentUser && [UserController sharedInstance].currentUser.credits && [UserController sharedInstance].currentUser.credits.floatValue > 0 && [FZData sharedInstance].brandArray) {
         if (self.tableView.numberOfSections > 0) {
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kHomeSectionCredit] withRowAnimation:UITableViewRowAnimationNone];
         }
     } else{
         [self.tableView reloadData];
     }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![FZData sharedInstance].brandArray) {
        return 0;
    } else {
        return kHomeSectionCount;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case kHomeSectionCredit:
            return 1;
            break;
        case kHomeSectionLatest:
            if ([FZData sharedInstance].latestBrandArray.count > 0) {
                return 1;
            } else {
                return 0;
            }
        case kHomeSectionTop:
            if ([FZData sharedInstance].topArray.count > 0) {
                return 1;
            } else {
                return 0;
            }
        case kHomeSectionRecommended:
            if ([FZData sharedInstance].recommendedBrandArray.count > 0) {
                return 1;
            } else {
                return 0;
            }
        case kHomeSectionClub:
            if ([FZData sharedInstance].clubBrandArray.count > 0) {
                return 1;
            } else {
                return 0;
            }
        case kHomeSectionPopular:
            if ([FZData sharedInstance].popularBrandArray.count > 0) {
                return 1;
            } else {
                return 0;
            }
        case kHomeSectionBanner:
        case kHomeSectionJackpot:
        case kHomeSectionCategory:
        case kHomeSectionRedPacketMiniBanner:
        case kHomeSectionPowerUpPackMiniBanner:
        case kHomeSectionReferralMiniBanner:
        case kHomeSectionUpcomingBirthdays:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == kHomeSectionCredit) {
        
        FuzzieCreditsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FuzzieCreditsCell" forIndexPath:indexPath];
        cell.delegate = self;
        if ([UserController sharedInstance].currentUser && [UserController sharedInstance].currentUser.credits) {
            cell.creditLabel.attributedText = [CommonUtilities getFormattedValue:[UserController sharedInstance].currentUser.credits fontSize:18.0f smallFontSize:14.0f];
        }
        
        return cell;
        
    } else if (indexPath.section == kHomeSectionBanner) {
        
        BannerSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BannerSliderCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell initSliderIfNeeded];
        [cell setBanner:[FZData sharedInstance].bannerArray];
        
        return cell;
        
    } else if(indexPath.section == kHomeSectionRedPacketMiniBanner){
        
        MiniBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MiniBannerCell" forIndexPath:indexPath];
        [cell initSliderIfNeeded];
        NSArray *miniBanners = [FZData getMiniBanners:@"RedPacket"];
        if (miniBanners.count > 0) {
            [cell setBanner:miniBanners];
        }
        cell.delegate = self;
        
        return cell;
        
    } else if(indexPath.section == kHomeSectionPowerUpPackMiniBanner){
        
        MiniBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MiniBannerCell" forIndexPath:indexPath];
        [cell initSliderIfNeeded];
        NSArray *miniBanners = [FZData getMiniBanners:@"PowerUpPacks"];
        if (miniBanners.count > 0) {
            [cell setBanner:miniBanners];
        }
        cell.delegate = self;
        
        return cell;
        
    } else if (indexPath.section == kHomeSectionJackpot){
        
        if ([FZData sharedInstance].enableJackpot) {
            HomeJackpotTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"JackpotCell"];
            cell.delegate = self;
            return cell;
        } else{
            HomeJackpotTeasingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"JackpotTeasingCell"];
            cell.delegate = self;
            return cell;
        }
        
      
        
    } else if (indexPath.section == kHomeSectionRecommended) {
        
        BrandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandListCell" forIndexPath:indexPath];
        [cell setCell:[FZData sharedInstance].recommendedBrandArray title:@"RECOMMENDED BRANDS" limit:NB_LIMIT_CELL type:BrandListTableViewCellTypeRecommended showViewAll:YES];
        cell.delegate = self;
        
        return cell;
        
    } else if (indexPath.section == kHomeSectionClub) {
        
        BrandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandListCell" forIndexPath:indexPath];
        [cell setCell:[FZData sharedInstance].clubBrandArray title:@"CLUB BRANDS" limit:NB_LIMIT_CELL type:BrandListTableViewCellTypeClub showViewAll:YES];
        cell.delegate = self;
        
        return cell;
        
    } else if (indexPath.section == kHomeSectionPopular) {
        
        BrandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandListCell" forIndexPath:indexPath];
        [cell setCell:[FZData sharedInstance].popularBrandArray title:@"TRENDING BRANDS" limit:NB_LIMIT_CELL type:BrandListTableViewCellTypeTrending showViewAll:YES];
        cell.delegate = self;
        
        return cell;
        
    } else if (indexPath.section == kHomeSectionLatest) {
        
        BrandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandListCell" forIndexPath:indexPath];
        [cell setCell:[FZData sharedInstance].latestBrandArray title:@"NEW BRANDS" limit:NB_LIMIT_CELL type:BrandListTableViewCellTypeNew showViewAll:YES];
        cell.delegate = self;
        
        return cell;
    
    } else if (indexPath.section == kHomeSectionTop) {
        
        BrandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandListCell" forIndexPath:indexPath];
        [cell setCell:[FZData sharedInstance].topArray title:@"TOP BRANDS" limit:-1 type:BrandListTableViewCellTypeTop showViewAll:YES];
        cell.delegate = self;
        
        return cell;
    } else if (indexPath.section == kHomeSectionReferralMiniBanner) {
        
        MiniBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MiniBannerCell" forIndexPath:indexPath];
        [cell initSliderIfNeeded];
        NSArray *miniBanners = [FZData getMiniBanners:@"Referral Page"];
        if (miniBanners.count > 0) {
            [cell setBanner:miniBanners];
        }
        cell.delegate = self;
        
        return cell;
        
    } else if (indexPath.section == kHomeSectionUpcomingBirthdays){
        
        UpcomingBirthdayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpcomingBirthdayCell" forIndexPath:indexPath];
        cell.delegate = self;
        NSMutableArray *birthArray;
        if ([UserController sharedInstance].currentUser.facebookId) {
            
            if ([FZData getUpcomingBirthdays].count < NB_LIMIT_CELL1) {
                cell.nbLimit = (int)[FZData getUpcomingBirthdays].count + 1;
                birthArray = [[NSMutableArray alloc] initWithArray:[FZData getUpcomingBirthdays]];
                [birthArray addObject:[FZData getDummyUser]];
            } else{
                cell.nbLimit = NB_LIMIT_CELL1 + 1;
                NSRange range = NSMakeRange(0, NB_LIMIT_CELL1);
                birthArray = [[NSMutableArray alloc] initWithArray:[[FZData getUpcomingBirthdays] subarrayWithRange:range]];
                [birthArray addObject:[FZData getDummyUser]];
            }
            
        } else{
            birthArray = nil;
        }
        [cell setCell:birthArray];
        
        return cell;
        
    } else if (indexPath.section == kHomeSectionCategory) {
        
        CategoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryListCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.categoryArray = [FZData sharedInstance].categoryArray;
        
        return cell;
        
    } else {
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == kHomeSectionJackpot) {
        if ([FZData sharedInstance].enableJackpot) {
            HomeJackpotTableViewCell *jackpotCell = (HomeJackpotTableViewCell*)cell;
            [jackpotCell updateLiveDrawState];
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case kHomeSectionCredit:
            if ([UserController sharedInstance].currentUser && [UserController sharedInstance].currentUser.credits && [UserController sharedInstance].currentUser.credits.floatValue > 0) {
                return 60;
            } else {
                return 0;
            }
            break;
        case kHomeSectionBanner:
            return [UIScreen mainScreen].bounds.size.width * 0.75;
            break;
        case kHomeSectionTop:
            return 220.0f;
            break;
        case kHomeSectionRecommended:
        case kHomeSectionClub:
        case kHomeSectionPopular:
        case kHomeSectionLatest:
            return 280.0f;
            break;
        
        case kHomeSectionCategory:
            return 215.0f;
            break;
            
        case kHomeSectionRedPacketMiniBanner:
            if ([FZData getMiniBanners:@"RedPacket"].count == 0) {
                return 0;
            } else{
                return [UIScreen mainScreen].bounds.size.width * 100 /320;
            }
            break;
            
        case kHomeSectionPowerUpPackMiniBanner:
            if ([FZData getMiniBanners:@"PowerUpPacks"].count == 0) {
                return 0;
            } else{
                return [UIScreen mainScreen].bounds.size.width * 100 /320;
            }
            break;
            
        case kHomeSectionReferralMiniBanner:
            if ([FZData getMiniBanners:@"Referral Page"].count == 0) {
                return 0;
            } else{
                return [UIScreen mainScreen].bounds.size.width * 100 /320;
            }
            break;
        case kHomeSectionUpcomingBirthdays:
            if (![UserController sharedInstance].currentUser.facebookId) {
                return 134;
            } else if([FZData sharedInstance].fuzzieFriends.count != 0){
                return 164;
            } else{
                return 0;
            }
            break;
        case kHomeSectionJackpot:
            if ([FZData sharedInstance].enableJackpot) {
                return [HomeJackpotTableViewCell estimageHeight];
            } else{
                return [HomeJackpotTeasingTableViewCell estimateHeight];
            }
            break;
        default:
            return 0.0f;
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    switch (section) {
        case kHomeSectionLatest:
            if ([FZData sharedInstance].latestBrandArray && [FZData sharedInstance].latestBrandArray.count > 0) {
                return 10.0f;
            } else {
                return 0.0f;
            }
        case kHomeSectionTop:
            return 10.0f;
        case kHomeSectionPopular:
            return 10.0f;
        case kHomeSectionClub:
            return 10.0f;
        case kHomeSectionCategory:
            return 10.0f;
        case kHomeSectionRedPacketMiniBanner:
            if ([FZData getMiniBanners:@"RedPacket"].count == 0) {
                return 0.0f;
            } else{
                return 10.0f;
            }
            break;
        case kHomeSectionPowerUpPackMiniBanner:
            if ([FZData getMiniBanners:@"PowerUpPacks"].count == 0) {
                return 0.0f;
            } else{
                return 10.0f;
            }
            break;
        case kHomeSectionReferralMiniBanner:
            if ([FZData getMiniBanners:@"Referral Page"].count == 0) {
                return 0.0f;
            } else{
                return 10.0f;
            }
            break;
        case kHomeSectionUpcomingBirthdays:
            if (![UserController sharedInstance].currentUser.facebookId || [FZData sharedInstance].fuzzieFriends.count != 0) {
                return 10.0f;
            } else{
                return 0.0f;
            }
            break;
        case kHomeSectionJackpot:
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

#pragma -mark FuzzieCreditsTableViewCellDelegate
- (void)topUpPressed{
    
    TopUpFuzzieCreditsViewController *topUpView = [[GlobalConstants topUpStoryboard] instantiateViewControllerWithIdentifier:@"TopUpFuzzieCreditsView"];
    topUpView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topUpView animated:YES];
    
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
        
    } else if ([bannerDict[@"banner_type"] isEqualToString:@"Brand"]) {
        
        FZBrand *brand;
        
        for (FZBrand *aBrand in [FZData sharedInstance].brandArray) {
            if ([aBrand.brandId isEqualToString:bannerDict[@"brand_id"]]) {
                brand = aBrand;
                break;
            }
        }
        
        if (!brand) return;
        
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
            
        }
        
    } else if ([bannerDict[@"banner_type"] isEqualToString:@"BrandsList"]) {
        NSArray *idArray = bannerDict[@"brand_ids"];
        if (![idArray isKindOfClass:[NSNull class]]) {
            NSMutableArray *brandArray = [NSMutableArray new];
            for (NSString *brandId in idArray) {
                for (NSInteger i=0; i<[FZData sharedInstance].brandArray.count; i++) {
                    FZBrand *brand = [FZData sharedInstance].brandArray[i];
                    if ([brand.brandId isEqualToString:brandId]) {
                        [brandArray addObject:brand];
                        break;
                    }
                }
            }
            
            if (brandArray.count > 0) {
                BrandListViewController *brandListView = [self.storyboard instantiateViewControllerWithIdentifier:@"BrandListView"];
                if (bannerDict[@"title"] && ![bannerDict[@"title"] isKindOfClass:[NSNull class]]) {
                    brandListView.headerTitle = bannerDict[@"title"];
                }
                brandListView.brandArray = brandArray;
                [self.navigationController pushViewController:brandListView animated:YES];
            }
            
        }
        
    } else if ([bannerDict[@"banner_type"] isEqualToString:@"Referral Page"]) {
        
        if ([UserController sharedInstance].currentUser) {
            InviteFriendsViewController *inviteView = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteFriendsView"];
            inviteView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:inviteView animated:YES];
            
        } else {
            JoinViewController *joinView = [self.storyboard instantiateViewControllerWithIdentifier:@"JoinView"];
            joinView.showCloseButton = YES;
            UINavigationController *joinNavigation = [[UINavigationController alloc] initWithRootViewController:joinView];
            [self presentViewController:joinNavigation animated:YES completion:nil];
        }
        
    } else if([bannerDict[@"banner_type"] isEqualToString:@"General"]){
        if ([UserController sharedInstance].currentUser) {
            CampaignDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"CampaignDetailView"];
            detailView.hidesBottomBarWhenPushed = YES;
            detailView.bannerDict = bannerDict;
            [self.navigationController pushViewController:detailView animated:YES];
        } else{
            JoinViewController *joinView = [self.storyboard instantiateViewControllerWithIdentifier:@"JoinView"];
            joinView.showCloseButton = YES;
            UINavigationController *joinNavigation = [[UINavigationController alloc] initWithRootViewController:joinView];
            [self presentViewController:joinNavigation animated:YES completion:nil];
        }
    } else if ([bannerDict[@"banner_type"] isEqualToString:@"JackpotHome"]){
        
        JackpotHomePageViewController *jackpotHomePage = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotHomePageView"];
        jackpotHomePage.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jackpotHomePage animated:YES];
        
    } else if ([bannerDict[@"banner_type"] isEqualToString: @"JackpotOffer"]){
        
        NSString *couponId = bannerDict[@"jackpot_coupon_template_id"];
        
        if (couponId && ![couponId isEqualToString:@""]) {
            FZCoupon *coupon = [FZData getCouponById:couponId];
            if (coupon) {
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
        
    } else if ([bannerDict[@"banner_type"] isEqualToString: @"JackpotGeneric"]){
        
        NSArray *couponIds = bannerDict[@"jackpot_coupon_templates"];
        if (couponIds && couponIds.count > 0 && [FZData sharedInstance].coupons && [FZData sharedInstance].coupons.count > 0) {
            
            if (couponIds.count == 1) {
                
                NSString *couponId = [couponIds objectAtIndex:0];
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
                
            } else {
                
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
                    if (bannerDict[@"title"] && ![bannerDict[@"title"] isKindOfClass:[NSNull class]]) {
                        jackpotView.titleString = bannerDict[@"title"];
                    }
                    jackpotView.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:jackpotView animated:YES];
                }
            }
            
        }
        
    }  else if ([bannerDict[@"banner_type"] isEqualToString: @"PowerUpPacks"]){
        
        if ([FZData getPowerUpPacks].count > 0) {
            
            if ([FZData getPowerUpPacks].count == 1) {
                
                PowerUpPackCardViewController *cardView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"PowerUpPackCardView"];
                cardView.coupon = [[FZData getPowerUpPacks] firstObject];
                cardView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cardView animated:YES];
                
                
            } else {
                
                PowerUpPackViewController *powerupPackView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"PowerUpPackView"];
                powerupPackView.coupons = [FZData getPowerUpPacks];
                powerupPackView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:powerupPackView animated:YES];
                
            }
        }
        
    } else if ([bannerDict[@"banner_type"] isEqualToString: @"RedPacket"]){
        
        RedPacketsViewController *redPacketsView = [[GlobalConstants redPacketsStoryboard] instantiateViewControllerWithIdentifier:@"RedPacketsView"];
        redPacketsView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:redPacketsView animated:YES];
        
    } else if ([bannerDict[@"banner_type"] isEqualToString: @"ClubHome"]){
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        FZTabBarViewController *tabController = (FZTabBarViewController*) window.rootViewController;
        tabController.selectedIndex = 2;
        
    } else if ([bannerDict[@"banner_type"] isEqualToString: @"ClubBrand"]){
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        FZTabBarViewController *tabController = (FZTabBarViewController*) window.rootViewController;
        
        NSArray *clubStores = bannerDict[@"club_brand_stores"];
        if (clubStores.count > 0) {
            
            UINavigationController *navController = [[tabController viewControllers] objectAtIndex:2];
            
            if (clubStores.count != 1) {
                
                ClubStoreViewController *storeView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubStoreView"];
                storeView.dict = [clubStores firstObject];
                storeView.hidesBottomBarWhenPushed = YES;
                [navController pushViewController:storeView animated:YES];
                
            } else {
                
                ClubStoreLocationViewController *locationView = [[GlobalConstants clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubStoreLocationView"];
                locationView.clubStores = clubStores;
                locationView.showStore = YES;
                locationView.hidesBottomBarWhenPushed = YES;
                [navController pushViewController:locationView animated:YES];
            }
        }
        
        tabController.selectedIndex = 2;
        
    } else if ([bannerDict[@"banner_type"] isEqualToString: @"ClubOffer"]){
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        FZTabBarViewController *tabController = (FZTabBarViewController*) window.rootViewController;
        tabController.selectedIndex = 2;
    }
    
}

#pragma mark - BrandListTableViewCellDelegate


- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state {
    [self likeBrand:brand withState:state];
}

- (void)brandWasClicked:(FZBrand *)brand type:(BrandListTableViewCellType)type{
    
    if (type == BrandListTableViewCellTypeNew || type == BrandListTableViewCellTypeTop || type == BrandListTableViewCellTypeClub) {
        
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

- (void)goNormalBrand:(FZBrand*)brand{
    
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
        
    }
}

- (void)viewAllWasClickedForTitle:(BrandListTableViewCellType)type {
    
    BrandListViewController *brandListView = [self.storyboard instantiateViewControllerWithIdentifier:@"BrandListView"];
    
    if (type == BrandListTableViewCellTypeRecommended) {
        brandListView.headerTitle = @"RECOMMENDED";
        brandListView.brandArray = [FZData sharedInstance].recommendedBrandArray;
        brandListView.showFilter= YES;
    } else if (type == BrandListTableViewCellTypeClub) {
        brandListView.headerTitle = @"CLUB BRANDS";
        brandListView.brandArray = [FZData sharedInstance].clubBrandArray;
        brandListView.showFilter = NO;
    } else if (type == BrandListTableViewCellTypeTrending) {
        brandListView.headerTitle = @"TRENDING BRANDS";
        brandListView.brandArray = [FZData sharedInstance].popularBrandArray;
        brandListView.showFilter = YES;
    } else if(type == BrandListTableViewCellTypeTop){
        brandListView.headerTitle = @"TOP BRANDS";
        brandListView.brandArray = [FZData sharedInstance].topArray;
        brandListView.showFilter= NO;
    } else if (type == BrandListTableViewCellTypeNew){
        brandListView.headerTitle = @"NEW BRANDS";
        brandListView.brandArray = [FZData sharedInstance].latestBrandArray;
        brandListView.showFilter= NO;
    } else {
        
    }
    
    brandListView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:brandListView animated:YES];
}

#pragma mark - CategoryListTableViewCellDelegate

- (void)categoryWasClicked:(NSDictionary *)categoryDict {
    
    BrandListViewController *brandListView = [self.storyboard instantiateViewControllerWithIdentifier:@"BrandListView"];
    brandListView.headerTitle = categoryDict[@"name"];
    brandListView.brandArray = categoryDict[@"brands"];
    brandListView.showFilter= YES;
    brandListView.isCategory = YES;
    brandListView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:brandListView animated:YES];
}

- (void)viewAllCategoryWasClicked {
    
    UIViewController *categoryView = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryView"];
    categoryView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:categoryView animated:YES];
}

#pragma mark - UpcomingBirthdayTableViewCellDelegate
- (void)userWasClicked:(FZUser *)userInfo{
    [self performSegueWithIdentifier:@"pushToUserProfile" sender:@{@"userInfo":userInfo}];
}

- (void)moreButtonClicked{
    FriendsListViewController *friendsListView = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsListView"];
    friendsListView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendsListView animated:YES];
}

- (void)facebookConnectClicked{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithReadPermissions:@[@"public_profile",@"email",@"user_friends",@"user_birthday"]fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            
            [self showErrorAlertTitle:@"Error" message:[error localizedDescription] buttonTitle:@"OK"];
        } else{
                        
            [[APIClient sharedInstance] setFacebookToken:[FBSDKAccessToken currentAccessToken].tokenString];

            [UserController getFacebookLinkedFuzzieUsers:^(NSArray *array, NSError *error) {
                
                if (error) {
                    if (error.code == 417) {
                        [AppDelegate logOut];
                    }
                } else{
                    
                    [FZData sharedInstance].goFriendsListFromHome = true;
                    [UserController sharedInstance].currentUser.facebookId = [FBSDKAccessToken currentAccessToken].userID;
                    
                    FriendsListViewController *friendsListView = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsListView"];
                    friendsListView.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:friendsListView animated:YES];
                    
                }
                
            }];
        }
    }];
}

#pragma mark - HomeJackpotTableViewCellDelegate
- (void)liveDrawButtonPressed{

    UIViewController *liveView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLiveDrawView"];
    liveView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:liveView animated:YES];
}

- (void)jackpotEnterButtonPressed{

    JackpotHomePageViewController *jackpotHomePage = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotHomePageView"];
    jackpotHomePage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jackpotHomePage animated:YES];
    
}

- (void)jackpotViewAllButtonPressed{

    JackpotDrawHistoryViewController *drawView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotDrawHistoryView"];
    drawView.hidesBottomBarWhenPushed = YES;
    drawView.showLastResult = true;
    [self.navigationController pushViewController:drawView animated:YES];
}

#pragma mark - HomeJackpotTeasingTableViewCellDelegate
- (void)jackpotLearnMoreButtonPressed{

    JackpotLearnMoreViewController *learnMoreView = [[GlobalConstants jackpotStoryboard] instantiateViewControllerWithIdentifier:@"JackpotLearnMoreView"];
    learnMoreView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:learnMoreView animated:YES];
    
}

#pragma mark - Helper Functions

- (void)loadHomeDataWithRefresh:(BOOL)refresh {
    
    [BrandController getHomeWithRefresh:refresh withSuccess:^(NSDictionary *dictionary, NSError *error) {
        
        [self hideLoaderFromWindow];
        
        [FZData sharedInstance].isHomeLoading = false;
        
        [self.refreshControl endRefreshing];
        
        if (error && error.code == 417) {
            [AppDelegate logOut];
            return ;
        }
        
        if (error) {
            if (![FZData sharedInstance].brandArray) {
                [self showEmptyView];
            }
        }
        
        if (dictionary) {
            [self hideEmptyView];

            if (dictionary[@"banners"]) {
                [FZData sharedInstance].bannerArray = dictionary[@"banners"];
            }
            
            if (dictionary[@"fuzzie_friends"]) {
                NSArray *friends = dictionary[@"fuzzie_friends"];
                NSMutableArray *friendsArray = [NSMutableArray new];
                for (NSDictionary *friendDict in friends) {
                    NSError *error = nil;
                    FZUser *user = [MTLJSONAdapter modelOfClass:FZUser.class fromJSONDictionary:friendDict error:&error];
                    int i = rand()%7+1;
                    user.bearAvatar = [NSString stringWithFormat:@"avatar-bear-%i", i];
                    
                    if (error) {
                        DDLogError(@"FZBrand Error: %@", [error localizedDescription]);
                    } else if (user) {
                        [friendsArray addObject:user];
                    }
                }
                
                [[FZData sharedInstance] setFuzzieFriends:friendsArray];
                
                [[FZLocalNotificationManager sharedInstance] scheduleFriendsBirthdayNotification];
            }
            
            if (dictionary[@"brands"]) {
                NSArray *brands = dictionary[@"brands"];
                NSMutableArray *brandArray = [NSMutableArray new];
                for (NSDictionary *brandDict in brands) {
                    NSError *error = nil;
                    FZBrand *brand = [MTLJSONAdapter modelOfClass:FZBrand.class fromJSONDictionary:brandDict error:&error];
                    if (error) {
                        DDLogError(@"FZBrand Error: %@", [error localizedDescription]);
                    } else if (brand) {
                        [brandArray addObject:brand];
                    }
                }
                
                for (FZBrand *brand in brandArray) {
                    if (brand.parentBrandId) {
                        for (FZBrand *searchBrand in brandArray) {
                            if ([searchBrand.brandId isEqualToString:brand.parentBrandId]) {
                                brand.parentBrand = searchBrand;
                                break;
                            }
                        }
                    }
                }
                
                [FZData sharedInstance].brandArray = brandArray;
                [FZData sharedInstance].brandSet = [[NSSet alloc] initWithArray:brandArray];
                
                [self loadCoupons];
                
                if (![FZData sharedInstance].activeGiftBox) {
                   
                    [GiftController getActiveGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:true with:^(NSArray *array, NSError *error) {
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_GIFTBOX_REFRESHED object:nil];
                        }
                    }];
                    
                } else{
                    [[FZTimer sharedInstance] startTimer];
                }
                
                if (![FZData sharedInstance].usedGiftBox) {
                    
                    [GiftController getUsedGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:true with:^(NSArray *array, NSError *error) {
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:USED_GIFTBOX_REFRESHED object:nil];
                        }
                    }];
                    
                }
                
                if (![FZData sharedInstance].sentGiftBox) {
                    
                    [GiftController getSentGiftBox:1 withOffset:GIFT_BOX_PAGINGATION_COUNT withRefresh:true with:^(NSArray *array, NSError *error) {
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:SENT_GIFTBOX_REFRESHED object:nil];
                        }
                    }];
                    
                }
                
                [self loadJackpotResult];
            }
            
            if (dictionary[@"categories"]) {
                NSArray *categoryArray = dictionary[@"categories"];
                NSMutableArray *populatedCategoryArray = [NSMutableArray new];
                
                for (NSDictionary *categoryDict in categoryArray) {
                    
                    NSMutableDictionary *mutableCategoryDict = [categoryDict mutableCopy];
                    NSArray *brandIdArray = categoryDict[@"brands"];
                    NSMutableArray *brandsArray = [NSMutableArray new];
                    
                    for (NSString *brandId in brandIdArray) {
                        for (NSInteger i = 0; i < [FZData sharedInstance].brandArray.count; i ++) {
                            FZBrand *brand = [FZData sharedInstance].brandArray[i];
                            if ([brand.brandId isEqualToString:brandId]) {
                                [brandsArray addObject:brand];
                                break;
                            }
                        }
                    }
                    
                    mutableCategoryDict[@"brands"] = brandsArray;
                    [populatedCategoryArray addObject:mutableCategoryDict];
                }
                
                [FZData sharedInstance].categoryArray = populatedCategoryArray;
            }
            
            if (dictionary[@"sub_categories"]) {
                [FZData sharedInstance].subCategoryArray = dictionary[@"sub_categories"];
            }
            
            if (dictionary[@"recommended_brands"]) {
                NSArray *idArray = dictionary[@"recommended_brands"];
                NSMutableArray *recommendedArray = [NSMutableArray new];
                
                for (NSString *brandId in idArray) {
                    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"brandId LIKE[cd] %@", brandId];
                    NSArray *brandArray = [[FZData sharedInstance].brandArray filteredArrayUsingPredicate:predicate];
                    
                    if (brandArray.count > 0) {
                        [recommendedArray addObject:brandArray.firstObject];
                    }
                }
                
                [FZData sharedInstance].recommendedBrandArray = recommendedArray;
            }
            
            if (dictionary[@"popular_brands"]) {
                
                NSArray *idArray = dictionary[@"popular_brands"];
                NSMutableArray *popularArray = [NSMutableArray new];
                
                for (NSString *brandId in idArray) {
                    
                    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"brandId LIKE[cd] %@", brandId];
                    NSArray *brandArray = [[FZData sharedInstance].brandArray filteredArrayUsingPredicate:predicate];
                    
                    if (brandArray.count > 0) {
                        [popularArray addObject:brandArray.firstObject];
                    }
                }
                
                [FZData sharedInstance].popularBrandArray = popularArray;
            }
            
            if (dictionary[@"club_brands"]) {
                
                NSArray *array = dictionary[@"club_brands"];
                NSMutableArray *latestArray = [NSMutableArray new];
                
                for (NSDictionary *newDict in array) {
                    
                    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"brandId LIKE[cd] %@", newDict[@"brand_id"]];
                    NSArray *brandArray = [[FZData sharedInstance].brandArray filteredArrayUsingPredicate:predicate];
                    
                    if (brandArray.count > 0) {
                        FZBrand *brand = [brandArray.firstObject copy];
                        brand.brandLink = newDict[@"link_to"];
                        [latestArray addObject:brand];
                    }
                }
                
                [FZData sharedInstance].clubBrandArray = latestArray;
                
            }
            
            if (dictionary[@"new_brands"]) {
                
                NSArray *array = dictionary[@"new_brands"];
                NSMutableArray *latestArray = [NSMutableArray new];
                
                for (NSDictionary *newDict in array) {
                    
                    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"brandId LIKE[cd] %@", newDict[@"brand_id"]];
                    NSArray *brandArray = [[FZData sharedInstance].brandArray filteredArrayUsingPredicate:predicate];
                    
                    if (brandArray.count > 0) {
                        FZBrand *brand = [brandArray.firstObject copy];
                        brand.brandLink = newDict[@"link_to"];
                        [latestArray addObject:brand];
                    }
                }
                
                [FZData sharedInstance].latestBrandArray = latestArray;
                
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
                
                [FZData sharedInstance].topArray = topArray;
            }
            
            if (dictionary[@"mini_banner_positions"]) {
                //NSLog(@"%@",dictionary[@"mini_banner_positions"]);
            }
            
            if (dictionary[@"mini_banners"]) {
                [FZData sharedInstance].miniBannerArray = dictionary[@"mini_banners"];
            }
            
            if (dictionary[@"banks_uploaded"]) {
                [FZData sharedInstance].bankUploaded = [dictionary[@"banks_uploaded"] boolValue];
            }
            
            if (dictionary[@"jackpot"][@"draw_id"]) {
                [FZData sharedInstance].jackpotDrawId = dictionary[@"jackpot"][@"draw_id"];
                
                if(![dictionary[@"jackpot"][@"draw_id"] isKindOfClass:[NSNull class]])
                [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"jackpot"][@"draw_id"] forKey:JACKPOT_DRAW_ID];
            }
            
            if (dictionary[@"jackpot"][@"draw_time"]) {
                [FZData sharedInstance].jackpotDrawTime = dictionary[@"jackpot"][@"draw_time"];
            }
 
            if (dictionary[@"jackpot"][@"next_draw_time"]) {
                [FZData sharedInstance].jackpotNextDrawTime = dictionary[@"jackpot"][@"next_draw_time"];
            }
            
            if (dictionary[@"jackpot"][@"enabled"]) {
                [FZData sharedInstance].enableJackpot = [dictionary[@"jackpot"][@"enabled"] boolValue];
            }
            
            if (dictionary[@"jackpot"][@"draw_state"]) {
                [FZData sharedInstance].isLiveDraw = [dictionary[@"jackpot"][@"draw_state"] boolValue];
            }
            
            if (dictionary[@"jackpot"][@"number_of_tickets_per_week"]) {
                [FZData sharedInstance].ticketsLimitPerWeek = [dictionary[@"jackpot"][@"number_of_tickets_per_week"] intValue];
            }
            
            if (dictionary[@"jackpot_tickets_to_be_given_with_red_packet_bundle"]) {
                [FZData sharedInstance].assignedTicketsCountWithRedPacketBundle = dictionary[@"jackpot_tickets_to_be_given_with_red_packet_bundle"];
            }
            
            if ([[UserController sharedInstance].currentUser.jackpotDrawNotification boolValue] && [FZData sharedInstance].enableJackpot && [FZData sharedInstance].jackpotDrawTime) {
                [[FZLocalNotificationManager sharedInstance] scheduleLiveDrawNotification];
            }
            
            if ([FZData sharedInstance].enableJackpot && [FZData sharedInstance].jackpotDrawTime) {
                  [[FZLocalNotificationManager sharedInstance] scheduleJackpotRemainderNotification];
            }
            
//            if ([[UserController sharedInstance].currentUser.showClubInstructions  isEqual: @(1)]) {
//                [self showCoachMarkerView];
//                [self updateCoachMarkerDisplayState];
//            }
        }
        
        [self.tableView reloadData];
        
    }];

}

- (void)loadCoupons{
    
    [JackpotController getCouponTemplate:^(NSDictionary *dictionary, NSError *error) {
        
        if (dictionary) {
            
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (NSDictionary *couponDict in dictionary[@"coupons"]) {
                NSError *error = nil;
                FZCoupon *coupon = [MTLJSONAdapter modelOfClass:FZCoupon.class fromJSONDictionary:couponDict error:&error];
                if (error) {
                    DDLogError(@"FZCoupon Error: %@", [error localizedDescription]);
                } else if (coupon) {
                    
                    if (coupon.powerUpPack) {
                        
                        coupon.brandName = @"Fuzzie";
                        coupon.subcategoryId = [NSNumber numberWithInteger:32];
                        
                    } else {
                        
                        FZBrand *brand = [FZData getBrandById:coupon.brandId];
                        if (brand) {
                            coupon.brandName = brand.name;
                            coupon.subcategoryId = brand.subcategoryId;
                        }
                        
                    }
        
                    double pricePerTicket = ([coupon.priceValue doubleValue] - [coupon.cashbackValue doubleValue]) / [coupon.ticketCount intValue];
                    coupon.pricePerTicket = [NSNumber numberWithDouble:pricePerTicket];
                    
                    [temp addObject:coupon];
                }
            }
            
            [FZData sharedInstance].coupons = temp;
        }
    }];
}

- (void)loadHomeData {
    [self showLoaderToWindow];
    [FZData sharedInstance].isHomeLoading = true;
    [self loadHomeDataWithRefresh:NO];
    [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
        [AppDelegate updateWalletBadge];
    }];
}

- (void)refreshHomeData {

    [UserController getUserProfileWithCompletion:^(FZUser *user, NSError *error) {
        [AppDelegate updateWalletBadge];
    }];
    [self loadHomeDataWithRefresh:YES];
    if ([UserController sharedInstance].currentUser.facebookId) {
        [self loadFacebookFriends];
    }
}

- (void)setStyling {
        
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
    UINib *FuzzieCreditsTableViewCellNib = [UINib nibWithNibName:@"FuzzieCreditsTableViewCell" bundle:nil];
    [self.tableView registerNib:FuzzieCreditsTableViewCellNib forCellReuseIdentifier:@"FuzzieCreditsCell"];
    
    UINib *bannerSliderCell = [UINib nibWithNibName:@"BannerSliderCell" bundle:nil];
    [self.tableView registerNib:bannerSliderCell forCellReuseIdentifier:@"BannerSliderCell"];

    UINib *miniBannerCell = [UINib nibWithNibName:@"MiniBannerCell" bundle:nil];
    [self.tableView registerNib:miniBannerCell forCellReuseIdentifier:@"MiniBannerCell"];
    
    UINib *brandListCellNib = [UINib nibWithNibName:@"BrandListTableViewCell" bundle:nil];
    [self.tableView registerNib:brandListCellNib forCellReuseIdentifier:@"BrandListCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 270.0f;
    
    UINib *upcomingCellNib = [UINib nibWithNibName:@"UpcomingBirthdayTableViewCell" bundle:nil];
    [self.tableView registerNib:upcomingCellNib forCellReuseIdentifier:@"UpcomingBirthdayCell"];
    
    UINib *jackpotCellNib = [UINib nibWithNibName:@"HomeJackpotTableViewCell" bundle:nil];
    [self.tableView registerNib:jackpotCellNib forCellReuseIdentifier:@"JackpotCell"];
    
    UINib *jackpotTeasingCellNib = [UINib nibWithNibName:@"HomeJackpotTeasingTableViewCell" bundle:nil];
    [self.tableView registerNib:jackpotTeasingCellNib forCellReuseIdentifier:@"JackpotTeasingCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshHomeData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    
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
                
                if (self.powerUpView.hidden == NO) { // Previously active. now not active. Refresh Data
                    [self refreshHomeData];
                }
                self.powerUpViewHeightConstraint.constant = 0.0f;
                self.powerUpView.hidden = YES;
            }

        } else {
            self.powerUpViewHeightConstraint.constant = 0.0f;
            self.powerUpView.hidden = YES;
        }
    } repeats:YES];
    
    UINib *coachNib = [UINib nibWithNibName:@"FZCoachMarkView" bundle:nil];
    self.coachMarkerView = [[coachNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    [CommonUtilities setView:self.btnRefresh withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    [AppDelegate updateWalletBadge];
    
}

- (void)showEmptyView{
    self.emptyView.hidden = NO;
    self.tableView.hidden = YES;
}

- (void)hideEmptyView{
    self.emptyView.hidden = YES;
    self.tableView.hidden = NO;
    
}

- (void)showCoachMarkerView{
    if (![self.coachMarkerView isDescendantOfView:self.window]) {
        [self.window addSubview:self.coachMarkerView];
        self.coachMarkerView.frame = self.window.frame;
        self.coachMarkerView.delegate = self;
    }
}

- (void)hideCoachMarkerView{
    if (self.coachMarkerView != nil && [self.coachMarkerView isDescendantOfView:self.window]) {
        [self.coachMarkerView removeFromSuperview];
    }
}

#pragma FZCoachMarkViewDelegate
- (void)coachMarkerTapped{
    [self hideCoachMarkerView];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
        FZTabBarViewController *tabController = (FZTabBarViewController*) window.rootViewController;
        tabController.selectedIndex = 2;
    }
    
}

- (void)coachMarkerViewTapped{
    [self hideCoachMarkerView];
}

- (void)updateCoachMarkerDisplayState{
    [UserController sharedInstance].currentUser.showClubInstructions = @(NO);
    [UserController setCoachMarkerDisplay:NO withErrorBlock:^(NSError *error) {
        if (error) {
            [UserController sharedInstance].currentUser.showClubInstructions = @(YES);
        }
        
    }];
}

- (void)loadBagInfo {
    [GiftController getShoppingBagWithCompletion:^(NSDictionary *dictionary, NSError *error) {
        if (error && error.code == 417) {
            [AppDelegate logOut];
            return ;
        } else{
            [self updateBagCount];
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

- (void)loadFacebookFriends{
    [UserController getFacebookFriends:^(NSArray *array, NSError *error) {
        if (error && error.code == 417) {
            [AppDelegate logOut];
            return ;
        }
    }];
}

- (void)loadJackpotResult{
    
    [JackpotController getJackpotResult:^(NSDictionary *dictionary, NSError *error) {
        if (dictionary) {
            [FZData sharedInstance].jackpotResult = dictionary;
            [[NSNotificationCenter defaultCenter] postNotificationName:JACKPOT_RESULT_REFRESHED object:nil];
        }
    }];
    
}

- (void)requestPushNotificationPermission {
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionBadge + UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (granted) {
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                           [[UIApplication sharedApplication] registerForRemoteNotifications];
                                      });
                                  }
                              }];
    }
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
    
    if ([segue.identifier isEqualToString:@"pushToUserProfile"]) {
        if ([segue.destinationViewController isKindOfClass:[UserProfileViewController class]]) {
            UserProfileViewController *userProfileViewController = (UserProfileViewController *)segue.destinationViewController;
            userProfileViewController.hidesBottomBarWhenPushed = YES;
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

#pragma mark - Jackpot Live Draw Start / End
- (void)liveDrawStart{
    [FZData sharedInstance].isLiveDraw = true;
    [self.tableView reloadData];
}

- (void)liveDrawEnd{
    [FZData sharedInstance].isLiveDraw = false;
    [self refreshHomeData];
}

#pragma mark - Check Redeeming Timer
- (void)checkRedeeming{
    [[FZTimer sharedInstance] checkRedeeming];
}

@end
