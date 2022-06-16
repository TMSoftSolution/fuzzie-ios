//
//  ClubSubCategoryViewController.m
//  Fuzzie
//
//  Created by joma on 6/25/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSubCategoryViewController.h"
#import "ClubStoreListTableViewCell.h"
#import "ClubFilterTagCollectionViewCell.h"
#import "ClubSubCategoryFilterViewController.h"
#import "ClubStoreViewController.h"
#import "iCarousel.h"
#import "ClubStoreLocationInfoView.h"
#import "FZLocationSettingView.h"
#import "ClubSearchViewController.h"

@interface ClubSubCategoryViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ClubFilterTagCollectionViewCellDelegate, ClubStoreListTableViewCellDelegate, ClubSubCategoryFilterViewControllerDelegate, GMSMapViewDelegate, iCarouselDelegate, iCarouselDataSource, FZLocationSettingViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet iCarousel *iCarouel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myLocationButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnMode;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbFilterCounnt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterCountWidthConstraint;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)filterButtonPressed:(id)sender;
- (IBAction)locationButtonPressed:(id)sender;
- (IBAction)modeButtonPressed:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;

@property (strong, nonatomic) FZLocationSettingView *locationSettingView;

@end

@implementation ClubSubCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
    [self updateFilter];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[AppDelegate sharedAppDelegate] startLocationService];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[AppDelegate sharedAppDelegate] stopLocationService];
}

- (void) initData{
    
    self.selectedCategories = [NSMutableArray new];
    [self.selectedCategories addObject:self.category];
    
    self.selectedComponents = [NSMutableArray new];
}

- (void)updateFilter{
    
    if (self.selectedCategories.count + self.selectedComponents.count > 0) {
        
        self.collectionViewHeight.constant = 51.0f;
        self.filterCountWidthConstraint.constant = 20.0f;
        self.lbFilterCounnt.text = [NSString stringWithFormat:@"%ld", self.selectedCategories.count + self.selectedComponents.count];
        
    } else{
        
        self.collectionViewHeight.constant = 0.0f;
        self.filterCountWidthConstraint.constant = 0.0f;
    }
    
    [self.collectionView reloadData];
    
    NSMutableArray *temp;
    if (self.selectedCategories.count == 0) {
        
        temp = [[NSMutableArray alloc] initWithArray:self.clubStores];
        
    } else {
        
        temp  = [NSMutableArray new];
        
        for (NSDictionary *clubStore in self.clubStores) {
            
            for (NSDictionary *category in clubStore[@"categories"]) {
                
                if ([self.selectedCategories containsObject:category]) {
                    
                    [temp addObject:clubStore];
                    break;
                }
            }
        }
    }

    if (self.selectedComponents.count == 0) {
        
        self.filteredStores = temp;
        
    } else {
        
        self.filteredStores = [NSMutableArray new];
        
        for (NSDictionary *clubStore in temp) {
            
            for (NSDictionary *component in clubStore[@"filter_components"]) {
                
                if ([self.selectedComponents containsObject:component]) {
                    
                    [self.filteredStores addObject:clubStore];
                    break;
                }
            }
        }
    }
    
    [self.tableView reloadData];
    
    [self fetchStores];
}

- (void)fetchStores{
    
    NSMutableArray *temp = [NSMutableArray new];
    
    for (NSDictionary *dict in self.filteredStores) {
        
        FZStore *store = [FZData getStoreById:dict[@"store_id"]];
        if (store) {
            
            [temp addObject:store];
        }
    }
    
    self.stores = temp;
    
    if (self.isMapMode) {
        
        [self showMap];
        
    } else {
        
        [self showList];
        
    }
    
    [self.iCarouel reloadData];
}

- (void)setStyling{
    
    self.lbTitle.text = [self.brandType[@"name"] uppercaseString];
    
    UINib *nib = [UINib nibWithNibName:@"ClubStoreListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    UINib *tagNib = [UINib nibWithNibName:@"ClubFilterTagCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:tagNib forCellWithReuseIdentifier:@"TagCell"];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.estimatedItemSize = CGSizeMake(100.0f, 30.0f);
    
    [CommonUtilities setView:self.searchView withBackground:[UIColor colorWithHexString:@"#F1F1F1"] withRadius:2.5f];
    [CommonUtilities setView:self.lbFilterCounnt withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:10.0f];
    
    UINib *nib1 = [UINib nibWithNibName:@"FZLocationSettingView" bundle:nil];
    self.locationSettingView = [[nib1 instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    
    [self updateModeButton];
    
    self.iCarouel.delegate = self;
    self.iCarouel.dataSource = self;
    self.iCarouel.type = iCarouselTypeLinear;
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredStores.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClubStoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell setCell:self.filteredStores[indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectedCategories.count + self.selectedComponents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ClubFilterTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.selectedCategories.count) {
        
        [cell setCell:self.selectedCategories[indexPath.row]];
        
    } else {
        
        [cell setCell:self.selectedComponents[indexPath.row - self.selectedCategories.count]];
    }
    
    cell.delegate = self;
    return cell;
}

#pragma mark - ClubStoreListTableViewCellDelegate
- (void)clubStoreListCellTapped:(NSDictionary *)dict{
    
    ClubStoreViewController *storeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreView"];
    storeView.dict = dict;
    [self.navigationController pushViewController:storeView animated:YES];
}

#pragma mark - ClubFilterTagCollectionViewCellDelegate
- (void)tagDeleteButtonPressed:(NSDictionary *)dict{
    
    if ([self.selectedCategories containsObject:dict]) {
        [self.selectedCategories removeObject:dict];
    }
    
    if ([self.selectedComponents containsObject:dict]) {
        [self.selectedComponents removeObject:dict];
    }
    
    [self updateFilter];

}

#pragma mark - ClubSubCategoryFilterViewControllerDelegate
- (void)filterApplied:(NSMutableArray *)selectedCategories components:(NSMutableArray *)selectedComponents{
    
    self.selectedCategories = selectedCategories;
    self.selectedComponents = selectedComponents;
    
    [self updateFilter];
}

#pragma mark - FZLocationSettingViewDelegate
- (void)settingButtonPressed{
    [self hideLocationSettingView];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)laterButtonPressed{
    [self hideLocationSettingView];
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    return self.filteredStores.count;
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
        
        NSDictionary *dict = self.filteredStores[index];
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
    
    if (!self.markerClicked && self.isShowInfoView) {
        
        GMSMarker *marker = [self.markers objectAtIndex:carousel.currentItemIndex];
        
        if (marker) {
            [self handleMarkerSelect:marker];
        }
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

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterButtonPressed:(id)sender {
    
    ClubSubCategoryFilterViewController *filterView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubSubCategoryFilterView"];
    filterView.brandType = self.brandType;
    filterView.selectedCategories = self.selectedCategories;
    filterView.selectedComponents = self.selectedComponents;
    filterView.delegate = self;
    [self presentViewController:filterView animated:YES completion:nil];
    
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


- (IBAction)modeButtonPressed:(id)sender {
    
    self.isMapMode = !self.isMapMode;
    
    [self updateModeButton];
    
    if (self.isMapMode) {
        
        [self showMap];
        
    } else {
        
        [self showList];
        
    }
}

- (IBAction)searchButtonPressed:(id)sender {
    
    ClubSearchViewController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubSearchView"];
    searchView.clubStores = self.clubStores;
    searchView.clubPlaces = self.clubPlaces;
    UINavigationController *searchNavigation = [[UINavigationController alloc] initWithRootViewController:searchView];
    searchNavigation.navigationBarHidden = YES;
    [self presentViewController:searchNavigation animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
