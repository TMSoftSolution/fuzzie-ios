//
//  NearMeViewController.m
//  Fuzzie
//
//  Created by mac on 7/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "NearMeViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "StoreInfoSliderView.h"
#import "NearMeFilterViewController.h"
#import "PackageListViewController.h"
#import "CardViewController.h"
#import "PackageViewController.h"
#import "FZLocationSettingView.h"
#import "NearByListTableViewCell.h"

@interface NearMeViewController () <GMSMapViewDelegate,  NearMeFilterViewControllerDelegate, StoreInfoSliderViewDelegate, FZLocationSettingViewDelegate, UITableViewDataSource, UITableViewDelegate, NearByListTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *storeInfoContainerView;
@property (strong, nonatomic) StoreInfoSliderView *storeInfoSliderView;
@property (weak, nonatomic) IBOutlet UIImageView *filterChcked;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (weak, nonatomic) IBOutlet UIView *listContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *segmentContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (strong, nonatomic) FZLocationSettingView *locationSettingView;

@property (strong, nonatomic) GMSMarker *previouMarker;
@property (strong, nonatomic) GMSCameraPosition *camera;

@property (strong, nonatomic) NSArray *storeArray;
@property (strong, nonatomic) NSArray *storeListArray;

- (IBAction)filterButtonPressed:(id)sender;
- (IBAction)locationButtonPressed:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;

@end

@implementation NearMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setStyling];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[AppDelegate sharedAppDelegate] startLocationService];
    
    [self updateFilterChecked];
    
    if (![FZData sharedInstance].isSelectedStore) {
        [self initMap];
        [self hideStoresInfoView];
    }
    
    if (![FZData sharedInstance].isSelectedList) {
        [self.segment setSelectedSegmentIndex:0];
        [self segmentChanged:self.segment];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[AppDelegate sharedAppDelegate] stopLocationService];
    
    if (![FZData sharedInstance].isSelectedStore) {
        if (self.previouMarker) {
            [self unSelectMarker:self.previouMarker];
        }
        self.previouMarker = nil;
        
        [self hideStoresInfoView];
    }
}


- (void)setStyling{
    
    UINib *nib = [UINib nibWithNibName:@"StoreInfoSliderView" bundle:nil];
    self.storeInfoSliderView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.storeInfoSliderView.delegate = self;
    [self.storeInfoContainerView addSubview:self.storeInfoSliderView];
    [self hideStoresInfoView];
    
    UINib *nib1 = [UINib nibWithNibName:@"FZLocationSettingView" bundle:nil];
    self.locationSettingView = [[nib1 instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    [self.segmentContainer setBackgroundColor:[UIColor colorWithHexString:HEX_COLOR_RED]];
    UIFont *font = [UIFont fontWithName:FONT_NAME_LATO_REGULAR size:13.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    UINib *nearbyCell = [UINib nibWithNibName:@"NearByListTableViewCell" bundle:nil];
    [self.tableView registerNib:nearbyCell forCellReuseIdentifier:@"nearByCell"];

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.storeInfoSliderView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 0.625);
    [self.storeInfoSliderView initSliderIfNeeded];

}

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self showMap];
        [self hideList];
        [FZData sharedInstance].isSelectedList = NO;
    } else{
        [self showList];
        [self hideMap];
        [FZData sharedInstance].isSelectedList = YES;
    }
}

- (void)initMap{

    if ([FZData sharedInstance].currentLocation) {
        self.camera = [GMSCameraPosition cameraWithLatitude:[FZData sharedInstance].currentLocation.coordinate.latitude
                                                  longitude:[FZData sharedInstance].currentLocation.coordinate.longitude
                                                       zoom:16];
    } else{
        self.camera = [GMSCameraPosition cameraWithLatitude:1.400270
                                                  longitude:103.831959
                                                       zoom:11];
    }
    
    self.mapView.camera = self.camera;

    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    
    [self updateMap];
    
}

- (void)updateMap{
    
    [self.mapView clear];
    
    self.storeArray = [[NSArray alloc] init];
    
    if ([FZData sharedInstance].filterSubCategoryIds.count == 0 || [FZData sharedInstance].filterSubCategoryIds.count == [FZData sharedInstance].subCategoryArray.count) {
        self.storeArray = [FZData getStoreArray];;
    } else{
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSNumber *subId in [[FZData sharedInstance].filterSubCategoryIds allObjects]) {
            for (FZStore *store in [FZData getStoreArray]) {
                if ([subId isEqual:store.subCategoryId]) {
                    [temp addObject:store];
                }
            }
        }
        self.storeArray = temp;
    }
    
    for (NSString *key in [[FZData getSortedStores:self.storeArray] allKeys]) {
        
        NSArray *stores = [[FZData getSortedStores:self.storeArray] objectForKey:key];
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        if (stores) {
            
            FZStore *store = [stores objectAtIndex:0];
            
            if (stores.count == 1) {
                marker.position = CLLocationCoordinate2DMake([store.latitude doubleValue], [store.longitude doubleValue]);
                marker.title = key;
                marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-white-%@", store.subCategoryId]];
                marker.map = self.mapView;
            } else if(stores.count >= 2){
                marker.position = CLLocationCoordinate2DMake([store.latitude doubleValue], [store.longitude doubleValue]);
                marker.title = key;
                if (stores.count < 10) {
                    marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-white-number-%lu", (unsigned long)stores.count]];
                } else{
                    marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-white-number-10"]];
                }
                
                marker.map = self.mapView;
            }
        }

    }
    
}

- (void)showStoresInfoView:(NSArray*)stores{
    self.storeInfoContainerView.hidden = NO;
    [self.storeInfoSliderView setStoresInfo:stores];
}

- (void)hideStoresInfoView{
    self.storeInfoContainerView.hidden = YES;
    [self.storeInfoSliderView setStoresInfo:nil];
    [FZData sharedInstance].isSelectedStore = NO;
}

- (void)showMap{
    self.mapContainer.hidden = NO;
    
}

- (void)hideMap{
    self.mapContainer.hidden = YES;
    [self hideStoresInfoView];
    if (self.previouMarker) {
        [self unSelectMarker:self.previouMarker];
    }
}

- (void)showList{
    [self reloadList];
    self.listContainer.hidden = NO;
}

- (void)hideList{
    self.listContainer.hidden = YES;
}

- (void)reloadList{
    if ([FZData sharedInstance].currentLocation) {
        self.storeListArray = [self.storeArray sortedArrayUsingComparator:^NSComparisonResult(FZStore*  _Nonnull store1, FZStore*  _Nonnull store2) {
            
            CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[store1.latitude doubleValue] longitude:[store1.longitude doubleValue]];
            CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[store2.latitude doubleValue] longitude:[store2.longitude doubleValue]];
            CLLocationDistance distance1 = [[FZData sharedInstance].currentLocation distanceFromLocation:location1];
            CLLocationDistance distance2 = [[FZData sharedInstance].currentLocation distanceFromLocation:location2];
            
            if (distance1 > distance2) {
                return NSOrderedDescending;
            } else if (distance1 < distance2){
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
    } else{
        self.storeListArray = self.storeArray;
    }
    
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.tableView reloadData];
}

#pragma mark - GMSMapViewDelegate
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate setTarget:marker.position]];
    
    if (self.previouMarker && marker != self.previouMarker) {
        [self unSelectMarker:self.previouMarker];
    }
    
    if (marker != self.previouMarker) {
        [self selectMarker:marker];
    }
    
    return true;
}

- (void)selectMarker:(GMSMarker*)marker{
    if (marker.title) {
        
        NSArray *stores = [[FZData getSortedStores:self.storeArray] objectForKey:marker.title];
        if (stores) {
            FZStore *store = [stores objectAtIndex:0];
            if (stores.count == 1) {
                marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-red-%@", store.subCategoryId]];
            } else{
                if (stores.count < 10) {
                    marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-red-number-%lu", (unsigned long)stores.count]];
                } else{
                    marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-red-number-10"]];
                }
                
            }
            
            [self showStoresInfoView:stores];
        }
        
        self.previouMarker = marker;
        
    }
}

- (void)unSelectMarker:(GMSMarker*)marker{
    if (marker.title) {

        NSArray *stores = [[FZData getSortedStores:self.storeArray] objectForKey:marker.title];
        if (stores) {
            FZStore *store = [stores objectAtIndex:0];
            if (stores.count == 1) {
                marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-white-%@", store.subCategoryId]];
            } else{
                if (stores.count < 10) {
                    marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-white-number-%lu", (unsigned long)stores.count]];
                } else{
                    marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"map-white-number-10"]];
                }
                
            }
        }
    }
}



- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    if (self.previouMarker) {
        [self unSelectMarker:self.previouMarker];
        self.previouMarker = nil;
    }

    [self hideStoresInfoView];
}

#pragma mark - StoreInfoViewSliderDelegate
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state{
    [self likeBrand:brand withState:state];
}

- (void)storeInfoViewTapped:(FZBrand *)brand{

    [FZData sharedInstance].isSelectedStore = YES;
    
    [self showBrandDetails:brand];
}

- (IBAction)filterButtonPressed:(id)sender {
    NearMeFilterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NearMeFilterView"];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    [FZData sharedInstance].isSelectedStore = NO;
}

#pragma mark - NearMeFilterViewControllerDelegate
- (void)doneButtonClicked{
    [self updateMap];
    [self reloadList];
    [self updateFilterChecked];
}

- (void)updateFilterChecked{
    if ([FZData sharedInstance].filterSubCategoryIds.count == 0) {
        self.filterChcked.hidden = YES;
    } else{
        self.filterChcked.hidden = NO;
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

- (IBAction)searchButtonPressed:(id)sender {
    UIViewController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchView"];
    UINavigationController *searchNavigation = [[UINavigationController alloc] initWithRootViewController:searchView];
    searchNavigation.navigationBarHidden = YES;
    [self presentViewController:searchNavigation animated:YES completion:nil];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storeListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearByListTableViewCell *cell = (NearByListTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"nearByCell"];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NearByListTableViewCell *nearByCell = (NearByListTableViewCell*)cell;
    
    FZStore *store = [self.storeListArray objectAtIndex:indexPath.row];
    FZBrand *brand = [FZData getBrandById:store.brandId];
    if (store && brand) {
        [nearByCell setCellWithBrand:brand store:store];
    }
}

#pragma mark - NearByListTableViewCellDelegate
- (void)cellTapped:(FZBrand *)brand{
    [self showBrandDetails:brand];
}

- (void)likeButtonTappedOnList:(FZBrand *)brand WithState:(BOOL)state{
    [self likeBrand:brand withState:state];
}

- (void)showBrandDetails:(FZBrand*)brand{
    
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

#pragma mark - FZLocationSettingViewDelegate
- (void)settingButtonPressed{
    [self hideLocationSettingView];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
}

- (void)laterButtonPressed{
    [self hideLocationSettingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
}

@end
