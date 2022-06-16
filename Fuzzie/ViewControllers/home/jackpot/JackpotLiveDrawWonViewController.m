//
//  JackpotLiveDrawWonViewController.m
//  Fuzzie
//
//  Created by mac on 9/28/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "JackpotLiveDrawWonViewController.h"

@interface JackpotLiveDrawWonViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ivBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;

- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end

@implementation JackpotLiveDrawWonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnBack withBackground:[UIColor whiteColor] withRadius:4.0f];
    [CommonUtilities setView:self.btnShare withBackground:[UIColor clearColor] withRadius:4.0f withBorderColor:[UIColor whiteColor] withBorderWidth:1.0f];
    self.lbBody.text = [NSString stringWithFormat:@"Congrats %@! An email will be sent after the draw with details on how you can claim your prize.", [UserController sharedInstance].currentUser.firstName];
    self.lbPrice.text = [NSString stringWithFormat:@"S$%d",self.amount];
}

#pragma mark - IBAction Helper
- (IBAction)shareButtonPressed:(id)sender {
    NSString *body = [NSString stringWithFormat:@"I won S$%d cash on the Fuzzie Jackpot! You too can win awesome cash prizes on the Fuzzie Jackpot every week. Check it out: https://fuzzie.com.sg/jackpot", self.amount];
    NSArray *activityItems = @[body];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
 
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
