//
//  ClubOfferViewController.h
//  Fuzzie
//
//  Created by joma on 6/20/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"

@interface ClubOfferViewController : FZBaseViewController

@property (strong, nonatomic) NSDictionary *offer;
@property (strong, nonatomic) NSDictionary *clubStore;
@property (strong, nonatomic) NSArray *moreStores;
@property (assign, nonatomic) BOOL isFlashSale;
@property (assign, nonatomic) BOOL isOnline;

@end
