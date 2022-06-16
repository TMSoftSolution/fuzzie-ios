//
//  ClubStoreListViewController.h
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"

@interface ClubStoreListViewController : FZBaseViewController

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property (assign, nonatomic) BOOL flashMode;
@property (assign, nonatomic) BOOL hideFilter;
@property (strong, nonatomic) NSMutableArray *selectedBrandTypes;

@end
