//
//  ClubCategoryViewController.m
//  Fuzzie
//
//  Created by joma on 6/24/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubCategoryViewController.h"
#import "ClubStoreTableViewCell.h"
#import "ClubSearchBarTableViewCell.h"
#import "ClubPopularCategoryTableViewCell.h"
#import "ClubSearchViewController.h"
#import "ClubSubCategoryViewController.h"
#import "ClubStoreListViewController.h"
#import "ClubStoreViewController.h"
#import "iCarousel.h"
#import "ClubStoreLocationInfoView.h"
#import "FZLocationSettingView.h"


typedef enum : NSUInteger {
    kSectionSearch,
    kSectionNear,
    kSectionCategory,
    kSectionTrending,
    kSectionNew,
    kSectionCount
} kSection;

@interface ClubCategoryViewController () <UITableViewDelegate, UITableViewDataSource, ClubStoreTableViewCellDelegate, ClubSearchBarTableViewCellDelegate, ClubPopularCategoryTableViewCellDelegate, GMSMapViewDelegate, iCarouselDelegate, iCarouselDataSource, FZLocationSettingViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnMode;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet iCarousel *iCarouel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myLocationButtonBottomConstraint;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)modeButtonPressed:(id)sender;
- (IBAction)locationButtonPressed:(id)sender;

@property (strong, nonatomic) FZLocationSettingView *locationSettingView;

@end

@implementation ClubCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
    [self loadBrandTypeDetail];
    [self loadStoresAndPlaces];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[AppDelegate sharedAppDelegate] startLocationService];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[AppDelegate sharedAppDelegate] stopLocationService];

}

- (void)initData{
    
    NSMutableArray *temp = [NSMutableArray new];
    
    for (NSDictionary *dict in self.clubStores) {
        
        FZStore *store = [FZData getStoreById:dict[@"store_id"]];
        if (store) {
            
            [temp addObject:store];
        }
    }
    
    self.stores = temp;
    [self.iCarouel reloadData];
}

- (void)setStyling{
    
    self.lbTitle.text = [self.brandType[@"name"] uppercaseString];
    
    UINib *searchNib = [UINib nibWithNibName:@"ClubSearchBarTableViewCell" bundle:nil];
    [self.tableView registerNib:searchNib forCellReuseIdentifier:@"SearchCell"];
    
    UINib *storeNib = [UINib nibWithNibName:@"ClubStoreTableViewCell" bundle:nil];
    [self.tableView registerNib:storeNib forCellReuseIdentifier:@"StoreCell"];
    
    UINib *populerNib = [UINib nibWithNibName:@"ClubPopularCategoryTableViewCell" bundle:nil];
    [self.tableView registerNib:populerNib forCellReuseIdentifier:@"PopularCell"];
    
    UINib *nib1 = [UINib nibWithNibName:@"FZLocationSettingView" bundle:nil];
    self.locationSettingView = [[nib1 instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    
    [self updateModeButton];
    
    self.iCarouel.delegate = self;
    self.iCarouel.dataSource = self;
    self.iCarouel.type = iCarouselTypeLinear;
    
}

- (void)loadBrandTypeDetail{
    
    if ([FZData sharedInstance].currentLocation) {
        [[APIClient sharedInstance] setLocation:[FZData sharedInstance].currentLocation];
    }
    
    [self showLoaderToWindow];
    
    [ClubController getBrandTypeDetail:self.brandType[@"id"] completion:^(NSDictionary *dictionary, NSError *error) {
        
        [self hideLoaderFromWindow];
        
        if (dictionary) {
            
            if (dictionary[@"trending_stores"]) {
                
                self.trendingStores = dictionary[@"trending_stores"];
            }
            
            if (dictionary[@"nearby_stores"]) {
                
                self.nearbyStores = dictionary[@"nearby_stores"];
            }
            
            if (dictionary[@"new_stores"]) {
                
                self.freshStores = dictionary[@"new_stores"];
            }
            
            if (dictionary[@"popular_categories"]) {
                
                self.categories = dictionary[@"popular_categories"];
            }
            
            [self.tableView reloadData];
        }
        
        if (error) {
            
            [self showEmptyError:[error localizedDescription] window:NO];
        }
        
    }];
}

- (void)loadStoresAndPlaces{
    
    if ([FZData sharedInstance].currentLocation) {
        [[APIClient sharedInstance] setLocation:[FZData sharedInstance].currentLocation];
    }
    
    [ClubController getClubStores:self.brandType[@"id"] completion:^(NSArray *array, NSError *error) {
        
        if (array) {
            
            self.clubStores = array;
            [self initData];
        }
    }];
    
    [ClubController getClubPlaces:self.brandType[@"id"] completion:^(NSArray *array, NSError *error) {
        
        if (array) {
            
            self.clubPlaces = array;
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case kSectionSearch:
            return 1;
            break;
        case kSectionNear:{
            
            if (self.nearbyStores && self.nearbyStores.count > 0) {
                
                return 1;
                
            } else {
                
                return 0;
            }
            
            break;
        }
        case kSectionCategory:{
            
            if (self.categories && self.categories.count > 0) {
                
                return 1;
                
            } else {
                
                return 0;
            }
            
            break;
        }
        case kSectionTrending:{
            
            if (self.trendingStores && self.trendingStores.count > 0) {
                
                return 1;
                
            } else {
                
                return 0;
            }
            
            break;
        }
        case kSectionNew:{
            
            if (self.freshStores && self.freshStores.count > 0) {
                
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
        case kSectionSearch:
            return 56.0f;
            break;
        case kSectionCategory:{
            float width = ([UIScreen mainScreen].bounds.size.width - 40.0f) / 2;
            float height = width * 90 / 140;
            NSUInteger count = (self.categories.count + 1) / 2;
            return height * count + 10 * (count - 1) + 90;
            break;
        }
        case kSectionNear:
            return 280.0f;
            break;
        case kSectionTrending:
            return 280.0f;
            break;
        case kSectionNew:
            return 280.0f;
            break;
        default:
            return 0.0f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
            
        case kSectionSearch:{
         
            ClubSearchBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
            cell.delegate = self;
            return cell;
            break;
        }
        case kSectionNear:{
            
            ClubStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            [cell setCellWithStores:self.nearbyStores];
            cell.delegate = self;
            cell.lbType.text = @"NEARBY STORES";
            return cell;
            break;
        }
        case kSectionCategory:{
            
            ClubPopularCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopularCell"];
            [cell setCell:self.categories];
            cell.delegate = self;
            return cell;
            break;
        }
        case kSectionTrending:{
            
            ClubStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            [cell setCellWithStores:self.trendingStores];
            cell.delegate = self;
            cell.lbType.text = @"TRENDING";
            return cell;
            break;
        }
        case kSectionNew:{
            
            ClubStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            [cell setCellWithStores:self.freshStores];
            cell.delegate = self;
            cell.lbType.text = @"NEW ON THE CLUB";
            return cell;
            break;
        }
        default:
            return [[UITableViewCell alloc] init];
            break;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {

        case kSectionCategory:{
            
            if (self.categories && self.categories.count > 0) {
                
                return 10.0f;
                
            } else {
                
                return 0.0f;
            }
            
            break;
        }
        case kSectionTrending:{
            
            if (self.trendingStores && self.trendingStores.count > 0) {
                
                return 10.0f;
                
            } else {
                
                return 0.0f;
            }
            
            break;
        }
        case kSectionNew:{
            
            if (self.freshStores && self.freshStores.count > 0) {
                
                return 10.0f;
                
            } else {
                
                return 0.0f;
            }
            
            break;
        }
        default:
            return 0;
            break;
    }
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    return self.clubStores.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    if (view == nil)
    {
        UINib *customNib = [UINib nibWithNibName:@"ClubStoreLocationInfoView" bundle:nil];
        view = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        view.frame = CGRectMake(0, 0, self.view.frame.size.width - 60, 100);
        
    }
    
    if ([view isKindOfClass:[ClubStoreLocationInfoView class]]) {
        
        ClubStoreLocationInfoView *viewItemSlider = (ClubStoreLocationInfoView *)view;
        
        NSDictionary *dict = self.clubStores[index];
        FZStore *store = self.stores[index];
        FZBrand *brand = [FZData getBrandById:dict[@"brand_id"]];
        
        [viewItemSlider setViewWith:dict brand:brand store:store];
        
    }
    
    return view;
    
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.iCarouel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"Tapped view number: %lu", index);
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    
    NSLog(@"Index: %lu", self.iCarouel.currentItemIndex);
    
    if (!self.markerClicked) {
        
        GMSMarker *marker = [self.markers objectAtIndex:carousel.currentItemIndex];
        [self handleMarkerSelect:marker];
    }
    
    self.markerClicked = NO;
}

#pragma mark - GMSMapViewDelegate
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    
    self.isShowInfoView = YES;
    [self updateInfoView];
    
    self.markerClicked = YES;
    [self handleMarkerSelect:marker];
    
    return true;
}

- (void)handleMarkerSelect:(GMSMarker*)marker{
    
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate setTarget:marker.position]];
    
    if (self.previouMarker && marker != self.previouMarker) {
        [self unSelectMarker:self.previouMarker];
    }
    
    if (marker != self.previouMarker) {
        [self selectMarker:marker];
        
        if (self.markerClicked) {
            
            NSNumber *index = marker.userData;
            [self.iCarouel scrollToItemAtIndex:index.integerValue animated:YES];
        }
    }
}

- (void)selectMarker:(GMSMarker*)marker{
    
    if (marker.userData) {
        
        NSNumber *index = marker.userData;
        FZStore *store = [self.stores objectAtIndex:index.integerValue];
        if (store) {
            
            marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-red-%@", store.subCategoryId]];
        }
        
        self.previouMarker = marker;
    }
}

- (void)unSelectMarker:(GMSMarker*)marker{
    
    if (marker.userData) {
        
        NSNumber *index = marker.userData;
        FZStore *store = [self.stores objectAtIndex:index.integerValue];
        if (store) {
            
            marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-white-%@", store.subCategoryId]];
        }
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    self.isShowInfoView = NO;
    [self updateInfoView];
}

#pragma mark - ClubStoreTableViewCellDelegate
- (void)clubStoreCellTapped:(NSDictionary *)dict flashMode:(BOOL)flashMode{
    
    ClubStoreViewController *storeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreView"];
    storeView.dict = dict;
    storeView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:storeView animated:YES];
}

- (void)viewAllButtonPressed:(NSArray *)array title:(NSString *)title flashMode:(BOOL)flashMode{
    
    ClubStoreListViewController *storeListView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreListView"];
    storeListView.array = array;
    storeListView.titleString = title;
    [self.navigationController pushViewController:storeListView animated:YES];
}

#pragma mark - ClubSearchBarTableViewCellDelegate
- (void)searchButtonPressed{
    
    ClubSearchViewController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubSearchView"];
    searchView.clubStores = self.clubStores;
    searchView.clubPlaces = self.clubPlaces;
    UINavigationController *searchNavigation = [[UINavigationController alloc] initWithRootViewController:searchView];
    searchNavigation.navigationBarHidden = YES;
    [self presentViewController:searchNavigation animated:YES completion:nil];
}

#pragma mark - ClubPopularCategoryTableViewCellDelegate
- (void)categoryCellTapped:(NSDictionary *)category{
    
    ClubSubCategoryViewController *subCategoryView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubSubCategoryView"];
    subCategoryView.category = category;
    subCategoryView.clubStores = self.clubStores;
    subCategoryView.clubPlaces = self.clubPlaces;
    subCategoryView.brandType = self.brandType;
    
    [self.navigationController pushViewController:subCategoryView animated:YES];
}

#pragma mark - FZLocationSettingViewDelegate
- (void)settingButtonPressed{
    [self hideLocationSettingView];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)laterButtonPressed{
    [self hideLocationSettingView];
}

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)modeButtonPressed:(id)sender {
    
    if (!self.clubStores) {
        return;
    }
    
    self.isMapMode = !self.isMapMode;
    
    [self updateModeButton];
    
    if (self.isMapMode) {
        
        [self showMap];
        
    } else {
        
        [self showList];
        
    }
    
}

- (IBAction)locationButtonPressed:(id)sender {
    
    if (![CLLocationManager locationServicesEnabled]) {
        [self showLocationSettingView];
    } else{
        if ([FZData sharedInstance].currentLocation != nil) {
            [self.mapView animateWithCameraUpdate:[GMSCameraUpdate setTarget:[FZData sharedInstance].currentLocation.coordinate zoom:16]];
        } else{
            [self.mapView animateWithCameraUpdate:[GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(1.400270, 103.831959) zoom:11]];
        }
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            [self showLocationSettingView];
        }
    }
}

- (void)showLocationSettingView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (![self.locationSettingView isDescendantOfView:window]) {
        [window addSubview:self.locationSettingView];
        self.locationSettingView.frame = window.frame;
        self.locationSettingView.delegate = self;
    }
}

- (void)hideLocationSettingView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([self.locationSettingView isDescendantOfView:window]) {
        [self.locationSettingView removeFromSuperview];
    }
}

- (void)updateModeButton{
    
    if (self.isMapMode) {
        
        [self.btnMode setImage:[UIImage imageNamed:@"icon-list"] forState:UIControlStateNormal];
        
    } else {
        
        [self.btnMode setImage:[UIImage imageNamed:@"icon-location-white"] forState:UIControlStateNormal];
        
    }
}

- (void)showList{
    
    self.mapContainer.hidden = YES;
    self.tableView.hidden = NO;
    
    self.isShowInfoView = NO;
    [self updateInfoView];
    
}

- (void)showMap{
    
    self.mapContainer.hidden = NO;
    self.tableView.hidden = YES;
    
    [self initMap];
    [self updateInfoView];
}

- (void)initMap{
    
    [self.mapView clear];
    
    if ([FZData sharedInstance].currentLocation) {
        self.camera = [GMSCameraPosition cameraWithLatitude:[FZData sharedInstance].currentLocation.coordinate.latitude
                                                  longitude:[FZData sharedInstance].currentLocation.coordinate.longitude
                                                       zoom:11];
    } else{
        self.camera = [GMSCameraPosition cameraWithLatitude:1.400270
                                                  longitude:103.831959
                                                       zoom:11];
    }
    
    self.mapView.camera = self.camera;
    
    NSMutableArray *markers = [NSMutableArray new];
    for (int i = 0 ; i < self.stores.count; i ++) {
        
        FZStore *store = [self.stores objectAtIndex:i];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([store.latitude doubleValue], [store.longitude doubleValue]);
        marker.userData = [NSNumber numberWithInt:i];
        marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-white-%@", store.subCategoryId]];
        marker.map = self.mapView;
        
        [markers addObject:marker];
    }
    
    self.markers = markers;
}

- (void)updateInfoView{
    
    if (self.isShowInfoView) {
        
        self.iCarouel.hidden = NO;
        self.myLocationButtonBottomConstraint.constant = 146.0f;
        
    } else {
        
        self.iCarouel.hidden = YES;
        self.myLocationButtonBottomConstraint.constant = 16.0f;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
