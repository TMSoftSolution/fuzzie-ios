//
//  ClubFavoriteFilterViewController.h
//  Fuzzie
//
//  Created by joma on 8/31/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "FZBaseViewController.h"

@protocol ClubFavoriteFilterViewControllerDelegate <NSObject>

- (void)filterApplied:(NSMutableArray*)selectedBrandTypes sortDistance:(BOOL)sortDistance;

@end;

@interface ClubFavoriteFilterViewController : FZBaseViewController

@property (weak, nonatomic) id<ClubFavoriteFilterViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *selectedBrandTypes;
@property (assign, nonatomic) BOOL sortDistance;

@end
