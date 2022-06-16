//
//  BrandViewController.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 3/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandViewController.h"
#import "JoinViewController.h"
#import "GiftItHowItWorksViewController.h"

@interface BrandViewController ()

@end

@implementation BrandViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerNav.backgroundColor = [UIColor clearColor];
    self.backgroundNav.alpha = 0;

}


- (void)showGiftingAvailableView{
    UINib *nib = [UINib nibWithNibName:@"GiftingAvailableView" bundle:nil];
    self.giftingAvailableView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.giftingAvailableView.delegate = self;
    [self.view addSubview:self.giftingAvailableView];
    self.giftingAvailableView.frame = self.view.frame;
    
}

- (void)hideGiftingAvailableView{
    [self.giftingAvailableView removeFromSuperview];
}

#pragma mark - GiftingAvailableViewDelegate
- (void)gotItButtonPressed{
    [UserController setDisplayGiftingPage:false withErrorBlock:^(NSError *error) {
       
        [self hideGiftingAvailableView];

        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            
            [UserController sharedInstance].currentUser.displayGiftingPage = @(YES);
        } else{
            [UserController sharedInstance].currentUser.displayGiftingPage = @(NO);
        }
    }];

}

- (void)howItWorkButtonPressed{

    GiftItHowItWorksViewController *vc = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"GiftItHowItWorksView"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
