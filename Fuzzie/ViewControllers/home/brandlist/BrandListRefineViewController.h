//
//  BrandListRefineViewController.h
//  Fuzzie
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrandListRefineViewControllerDelegate <NSObject>

- (void)refineViewDoneButtonPressed;

@end

@interface BrandListRefineViewController : FZBaseViewController

@property (nonatomic, strong) NSArray *subCategories;
@property (weak, nonatomic) id<BrandListRefineViewControllerDelegate> delegate;

@end
