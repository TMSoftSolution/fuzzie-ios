//
//  ClubFavoriteViewController.h
//  Fuzzie
//
//  Created by joma on 6/26/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"

@interface ClubFavoriteViewController : FZBaseViewController

@property (strong, nonatomic) NSMutableArray *clubStores;
@property (strong, nonatomic) NSMutableArray *filteredStores;
@property (strong, nonatomic) NSArray *sortedStores;

@property (strong, nonatomic) NSMutableArray *selectedBrandTypes;
@property (assign, nonatomic) BOOL sortDistance;

@end
