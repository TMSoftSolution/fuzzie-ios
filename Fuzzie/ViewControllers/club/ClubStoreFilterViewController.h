//
//  ClubStoreFilterViewController.h
//  Fuzzie
//
//  Created by joma on 6/20/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"

@protocol ClubStoreFilterViewControllerDelegate <NSObject>

- (void)filterApplied:(NSMutableArray*)selectedBrandTypes;

@end;

@interface ClubStoreFilterViewController : FZBaseViewController

@property (weak, nonatomic) id<ClubStoreFilterViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *selectedBrandTypes;

@end
