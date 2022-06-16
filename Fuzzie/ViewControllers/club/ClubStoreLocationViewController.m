//
//  ClubStoreLocationViewController.m
//  Fuzzie
//
//  Created by joma on 6/14/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreLocationViewController.h"
#import "ClubStoreLocationTableViewCell.h"
#import "ClubStoreLocationInfoView.h"
#import "iCarousel.h"
#import "FZLocationSettingView.h"
#import "ClubStoreViewController.h"

@interface ClubStoreLocationViewController () <UITableViewDelegate, UITableViewDataSource, ClubStoreLocationTableViewCellDelegate, GMSMapViewDelegate, iCarouselDelegate, iCarouselDataSource, FZLocationSettingViewDelegate>

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

@implementation ClubStoreLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
    [self showList];
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
}

- (void)setStyling{
    
    UINib *locationCellNib = [UINib nibWithNibName:@"ClubStoreLocationTableViewCell" bundle:nil];
    [self.tableView registerNib:locationCellNib forCellReuseIdentifier:@"LocationCell"];
    
    
    UINib *nib1 = [UINib nibWithNibName:@"FZLocationSettingView" bundle:nil];
    self.locationSettingView = [[nib1 instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    
    [self updateModeButton];
    
    self.iCarouel.delegate = self;
    self.iCarouel.dataSource = self;
    self.iCarouel.type = iCarouselTypeLinear;
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

- (void)updateModeButton{
    
    if (self.isMapMode) {
        
        [self.btnMode setImage:[UIImage imageNamed:@"icon-list"] forState:UIControlStateNormal];
        
    } else {
        
        [self.btnMode setImage:[UIImage imageNamed:@"icon-location-white"] forState:UIControlStateNormal];
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.clubStores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClubStoreLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    [cell setCellWith:self.clubStores[indexPath.row]];
    cell.delegate = self;
    return cell;
    
}

#pragma mark - ClubStoreLocationTableViewCellDelegate
- (void)storeLocationCellTapped:(NSDictionary *)dict{
    
    [self chooseStore:dict];

}

- (void)chooseStore:(NSDictionary*)dict{
    
    if (self.showStore) {
        
        ClubStoreViewController *storeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubStoreView"];
        storeView.dict = dict;
        [self.navigationController pushViewController:storeView animated:YES];
        
    } else {

        if ([self.delegate respondsToSelector:@selector(storeSelected:)]) {
            self.isShowInfoView = NO;
            [self updateInfoView];
            [self.delegate storeSelected:dict];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
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
    
    [self chooseStore:[self.clubStores objectAtIndex:index]];
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

#pragma mark - IBAction Helper
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

#pragma mark - FZLocationSettingViewDelegate
- (void)settingButtonPressed{
    [self hideLocationSettingView];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)laterButtonPressed{
    [self hideLocationSettingView];
}
@end
