//
//  ClubStoreViewController.m
//  Fuzzie
//
//  Created by joma on 6/11/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreViewController.h"
#import "ClubStoreTopTableViewCell.h"
#import "ClubStoreStateTableViewCell.h"
#import "ClubStoreInfoTableViewCell.h"
#import "ClubStoreOtherLinkTableViewCell.h"
#import "TripAdvisorBrandTableViewCell.h"
#import "ClubStoreFinPrintTableViewCell.h"
#import "ClubStoreTableViewCell.h"
#import "ClubStoreOfferTableViewCell.h"
#import "ClubStoreLocationViewController.h"
#import "AboutBrandTableViewCell.h"
#import "FZWebView2Controller.h"
#import "ClubOfferViewController.h"
#import "ClubStoreListViewController.h"
#import "UIView+Toast.h"

@import MapKit;

typedef enum : NSUInteger {
    kClubStoreSectionTop,
    kClubStoreSectionLocation,
    kClubStoreSectionOffer,
    kClubStoreSectionAboutBrand,
    kClubStoreSectionInfo,
    kClubStoreSectionMoreLocation,
    kClubStoreSectionGrab,
    kClubStoreSectionQuandoo,
    kClubStoreSectionTripAdvisor,
    kClubStoreSectionRelatedStores,
    kClubStoreSectionNearStores,
    kClubStoreSectionCount,
    kClubStoreSectionFinePrint
} kClubStoreSection;

@interface ClubStoreViewController () <UITableViewDataSource, UITableViewDelegate, ClubStoreStateTableViewCellDelegate, ClubStoreOfferTableViewCellDelegate, AboutBrandTableViewCellDelegate, TripAdvisorBrandTableViewCellDelegate, ClubStoreTableViewCellDelegate, ClubStoreLocationViewControllerDelegate, ClubStoreOtherLinkTableViewCellDelegate, ClubStoreInfoTableViewCellDelegate, ClubStoreTopTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundNav;
@property (weak, nonatomic) IBOutlet UIButton *btnReferral;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)referralButtonPressed:(id)sender;

@property (assign, nonatomic) int heightAboutBrand;

@end

@implementation ClubStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clubHomeLoaded) name:CLUB_HOME_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clubHomeLoadFailed) name:CLUB_HOME_LOAD_FAILED object:nil];
    
    [self initData];
    [self setStyling];
}

- (void)initData{
    
    self.brand = [FZData getBrandById:self.dict[@"brand_id"]];
    self.store = [FZData getStoreById:self.dict[@"store_id"]];
    self.offers = self.dict[@"offers"];
    self.isOnline = [self.dict[@"online_brand"] boolValue];
    
    if (!self.brand || !self.store) return;
    
    self.showTripAdvisor = self.brand.tripadvisorLink && ![self.brand.tripadvisorLink isEqualToString:@""] && self.brand.tripadvisorReviewCount && [self.brand.tripadvisorReviewCount intValue] > 0;
    
    [self loadClubStoreDetails];
}

- (void)setStyling{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *topNib = [UINib nibWithNibName:@"ClubStoreTopTableViewCell" bundle:nil];
    [self.tableView registerNib:topNib forCellReuseIdentifier:@"TopCell"];
    
    UINib *stateNib = [UINib nibWithNibName:@"ClubStoreStateTableViewCell" bundle:nil];
    [self.tableView registerNib:stateNib forCellReuseIdentifier:@"StateCell"];
    
    UINib *infoNib = [UINib nibWithNibName:@"ClubStoreInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:infoNib forCellReuseIdentifier:@"InfoCell"];
    
    UINib *otherLinkNib = [UINib nibWithNibName:@"ClubStoreOtherLinkTableViewCell" bundle:nil];
    [self.tableView registerNib:otherLinkNib forCellReuseIdentifier:@"LinkCell"];
    
    UINib *TripAdvisorBrandNib = [UINib nibWithNibName:@"TripAdvisorBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:TripAdvisorBrandNib forCellReuseIdentifier:@"TripAdvisorBrandCell"];
    
    UINib *finePrintNib = [UINib nibWithNibName:@"ClubStoreFinPrintTableViewCell" bundle:nil];
    [self.tableView registerNib:finePrintNib forCellReuseIdentifier:@"FinePrintCell"];
    
    UINib *storeNib = [UINib nibWithNibName:@"ClubStoreTableViewCell" bundle:nil];
    [self.tableView registerNib:storeNib forCellReuseIdentifier:@"StoreCell"];
    
    UINib *offerNib = [UINib nibWithNibName:@"ClubStoreOfferTableViewCell" bundle:nil];
    [self.tableView registerNib:offerNib forCellReuseIdentifier:@"OfferCell"];
    
    UINib *aboutBrandCellNib = [UINib nibWithNibName:@"AboutBrandTableViewCell" bundle:nil];
    [self.tableView registerNib:aboutBrandCellNib forCellReuseIdentifier:@"AboutBrandCell"];
    self.heightAboutBrand = 150;
    
    self.lbTitle.text = [self.brand.name uppercaseString];

}

- (void)loadClubStoreDetails{
    
    [ClubController getClubStoreDetail:self.dict[@"id"] completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (dictionary) {
            
            self.relatedStores = dictionary[@"related_stores"];
            self.nearbyStores = dictionary[@"nearby_stores"];
            
            NSMutableArray *tempStores = [[NSMutableArray alloc] initWithArray:dictionary[@"more_stores"]];
            [tempStores insertObject:self.dict atIndex:0];
            self.moreStores = tempStores;
            
            [self.tableView reloadData];
        }
    }];
}

- (void)clubHomeLoaded{
    
    [self.tableView reloadData];
    
}

- (void)clubHomeLoadFailed{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kClubStoreSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
            
        case kClubStoreSectionLocation:{
            if (!self.isOnline) {
                return 1;
            } else {
                return 0;
            }
            break;
        }
        case kClubStoreSectionTripAdvisor:{
            if (self.showTripAdvisor) {
                return 1;
            } else{
                return 0;
            }
            break;
        }
        case kClubStoreSectionMoreLocation:{
            if (!self.isOnline && self.moreStores.count > 0) {
                return 1;
            } else {
                return 0;
            }
            break;
        }
        case kClubStoreSectionGrab:{
            if (!self.isOnline) {
                return 1;
            } else {
                return 0;
            }
            break;
        }
        case kClubStoreSectionQuandoo:{
            if (!self.isOnline) {
                return 1;
            } else {
                return 0;
            }
            break;
        }
        case kClubStoreSectionInfo:{
            if (!self.isOnline) {
                return 1;
            } else {
                return 0;
            }
            break;
        }
        case kClubStoreSectionNearStores:{
            if (self.nearbyStores.count > 0) {
                return 1;
            } else {
                return 0;
            }
            break;
        }
        case kClubStoreSectionRelatedStores:{
            if (self.relatedStores.count > 0) {
                return 1;
            } else {
                return 0;
            }
            break;
        }
        case kClubStoreSectionFinePrint:
            return 2;
            break;
        case kClubStoreSectionOffer:
            return self.offers.count;
            break;
        default:
            return 1;
            break;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case kClubStoreSectionAboutBrand:
            return self.heightAboutBrand;
            break;
        case kClubStoreSectionOffer:
            return 105.0f;
            break;
        case kClubStoreSectionRelatedStores:
            return 280.0f;
            break;
        case kClubStoreSectionNearStores:
            return 280.0f;
            break;
        default:
            return UITableViewAutomaticDimension;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case kClubStoreSectionFinePrint:
            return 55.0f;
            break;
        case kClubStoreSectionOffer:
            return 55.0f;
            break;
        default:
            return 0.01f;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    switch (section) {
        case kClubStoreSectionTop:{
            if (self.isOnline) {
                return 10.0f;
            } else {
                return 0.01f;
            }
            break;
        }
        case kClubStoreSectionLocation:{
            if (self.isOnline) {
                return 0.01f;
            } else {
                return 10.0f;
            }
            break;
        }
        case kClubStoreSectionTripAdvisor:
            return 10.0f;
            break;
        case kClubStoreSectionFinePrint:
            return 10.0f;
            break;
        case kClubStoreSectionRelatedStores:{
            if (self.relatedStores.count > 0) {
                return 10.0f;
            } else {
                return 0.01f;
            }
            break;
        }
        case kClubStoreSectionNearStores:{
            if (self.nearbyStores.count > 0) {
                return 10.0f;
            } else {
                return 0.01f;
            }
            break;
        }
        case kClubStoreSectionOffer:
            return 10.0f;
            break;
        default:
            return 0.01f;
            break;
    }

}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case kClubStoreSectionTop:{
            
            ClubStoreTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell"];
            [cell initSliderIfNeeded];
            [cell setCell:self.brand dict:self.dict];
            cell.bottomSeprator.hidden = !self.isOnline;
            cell.delegate = self;
            return cell;
            break;
        }
        case kClubStoreSectionLocation:{
            
            ClubStoreStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StateCell"];
            [cell setCell:self.dict moreStores:self.moreStores];
            cell.delegate = self;
            return cell;
            break;
        }
        case kClubStoreSectionOffer:{
            
            ClubStoreOfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell"];
            [cell setCell:self.offers[indexPath.row]];
            cell.delegate = self;
            return cell;
            break;
        }
        case kClubStoreSectionAboutBrand:{
            
            AboutBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutBrandCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.topSeparator.hidden = NO;
            cell.bottomSeparator.hidden = YES;
            [cell setAboutBrandTextWithBrand:self.brand];
            return cell;
        }
        case kClubStoreSectionInfo:{
            
            ClubStoreInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            [cell setCell:self.store];
            cell.delegate = self;
            return cell;
            break;
        }
        case kClubStoreSectionMoreLocation:{
            
            ClubStoreOtherLinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell"];
            [cell setCellWithType:kLinkTypMoreLocation];
            cell.lbType.text = [NSString stringWithFormat:@"%ld more store locations", self.moreStores.count];
            cell.separatorLeftMargin.constant = 15.0f;
            cell.delegate = self;
            return cell;
            break;
        }
        case kClubStoreSectionGrab:{
            
            ClubStoreOtherLinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell"];
            [cell setCellWithType:kLinkTypeGrab];
            cell.separatorLeftMargin.constant = 15.0f;
            cell.delegate = self;
            return cell;
            break;
        }
        case kClubStoreSectionQuandoo:{
            
            ClubStoreOtherLinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell"];
            [cell setCellWithType:kLinkTypeQuandoo];
            if (self.showTripAdvisor) {
                cell.separatorLeftMargin.constant = 15.0f;
            } else{
                cell.separatorLeftMargin.constant = 0.0f;
            }
            cell.delegate = self;
            return cell;
            break;
        }
        case kClubStoreSectionTripAdvisor:{
            
            TripAdvisorBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripAdvisorBrandCell"];
            if (self.brand.tripadvisorLink) {
                [cell getTripAdvisorInfoWithBrandId:self.brand];
                cell.delegate = self;
            }
            return cell;
            break;
        }
        case kClubStoreSectionFinePrint:{
            
            ClubStoreFinPrintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FinePrintCell"];
            return cell;
            break;
        }
        case kClubStoreSectionRelatedStores:{
            
            ClubStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            cell.lbType.text = @"NEAR THIS STORES";
            [cell setCellWithStores:self.relatedStores];
            cell.delegate = self;
            return cell;
        }
        case kClubStoreSectionNearStores:{
            
            ClubStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            cell.lbType.text = @"RELATED STORES";
            [cell setCellWithStores:self.nearbyStores];
            cell.delegate = self;
            return cell;
        }
        default:
            return nil;
            break;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case kClubStoreSectionFinePrint:{
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 55)];
            [view setBackgroundColor:[UIColor whiteColor]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, tableView.frame.size.width, 20)];
            [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:14]];
            [label setText:@"FINE PRINT"];
            [label setTextColor:[UIColor colorWithHexString:@"262626"]];
            [view addSubview:label];
            
            UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
            [topSeparator setBackgroundColor:[UIColor colorWithHexString:@"E4E4E4"]];
            [view addSubview:topSeparator];
            
            return view;
            break;
        }
        case kClubStoreSectionOffer:{
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 55)];
            [view setBackgroundColor:[UIColor whiteColor]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, tableView.frame.size.width, 20)];
            [label setFont:[UIFont fontWithName:FONT_NAME_BLACK size:14]];
            [label setText:@"OFFERS AVAILABLE"];
            [label setTextColor:[UIColor colorWithHexString:@"262626"]];
            [view addSubview:label];
            
            UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
            [topSeparator setBackgroundColor:[UIColor colorWithHexString:@"E4E4E4"]];
            [view addSubview:topSeparator];
            
            UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 54, tableView.frame.size.width, 1)];
            [bottomSeparator setBackgroundColor:[UIColor colorWithHexString:@"E4E4E4"]];
            [view addSubview:bottomSeparator];
            
            return view;
            break;
        }
        default:
            return nil;
            break;
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

#pragma mark - ClubStoreTopTableViewCellDelegate
- (void)bookmarkPressed:(BOOL)bookmarked{
    
    if (bookmarked) {
        
        [self.view makeToast:@"Store added to your favorites"
                    duration:1.0
                    position:CSToastPositionBottom];
        
    } else {
        
        [self.view makeToast:@"Store removed from your favorites"
                    duration:1.0
                    position:CSToastPositionBottom];
    }
}

#pragma mark - ClubStoreStateTableViewCellDelegate
- (void)moreButtonPressed{
    
    ClubStoreLocationViewController *locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreLocationView"];
    locationView.clubStores = self.moreStores;
    locationView.delegate = self;
    [self.navigationController pushViewController:locationView animated:YES];

}

#pragma mark - ClubStoreOfferTableViewCellDelegate
- (void)clubStoreOfferCellTapped:(NSDictionary *)offer{
    
    ClubOfferViewController *offerView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubOfferView"];
    offerView.offer = offer;
    offerView.clubStore = self.dict;
    offerView.moreStores = self.moreStores;
    [self.navigationController pushViewController:offerView animated:YES];
}

#pragma mark - AboutBrandTableViewCellDelegate
- (void)aboutBrandCell:(UITableViewCell *)aboutBrandCell tappedWithHeightCell:(int)heightCell{
    AboutBrandTableViewCell *aboutBrandTableViewCell = (AboutBrandTableViewCell*) aboutBrandCell;
    self.heightAboutBrand = heightCell;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [aboutBrandTableViewCell expandCellContent];
}

- (void)buttonSocialTapped:(NSInteger)buttonSocialType{
    
}

#pragma mark - TripAdvisorBrandTableViewCellDelegate
- (void)goToTripAdvisorPageWith:(NSString *)URL{
    
    FZWebView2Controller *webView = [[GlobalConstants extraStoryboard] instantiateViewControllerWithIdentifier:@"Webview2"];
    webView.titleHeader = @"TRIPADVISOR";
    webView.URL = URL;
    [self.navigationController pushViewController:webView animated:YES];
 
}

#pragma mark - ClubStoreTableViewCellDelegate
- (void)clubStoreCellTapped:(NSDictionary *)dict flashMode:(BOOL)flashMode{
    
    if (flashMode) {
        
        ClubOfferViewController *offerView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubOfferView"];
        offerView.offer = dict;
        offerView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:offerView animated:YES];
        
    } else {
        
        ClubStoreViewController *storeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreView"];
        storeView.dict = dict;
        storeView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:storeView animated:YES];
    }
}

- (void)viewAllButtonPressed:(NSArray *)array title:(NSString *)title flashMode:(BOOL)flashMode{
    
    ClubStoreListViewController *storeListView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreListView"];
    storeListView.array = array;
    storeListView.titleString = title;
    storeListView.flashMode = flashMode;
    storeListView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:storeListView animated:YES];
}

#pragma mark - ClubStoreLocationViewControllerDelegate
- (void)storeSelected:(NSDictionary *)dict{
    
    self.dict = dict;
    self.store = [FZData getStoreById:self.dict[@"store_id"]];
    self.offers = self.dict[@"offers"];
    
    [self.tableView reloadData];
}

#pragma mark - ClubStoreOtherLinkTableViewCellDelegate
- (void)otherLinkCellTapped:(NSUInteger)linkType{
    
    switch (linkType) {
            
        case kLinkTypMoreLocation:{
            
            ClubStoreLocationViewController *locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreLocationView"];
            locationView.clubStores = self.moreStores;
            locationView.delegate = self;
            [self.navigationController pushViewController:locationView animated:YES];
            
            break;
            
        }
        default:
            break;
    }
}

#pragma mark - ClubStoreInfoTableViewCellDelegate
- (void)callButtonPressed:(FZStore *)store{
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:[store.phone stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)directionButtonPressed:(FZStore *)store{
    
    if (!store.latitude || !store.longitude) {
        return;
    }
    
    CLLocationDistance distance = 10000;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(store.latitude.doubleValue, store.longitude.doubleValue);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance);
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    destination.name = store.address;
    NSDictionary *options = @{MKLaunchOptionsMapSpanKey : [NSValue valueWithMKCoordinateSpan:region.span],
                              MKLaunchOptionsMapCenterKey : [NSValue valueWithMKCoordinate:region.center]
                              };
    [destination openInMapsWithLaunchOptions:options];
    
}
#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)shareButtonPressed:(id)sender {
    
    if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
        
        NSString *body = [NSString stringWithFormat:@"Check out the Fuzzie Club for cool 1-for-1 deals and more from popular restaurants, attractions, spas and online shopping sites. I’m using it to save a lot of money. Use my code to get an extra $10 credits when you subscribe. %@ www.fuzzie.com.sg/club", [UserController sharedInstance].currentUser.clubReferralCode];
        NSArray *activityItems = @[body];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:activityItems applicationActivities:nil];
        
        activityViewController.popoverPresentationController.sourceView = self.view;
        
        [self presentViewController:activityViewController animated:YES completion:nil];
        
    } else{
        
        [self showError:@"Join the Club to activate your referral rewards." headerTitle:@"JOIN THE CLUB" buttonTitle:@"LEARN MORE" image:@"bear-club" window:YES];
        self.popView.btnCancel.hidden = NO;
        [self.popView.btnCancel setTitle:@"Close" forState:UIControlStateNormal];
        
    }

}

- (IBAction)referralButtonPressed:(id)sender {
    
    if ([[UserController sharedInstance].currentUser.clubMember boolValue]) {
        
        UIViewController *inviteView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubInviteView"];
        inviteView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inviteView animated:YES];
        
    }  else{
        
        [self showError:@"Join the Club to activate your referral rewards." headerTitle:@"JOIN THE CLUB" buttonTitle:@"LEARN MORE" image:@"bear-club" window:YES];
        self.popView.btnCancel.hidden = NO;
        [self.popView.btnCancel setTitle:@"Close" forState:UIControlStateNormal];
        
    }

}

#pragma mark - FZPopViewDelegate
- (void)okButtonClicked{
    
    [super okButtonClicked];
    [self goClubSubscribe];
}

- (void)goClubSubscribe{
    
    UIViewController *subscribeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubSubscribeView"];
    [self.navigationController pushViewController:subscribeView animated:YES];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLUB_HOME_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLUB_HOME_LOAD_FAILED object:nil];
}
@end
