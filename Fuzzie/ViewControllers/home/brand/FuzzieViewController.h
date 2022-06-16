//
//  FuzzieViewController.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 3/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZBrand.h"

@interface FuzzieViewController : FZBaseViewController
- (void)likeBrand:(FZBrand *)brand withState:(BOOL)state;
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state cell:(UITableViewCell *)cell;
- (void)wishListBrand:(FZBrand *)brand withState:(BOOL)state;
- (void)showErrorAlertTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle;
@end
