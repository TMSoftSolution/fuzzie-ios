//
//  ClubCategoryViewController.h
//  Fuzzie
//
//  Created by joma on 6/24/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ClubCategoryViewController : FZBaseViewController

@property (strong, nonatomic) NSDictionary *brandType;

@property (strong, nonatomic) NSArray *trendingStores;
@property (strong, nonatomic) NSArray *nearbyStores;
@property (strong, nonatomic) NSArray *freshStores;
@property (strong, nonatomic) NSArray *categories;

@property (strong, nonatomic) NSArray *clubStores;
@property (strong, nonatomic) NSArray *clubPlaces;

@property (strong, nonatomic) NSArray *stores;
@property (strong, nonatomic) NSArray *markers;
@property (assign, nonatomic) BOOL isMapMode;
@property (assign, nonatomic) BOOL isShowInfoView;
@property (assign, nonatomic) BOOL markerClicked;

@property (strong, nonatomic) GMSMarker *previouMarker;
@property (strong, nonatomic) GMSCameraPosition *camera;

@end
