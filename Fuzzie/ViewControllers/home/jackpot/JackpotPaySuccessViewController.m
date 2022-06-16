//
//  JackpotPaySuccessViewController.m
//  Fuzzie
//
//  Created by Joma on 1/17/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "JackpotPaySuccessViewController.h"
#import "JackpotTicketsUseViewController.h"
#import "FZTabBarViewController.h"
#import "GiftBoxViewController.h"

@interface JackpotPaySuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UILabel *lbDrawDate;
@property (weak, nonatomic) IBOutlet UILabel *lbLive;
@property (weak, nonatomic) IBOutlet UILabel *lbGreat;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;

- (IBAction)joinButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end

@implementation JackpotPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStyling];
}

- (void)setStyling{
    
    [CommonUtilities setView:self.btnJoin withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    
    [CommonUtilities setView:self.btnSave withCornerRadius:4.0f withBorderColor:[UIColor whiteColor] withBorderWidth:1.0f];
    
    self.lbGreat.text = [[NSString stringWithFormat:@"WELL DONE %@!", [UserController sharedInstance].currentUser.firstName] uppercaseString];
    
    if (self.isPowerUpPack) {
        self.lbBody.text = @"Your purchase and Jackpot tickets have been added to your wallet.";
    }
    
    NSString *drawTimeString;
    if ([FZData isCuttingOffLiveDraw]) {
        drawTimeString = [FZData sharedInstance].jackpotNextDrawTime;
    } else{
        drawTimeString = [FZData sharedInstance].jackpotDrawTime;
    }
    
    if (drawTimeString && ![drawTimeString isKindOfClass:[NSNull class]] && ![drawTimeString isEqualToString:@""]) {
        NSDate *drawDate = [[GlobalConstants standardFormatter] dateFromString:drawTimeString];
        self.lbDrawDate.text = [[GlobalConstants jackpotChooseFormatter] stringFromDate:drawDate];
    } else{
        self.lbDrawDate.hidden = YES;
        self.lbLive.hidden = YES;
    }
}

- (void)goToWalletPage {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_DISMISS_VIEW object:nil];
    
    FZTabBarViewController *tabBarController = (FZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tabBarController setSelectedIndex:kTabBarItemWallet];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)joinButtonPressed:(id)sender {
    
    JackpotTicketsUseViewController *useView = [self.storyboard instantiateViewControllerWithIdentifier:@"JackpotTicketsUseView"];
    [self.navigationController pushViewController:useView animated:YES];
    
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [self goToWalletPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
