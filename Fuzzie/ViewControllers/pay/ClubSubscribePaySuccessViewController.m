//
//  ClubSubscribePaySuccessViewController.m
//  Fuzzie
//
//  Created by joma on 6/18/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubSubscribePaySuccessViewController.h"
#import "FZTabBarViewController.h"

@interface ClubSubscribePaySuccessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *successDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)actionButtonPressed:(id)sender;

@end

@implementation ClubSubscribePaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.actionButton withCornerRadius:4.0f];
    
    self.successDescriptionLabel.text = [NSString stringWithFormat:@"Great work, %@! You now have full access to all Fuzzie Club Offers.", [UserController sharedInstance].currentUser.firstName];
}

- (void)actionButtonPressed:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CLUB_SUBSCRIBE_SUCCESS object:nil];
    
    FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tabBarController setSelectedIndex:kTabBarItemClub];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
