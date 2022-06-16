//
//  BrandListCategoryFilterViewController.h
//  Fuzzie
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrandListCategoryFilterViewControllerDelegate <NSObject>

- (void)filterViewDoneButtonPressed;

@end

@interface BrandListCategoryFilterViewController : FZBaseViewController

@property (weak, nonatomic) id<BrandListCategoryFilterViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *categoriesArray;

@end
