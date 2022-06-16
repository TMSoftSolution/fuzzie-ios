//
//  RateExperienceViewController.m
//  Fuzzie
//
//  Created by mac on 8/2/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "RateExperienceViewController.h"
#import "RateThanksViewController.h"
#import "RateSorryViewController.h"

@interface RateExperienceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIButton *btnThanks;

@end

@implementation RateExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnThanks withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.noButton withCornerRadius:5.0f withBorderColor:[UIColor colorWithHexString:HEX_COLOR_RED] withBorderWidth:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender {
    [FZData sharedInstance].isShowingRatePage = false;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)thanksButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        RateThanksViewController *thanksView = [self.storyboard instantiateViewControllerWithIdentifier:@"RateThanksView"];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate.window.rootViewController presentViewController:thanksView animated:YES completion:nil];
    }];
    

}

- (IBAction)noButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        RateSorryViewController *sorryView = [self.storyboard instantiateViewControllerWithIdentifier:@"RateSorryView"];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate.window.rootViewController presentViewController:sorryView animated:YES completion:nil];

    }];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

@end
