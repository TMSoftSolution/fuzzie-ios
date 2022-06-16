//
//  BrandListSortViewController.h
//  Fuzzie
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrandListSortViewControllerDelegate <NSObject>

- (void)changeSortItem;

@end

@interface BrandListSortViewController : FZBaseViewController

@property (weak, nonatomic) id<BrandListSortViewControllerDelegate> delegate;

@end
