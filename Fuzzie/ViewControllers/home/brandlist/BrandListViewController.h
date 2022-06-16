//
//  BrandListViewController.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuzzieViewController.h"

@interface BrandListViewController : FuzzieViewController

@property (strong, nonatomic) NSString *headerTitle;
@property (strong, nonatomic) NSArray *brandArray;
@property (strong, nonatomic) NSArray *sortedBrandArray;
@property (strong, nonatomic) NSArray *filteredBrandArray;
@property (assign, nonatomic) BOOL showFilter;
@property (assign, nonatomic) BOOL isCategory;

@end
