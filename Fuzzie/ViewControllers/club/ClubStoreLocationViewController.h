//
//  ClubStoreLocationViewController.h
//  Fuzzie
//
//  Created by joma on 6/14/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@protocol ClubStoreLocationViewControllerDelegate <NSObject>

- (void)storeSelected:(NSDictionary*)dict;

@end

@interface ClubStoreLocationViewController : FZBaseViewController

@property (assign, nonatomic) BOOL showStore;
@property (strong, nonatomic) NSArray *clubStores;
@property (strong, nonatomic) NSArray *stores;
@property (strong, nonatomic) NSArray *markers;
@property (assign, nonatomic) BOOL isMapMode;
@property (assign, nonatomic) BOOL isShowInfoView;
@property (assign, nonatomic) BOOL markerClicked;

@property (strong, nonatomic) GMSMarker *previouMarker;
@property (strong, nonatomic) GMSCameraPosition *camera;

@property (weak, nonatomic) id<ClubStoreLocationViewControllerDelegate> delegate;

@end
