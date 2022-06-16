//
//  FuzzieViewController.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 3/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FuzzieViewController.h"
#import "JoinViewController.h"

@interface FuzzieViewController ()

@end

@implementation FuzzieViewController

- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state cell:(UITableViewCell *)cell {
    [self likeBrand:brand withState:state];
}

- (void)likeBrand:(FZBrand *)brand withState:(BOOL)state {
    
    if (brand) {
        if (![UserController sharedInstance].currentUser) {
            
            JoinViewController *joinView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"JoinView"];
            joinView.showCloseButton = YES;
            UINavigationController *joinNavigation = [[UINavigationController alloc] initWithRootViewController:joinView];
            
            [self presentViewController:joinNavigation animated:YES completion:nil];
            return;
        }
        
        bool isLiked = state;
        
        [UserController likeBrandWithId:brand.brandId isLike:isLiked];
        
        if (isLiked) {
            
            [BrandController addLikeToBrand:brand.brandId withCompletion:^(NSError *error) {
                if (error) {
                    if (error.code == 417) {
                        [AppDelegate logOut];
                        return ;
                    }
                    brand.isLiked = @(NO);
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:LIKE_REMOVED_IN_BRAND
                     object:nil
                     userInfo:@{@"brand":brand, @"nbLike":brand.likersCount}];
                    
                    [self showErrorAlertTitle:@"Add to like Error" message:[error localizedDescription]  buttonTitle:@"OK"];                }
                else {
                    
                    brand.isLiked = @(YES);
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:LIKE_ADDED_IN_BRAND
                     object:nil
                     userInfo:@{@"brand":brand, @"nbLike":brand.likersCount}];
                }
            }];
        } else {
            [BrandController removeLikeToBrand:brand.brandId withCompletion:^(NSError *error) {
                if (error) {
                    
                    if (error.code == 417) {
                        [AppDelegate logOut];
                        return ;
                    }
                    
                    brand.isLiked = @(YES);
        
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:LIKE_ADDED_IN_BRAND
                     object:nil
                     userInfo:@{@"brand":brand, @"nbLike":brand.likersCount}];
     
                    [self showErrorAlertTitle:@"Remove from like Error" message:[error localizedDescription]  buttonTitle:@"OK"];
                   
                } else {
                    brand.isLiked = @(NO);
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:LIKE_REMOVED_IN_BRAND
                     object:nil
                     userInfo:@{@"brand":brand, @"nbLike":brand.likersCount}];
                    
                }
            }];
        }
        
    }
}


- (void)wishListBrand:(FZBrand *)brand withState:(BOOL)state {
    
    if (brand) {
        
        if (![UserController sharedInstance].currentUser) {

            JoinViewController *joinView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"JoinView"];
            joinView.showCloseButton = YES;
            UINavigationController *joinNavigation = [[UINavigationController alloc] initWithRootViewController:joinView];
            
            brand.isWishListed = @(NO);
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:BRAND_REMOVED_IN_WHISHLIST
             object:nil
             userInfo:@{@"brand":brand}];
            
            [self presentViewController:joinNavigation animated:YES completion:nil];
            return;
        }
        
        bool isInWhishlist = state;
        
        [UserController wishListBrandWithId:brand.brandId isWish:isInWhishlist];
        
        if (isInWhishlist) {
            
            [BrandController addBrandToWishList:brand.brandId withCompletion:^(NSError *error) {
                if (error) {
                    if (error.code == 417) {
                        [AppDelegate logOut];
                        return ;
                    }
                    brand.isWishListed = @(NO);
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:BRAND_REMOVED_IN_WHISHLIST
                     object:nil
                     userInfo:@{@"brand":brand}];
                    
                    [self showErrorAlertTitle:@"Add to Wishlist Error" message:[error localizedDescription] buttonTitle:@"OK"];
                } else {
                    
                    brand.isWishListed = @(YES);
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:BRAND_ADDED_IN_WHISHLIST
                     object:nil
                     userInfo:@{@"brand":brand}];
                }
            }];
        } else {
            [BrandController removeBrandFromWishList:brand.brandId withCompletion:^(NSError *error) {
                if (error) {
                    if (error.code == 417) {
                        [AppDelegate logOut];
                        return ;
                    }
                    brand.isWishListed = @(YES);
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:BRAND_ADDED_IN_WHISHLIST
                     object:nil
                     userInfo:@{@"brand":brand}];
                    
                    [self showErrorAlertTitle:@"Remove from Wishlist Error" message:[error localizedDescription] buttonTitle:@"OK"];
                } else {
                    brand.isWishListed = @(NO);
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:BRAND_REMOVED_IN_WHISHLIST
                     object:nil
                     userInfo:@{@"brand":brand}];
                }
            }];
        }
    }
}


- (void)showErrorAlertTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
