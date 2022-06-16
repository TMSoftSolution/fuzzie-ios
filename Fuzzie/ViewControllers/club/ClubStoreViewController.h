//
//  ClubStoreViewController.h
//  Fuzzie
//
//  Created by joma on 6/11/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"

@interface ClubStoreViewController : FZBaseViewController

@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) FZBrand *brand;
@property (strong, nonatomic) FZStore *store;
@property (strong, nonatomic) NSArray *offers;
@property (assign, nonatomic) BOOL showTripAdvisor;
@property (strong, nonatomic) NSArray *relatedStores;
@property (strong, nonatomic) NSArray *nearbyStores;
@property (strong, nonatomic) NSArray *moreStores;
@property (assign, nonatomic) BOOL isOnline;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end
